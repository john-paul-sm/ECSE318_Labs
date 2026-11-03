-- cache_pkg: shared constants and types
library ieee;
use ieee.std_logic_1164.all;

package cache_pkg is
  constant TPD : time := 1 ns;
  constant PERIOD : time := 100 ns;
  constant WAITS : integer := 4;
  subtype word is std_logic_vector(31 downto 0);
  subtype byte is std_logic_vector(7 downto 0);
end cache_pkg;

-- tag_ram: stores the tag + valid bit of each of the 256 cache lines
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cache_pkg.all;

entity tag_ram is
port (clk, we : in std_logic;
      index : in std_logic_vector(7 downto 0);
      tag_in : in std_logic_vector(5 downto 0);
      hit : out std_logic);
end tag_ram;

architecture behav of tag_ram is
  type tagarray is array (0 to 255) of std_logic_vector(5 downto 0);
  signal tags : tagarray;
  signal valids : std_logic_vector(0 to 255) := (others => '0');
begin

  tagwrite: process (clk) is
  begin
    if clk'event and clk = '1' then
      if we = '1' then
        tags(to_integer(unsigned(index))) <= tag_in after TPD;
        valids(to_integer(unsigned(index))) <= '1' after TPD;
      end if;
    end if;
  end process tagwrite;

  -- tag comparator
  hit <= '1' after TPD when valids(to_integer(unsigned(index))) = '1' and tags(to_integer(unsigned(index))) = tag_in
         else '0' after TPD;

end behav;

-- cache_ram: 256 x 32-bit data RAM
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cache_pkg.all;

entity cache_ram is
port (clk, we : in std_logic;
      index : in std_logic_vector(7 downto 0);
      din : in word;
      dout : out word);
end cache_ram;

architecture behav of cache_ram is
  type ramarray is array (0 to 255) of word;
  signal data : ramarray;
begin

  ramwrite: process (clk) is
  begin
    if clk'event and clk = '1' then
      if we = '1' then
        data(to_integer(unsigned(index))) <= din after TPD;
      end if;
    end if;
  end process ramwrite;

  dout <= data(to_integer(unsigned(index))) after TPD;

end behav;

-- controller: cache control FSM
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cache_pkg.all;

entity controller is
port (clk : in std_logic;
      -- processor interface
      Pstrobe : in std_logic;
      Prw : in std_logic;
      Paddress : in std_logic_vector(15 downto 0);
      Pdata : inout word;
      Pready : out std_logic;
      -- system bus interface
      Sysaddress : out std_logic_vector(15 downto 0);
      Sysdata : inout byte;
      Sysstrobe : out std_logic;
      Sysrw : out std_logic;
      -- tag RAM / cache RAM interface
      index : out std_logic_vector(7 downto 0) := (others => '0');
      tag : out std_logic_vector(5 downto 0);
      hit : in std_logic;
      cache_dout : in word;
      cache_din : out word;
      cache_we : out std_logic;
      tag_we : out std_logic);
end controller;

architecture fsm of controller is
begin

  control: process is
    type state_type is (IDLE, LOOKUP, SYSREQ, SYSWAIT, DONE);
    variable state : state_type := IDLE;
    variable addr : std_logic_vector(15 downto 0);
    variable rw : std_logic;
    variable wdata : word;
    variable fill : word;
    variable bcnt : integer range 0 to 3;
    variable wcnt : integer range 0 to WAITS + 1;
  begin
    -- initial values: buses tri-stated, controls inactive
    Pdata <= (others => 'Z');
    Pready <= '0';
    Sysaddress <= (others => 'Z');
    Sysdata <= (others => 'Z');
    Sysstrobe <= '0';
    Sysrw <= '1';
    index <= (others => '0');
    tag <= (others => '0');
    cache_we <= '0';
    tag_we <= '0';

    loop
      wait until clk = '1';

      case state is

        -- latch the processor request
        when IDLE =>
          if Pstrobe = '1' then
            addr := Paddress;
            rw := Prw;
            wdata := Pdata;
            index <= addr(9 downto 2) after TPD;
            tag <= addr(15 downto 10) after TPD;
            state := LOOKUP;
          end if;

        -- read hit: answer now, read miss: fill line, write: update cache + memory
        when LOOKUP =>
          if rw = '1' then
            if hit = '1' then
              Pdata <= cache_dout after TPD;
              Pready <= '1' after TPD;
              state := DONE;
            else
              bcnt := 0;
              state := SYSREQ;
            end if;
          else
            cache_din <= wdata after TPD;
            cache_we <= '1' after TPD;
            tag_we <= '1' after TPD;
            bcnt := 0;
            state := SYSREQ;
          end if;

        -- start one byte transfer on the system bus
        when SYSREQ =>
          cache_we <= '0' after TPD;
          tag_we <= '0' after TPD;
          Sysaddress <= addr(15 downto 2) & std_logic_vector(to_unsigned(bcnt, 2)) after TPD;
          Sysrw <= rw after TPD;
          Sysstrobe <= '1' after TPD;
          if rw = '0' then
            Sysdata <= wdata(8 * bcnt + 7 downto 8 * bcnt) after TPD;
          end if;
          wcnt := 0;
          state := SYSWAIT;

        -- wait out the wait states, capture the byte, then next byte or finish
        when SYSWAIT =>
          Sysstrobe <= '0' after TPD;
          if wcnt = WAITS + 1 then
            if rw = '1' then
              fill(8 * bcnt + 7 downto 8 * bcnt) := Sysdata;
            end if;
            Sysaddress <= (others => 'Z') after TPD;
            Sysdata <= (others => 'Z') after TPD;
            if bcnt = 3 then
              if rw = '1' then
                cache_din <= fill after TPD;
                cache_we <= '1' after TPD;
                tag_we <= '1' after TPD;
                Pdata <= fill after TPD;
              end if;
              Pready <= '1' after TPD;
              state := DONE;
            else
              bcnt := bcnt + 1;
              state := SYSREQ;
            end if;
          else
            wcnt := wcnt + 1;
          end if;

        -- end of processor transaction
        when DONE =>
          Pready <= '0' after TPD;
          Pdata <= (others => 'Z') after TPD;
          cache_we <= '0' after TPD;
          tag_we <= '0' after TPD;
          state := IDLE;

      end case;
    end loop;
  end process control;

end fsm;

-- cache: top level of the cache (tag RAM + cache RAM + controller)
library ieee;
use ieee.std_logic_1164.all;
use work.cache_pkg.all;

entity cache is
port (clk : in std_logic;
      Pstrobe : in std_logic;
      Prw : in std_logic;
      Paddress : in std_logic_vector(15 downto 0);
      Pdata : inout word;
      Pready : out std_logic;
      Sysaddress : out std_logic_vector(15 downto 0);
      Sysdata : inout byte;
      Sysstrobe : out std_logic;
      Sysrw : out std_logic);
end cache;

architecture struct of cache is
  signal index : std_logic_vector(7 downto 0);
  signal tag : std_logic_vector(5 downto 0);
  signal hit : std_logic;
  signal cache_din, cache_dout : word;
  signal cache_we, tag_we : std_logic;
begin

  tagmem : entity work.tag_ram(behav)
  port map (clk, tag_we, index, tag, hit);

  datamem : entity work.cache_ram(behav)
  port map (clk, cache_we, index, cache_din, cache_dout);

  ctrl : entity work.controller(fsm)
  port map (clk, Pstrobe, Prw, Paddress, Pdata, Pready,
            Sysaddress, Sysdata, Sysstrobe, Sysrw,
            index, tag, hit, cache_dout, cache_din, cache_we, tag_we);

end struct;

-- main_memory: system bus with 4 wait states, byte k holds (k mod 256)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cache_pkg.all;

entity main_memory is
port (clk : in std_logic;
      Sysstrobe : in std_logic;
      Sysrw : in std_logic;
      Sysaddress : in std_logic_vector(15 downto 0);
      Sysdata : inout byte);
end main_memory;

architecture behav of main_memory is
begin

  memory: process is
    type memarray is array (0 to 65535) of byte;
    variable store : memarray;
    variable a : natural;
    variable rw : std_logic;
  begin
    for k in 0 to 65535 loop
      store(k) := std_logic_vector(to_unsigned(k mod 256, 8));
    end loop;
    Sysdata <= (others => 'Z');

    loop
      wait until clk = '1';
      if Sysstrobe = '1' then
        a := to_integer(unsigned(Sysaddress));
        rw := Sysrw;
        if rw = '0' then
          store(a) := Sysdata;
        end if;
        for k in 1 to WAITS loop
          wait until clk = '1';
        end loop;
        if rw = '1' then
          Sysdata <= store(a) after TPD;
          wait until clk = '1';
          Sysdata <= (others => 'Z') after TPD;
        end if;
      end if;
    end loop;
  end process memory;

end behav;