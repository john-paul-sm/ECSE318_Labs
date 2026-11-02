library ieee;
use ieee.std_logic_1164.all;
 
entity dff is
    port (
        clk, reset, d : in  std_logic;
        q             : out std_logic
    );
end entity dff;
 
architecture rtl of dff is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                q <= '0';
            else
                q <= d;
            end if;
        end if;
    end process;
end architecture rtl;
 
library ieee;
use ieee.std_logic_1164.all;
 
entity full_adder is
    port (
        a, b, cin : in  std_logic;
        s, cout   : out std_logic
    );
end entity full_adder;
 
architecture gates of full_adder is
begin
    s    <= a xor b xor cin;
    cout <= (a and b) or (a and cin) or (b and cin);
end architecture gates;
 
library ieee;
use ieee.std_logic_1164.all;
 
entity shift_add_multiplier is
    generic (N : positive := 4);
    port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        load         : in  std_logic;
        multiplicand : in  std_logic_vector(N-1 downto 0);
        multiplier   : in  std_logic_vector(N-1 downto 0);
        product      : out std_logic_vector(2*N-1 downto 0);
        done         : out std_logic
    );
end entity shift_add_multiplier;
 
architecture structural of shift_add_multiplier is
    signal p_q, a_q, b_q, p_d, a_d, b_d : std_logic_vector(N-1 downto 0);
    signal addend, sum                  : std_logic_vector(N-1 downto 0);
    signal carry                        : std_logic_vector(N downto 0);
    signal t_q, t_d                     : std_logic_vector(N downto 0);
    signal en                           : std_logic;
begin
    carry(0) <= '0';
 
    adder : for i in 0 to N-1 generate
        addend(i) <= b_q(i) and a_q(0);
 
        fa : entity work.full_adder(gates)
            port map (a => p_q(i), b => addend(i), cin => carry(i),
                      s => sum(i), cout => carry(i+1));
    end generate adder;
 
    en <= not t_q(N);
 
    p_d <= (others => '0')            when load = '1' else
           carry(N) & sum(N-1 downto 1) when en = '1'   else
           p_q;
 
    a_d <= multiplier                 when load = '1' else
           sum(0) & a_q(N-1 downto 1)   when en = '1'   else
           a_q;
 
    b_d <= multiplicand when load = '1' else b_q;
 
    t_d <= (0 => '1', others => '0') when load = '1' else
           t_q(N-1 downto 0) & '0'   when en = '1'   else
           t_q;
 
    regs : for i in 0 to N-1 generate
        p_ff : entity work.dff(rtl)
            port map (clk => clk, reset => reset, d => p_d(i), q => p_q(i));
        a_ff : entity work.dff(rtl)
            port map (clk => clk, reset => reset, d => a_d(i), q => a_q(i));
        b_ff : entity work.dff(rtl)
            port map (clk => clk, reset => reset, d => b_d(i), q => b_q(i));
    end generate regs;
 
    counter : for i in 0 to N generate
        t_ff : entity work.dff(rtl)
            port map (clk => clk, reset => reset, d => t_d(i), q => t_q(i));
    end generate counter;
 
    product <= p_q & a_q;
    done    <= t_q(N);
end architecture structural;