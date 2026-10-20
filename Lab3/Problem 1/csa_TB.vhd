library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ConditionalSumAdder_TB is
end ConditionalSumAdder_TB;

architecture test of ConditionalSumAdder_TB is
signal A, B : STD_LOGIC_VECTOR(7 downto 0);
signal S : STD_LOGIC_VECTOR(8 downto 0);

begin
dut: entity work.ConditionalSumAdder
port map (A => A, B => B, S => S);
process

begin
A <= "00000001";
B <= "00000001";
wait for 20 ns;
A <= "00000101";
B <= "00001010";
wait for 20 ns;
A <= "01100100";
B <= "01100100";
wait for 20 ns;
A <= "11111111";
B <= "11111111";
wait for 20 ns;
wait;

end process;
end test;

