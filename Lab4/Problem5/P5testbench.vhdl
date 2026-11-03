library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cache_pkg.all;

entity P5testbench is
end P5testbench;

architecture test of P5testbench is

  signal clk : std_logic := '0';
  signal done : boolean := false;

  -- processor interface
  signal Pstrobe : std_logic := '0';
  signal Prw : std_logic := '1';
  signal Paddress : std_logic_vector(15 downto 0) := (others => '0');
  signal Pdata : word := (others => 'Z');
  signal Pready : std_logic;

  -- system bus
  signal Sysaddress : std_logic_vector(15 downto 0);
  signal Sysdata : byte := (others => 'Z');
  signal Sysstrobe : std_logic;
  signal Sysrw : std_logic;

  -- hex string of a vector (length must be a multiple of 4)
  function hex(v : std_logic_vector) return string is
    constant digits : string(1 to 16) := "0123456789ABCDEF";
    variable vv : std_logic_vector(v'length - 1 downto 0) := v;
    variable s : string(1 to v'length / 4);
    variable nib : std_logic_vector(3 downto 0);
  begin
    for i in s'range loop
      nib := vv(v'length - 4 * (i - 1) - 1 downto v'length - 4 * i);
      if is_x(nib) then
        s(i) := 'X';
      else
        s(i) := digits(to_integer(unsigned(nib)) + 1);
      end if;
    end loop;
    return s;
  end hex;

begin

  -- 100 ns clock, stops when the test is done
  clkgen: process is
  begin
    while not done loop
      clk <= '0';
      wait for PERIOD / 2;
      clk <= '1';
      wait for PERIOD / 2;
    end loop;
    wait;
  end process clkgen;

  dut : entity work.cache(struct)
  port map (clk, Pstrobe, Prw, Paddress, Pdata, Pready,
            Sysaddress, Sysdata, Sysstrobe, Sysrw);

  mem : entity work.main_memory(behav)
  port map (clk, Sysstrobe, Sysrw, Sysaddress, Sysdata);

  processor: process is
    variable hits, misses : integer := 0;

    -- one processor transaction: rw = '1' read, rw = '0' write
    procedure access_mem(rw : in std_logic;
                         a : in std_logic_vector(15 downto 0);
                         wd : in word;
                         expect : in word) is
      variable t0 : time;
      variable cycles : integer;
    begin
      -- drive the request on a falling edge, away from the sampling edge
      wait until falling_edge(clk);
      Paddress <= a after TPD;
      Prw <= rw after TPD;
      if rw = '0' then
        Pdata <= wd after TPD;
      else
        Pdata <= (others => 'Z') after TPD;
      end if;
      Pstrobe <= '1' after TPD;

      -- the cache samples Pstrobe on this edge
      wait until rising_edge(clk);
      t0 := now;

      -- Pstrobe is high for one cycle only
      wait until falling_edge(clk);
      Pstrobe <= '0' after TPD;
      Pdata <= (others => 'Z') after TPD;

      if Pready /= '1' then
        wait until Pready = '1';
      end if;
      cycles := (now - t0) / PERIOD;

      if rw = '1' then
        assert Pdata = expect
          report "READ  " & hex(a) & ": got " & hex(Pdata) & ", expected " & hex(expect)
          severity error;
        if cycles = 1 then
          hits := hits + 1;
          report "READ  " & hex(a) & "  data=" & hex(Pdata) & "  cycles=" & integer'image(cycles) & "  HIT";
        else
          misses := misses + 1;
          report "READ  " & hex(a) & "  data=" & hex(Pdata) & "  cycles=" & integer'image(cycles) & "  MISS";
        end if;
      else
        report "WRITE " & hex(a) & "  data=" & hex(wd) & "  cycles=" & integer'image(cycles) & "  (write-through)";
      end if;

      -- end of transaction (DONE state)
      wait until Pready = '0';
    end access_mem;

    constant NONE : word := (others => '0');

  begin
    -- Part 1: assignment sequence (all reads, cold cache)
    -- memory byte k holds (k mod 256), so each word reads back as its own byte addresses
    access_mem('1', x"0012", NONE, x"13121110");  -- miss
    access_mem('1', x"0045", NONE, x"47464544");  -- miss
    access_mem('1', x"0076", NONE, x"77767574");  -- miss
    access_mem('1', x"0066", NONE, x"67666564");  -- miss
    access_mem('1', x"0076", NONE, x"77767574");  -- hit
    access_mem('1', x"0059", NONE, x"5B5A5958");  -- miss
    access_mem('1', x"0045", NONE, x"47464544");  -- hit
    access_mem('1', x"0012", NONE, x"13121110");  -- hit
    report "Sequence done: " & integer'image(hits) & " hits, " & integer'image(misses) & " misses (expected 3 hits, 5 misses)";

    -- Part 2: write-through check
    access_mem('0', x"0045", x"DEADBEEF", NONE);  -- updates cache line 17 and memory
    access_mem('1', x"0045", NONE, x"DEADBEEF");  -- hit, data from cache
    access_mem('1', x"0444", NONE, x"47464544");  -- index 17, tag 1: miss, evicts 0x45
    access_mem('1', x"0045", NONE, x"DEADBEEF");  -- miss, data from memory proves write-through

    report "Simulation done";
    done <= true;
    wait;
  end process processor;

end test;