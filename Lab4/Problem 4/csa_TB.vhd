library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CSA_TB is
end CSA_TB;

architecture Logic of CSA_TB is
signal x0, x1, x2, x3, x4, x5, x6, x7, x8, x9 : std_logic_vector(7 downto 0);
signal S : std_logic_vector(11 downto 0);

begin
Tester: entity work.CSA
port map(
x0 => x0, x1 => x1, x2 => x2, x3 => x3, x4 => x4, x5 => x5, x6 => x6, x7 => x7, x8 => x8, x9 => x9,
S => S
);

process
begin
-- Test 1: Add numbers 1 to 10
x0 <= "00000001";
x1 <= "00000010";
x2 <= "00000011";
x3 <= "00000100";
x4 <= "00000101";
x5 <= "00000110";
x6 <= "00000111";
x7 <= "00001000";
x8 <= "00001001";
x9 <= "00001010";
wait for 10 ns;

-- Test 2: Add numbers 3 to 10
x0 <= "00000011";
x1 <= "00000100";
x2 <= "00000101";
x3 <= "00000110";
x4 <= "00000111";
x5 <= "00001000";
x6 <= "00001001";
x7 <= "00001010";
x8 <= "00000000";
x9 <= "00000000";
wait for 10 ns;

wait;
end process;
end Logic;

