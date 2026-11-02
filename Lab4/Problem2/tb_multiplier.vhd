library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity tb_shift_add_multiplier is
end entity tb_shift_add_multiplier;
 
architecture sim of tb_shift_add_multiplier is
    constant N     : positive := 4;
    constant T_CLK : time     := 10 ns;
 
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '1';
    signal load         : std_logic := '0';
    signal multiplicand : std_logic_vector(N-1 downto 0) := (others => '0');
    signal multiplier   : std_logic_vector(N-1 downto 0) := (others => '0');
    signal product      : std_logic_vector(2*N-1 downto 0);
    signal done         : std_logic;
    signal finished     : boolean := false;
begin
    clk <= not clk after T_CLK/2 when not finished else clk;
 
    dut : entity work.shift_add_multiplier(structural)
        generic map (N => N)
        port map (clk => clk, reset => reset, load => load,
                  multiplicand => multiplicand, multiplier => multiplier,
                  product => product, done => done);
 
    stim : process
        variable errors : natural := 0;
 
        procedure run (x, y : natural; verbose : boolean) is
            variable got : natural;
        begin
            multiplicand <= std_logic_vector(to_unsigned(x, N));
            multiplier   <= std_logic_vector(to_unsigned(y, N));
            load         <= '1';
            wait until rising_edge(clk);
            load         <= '0';
            wait until done = '1';
            wait for 1 ns;
            got := to_integer(unsigned(product));
            if verbose then
                report integer'image(x) & " * " & integer'image(y) &
                       " = " & integer'image(got);
            end if;
            if got /= x * y then
                errors := errors + 1;
                report "FAIL: " & integer'image(x) & " * " &
                       integer'image(y) & " expected " &
                       integer'image(x * y) & ", got " &
                       integer'image(got) severity error;
            end if;
            wait until rising_edge(clk);
        end procedure run;
    begin
        wait for 2 * T_CLK;
        wait until rising_edge(clk);
        reset <= '0';
        wait until rising_edge(clk);
 
        run(2, 4, true);
        run(15, 3, true);
 
        report "Test complete: " & integer'image(errors) & " errors";
        finished <= true;
        wait;
    end process stim;
end architecture sim;