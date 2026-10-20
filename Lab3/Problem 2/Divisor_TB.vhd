library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.all;

entity Divider_TB is
end Divider_TB;

architecture Test of Divider_TB is
signal clk : std_logic := '0';
signal reset, start : std_logic := '0';
signal dividend, divisor : std_logic_vector(3 downto 0);
signal quotient, remainder : std_logic_vector(3 downto 0);
signal busy, done : std_logic;

begin
clk <= not clk after 5 ns;

dut: entity work.Divider
port map(
clk => clk,
reset => reset,
start => start,
dividend => dividend,
divisor => divisor,
quotient => quotient,
remainder => remainder,
busy => busy,
done => done
);

process
begin
reset <= '1';
wait for 1 ns;
wait until falling_edge(clk);
reset <= '0';

-- Test 1: 7 / 2
dividend <= "0111";
divisor <= "0010";
start <= '1';
wait until rising_edge(clk);
start <= '0';
wait until done = '1';
wait for 10 ns;
wait until rising_edge(clk);
wait until falling_edge(clk);

-- Test 2: 6 / 2
dividend <= "0110";
divisor <= "0010";
start <= '1';
wait until rising_edge(clk);
start <= '0';
wait until done = '1';
wait for 10 ns;
wait until rising_edge(clk);
wait until falling_edge(clk);

-- Test 3: 9 / 4
dividend <= "1001";
divisor <= "0100";
start <= '1';
wait until rising_edge(clk);
start <= '0';
wait until done = '1';
wait for 20 ns;
stop;

wait;
end process;
end Test;