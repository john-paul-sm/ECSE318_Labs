library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ConditionalSumAdder is
Port (A:in STD_LOGIC_VECTOR(7 downto 0);
B: in STD_LOGIC_VECTOR(7 downto 0);
S: out STD_LOGIC_VECTOR(8 downto 0));
end ConditionalSumAdder;

architecture Logic of ConditionalSumAdder is
signal sum1, sum2 : STD_LOGIC_VECTOR(7 downto 0);
signal carry1, carry2 : STD_LOGIC_VECTOR(7 downto 0);
signal c : STD_LOGIC_VECTOR(8 downto 0);

begin
c(0) <= '0';
Gen: for i in 0 to 7 generate
sum1(i) <= A(i) xor B(i);
carry1(i) <= A(i) and B(i);
sum2(i) <= not (A(i) xor B(i));
carry2(i) <= A(i) or B(i);
S(i) <= sum2(i) when c(i) = '1' else sum1(i);
c(i+1) <= carry2(i) when c(i) = '1' else carry1(i);
end generate Gen;

S(8) <= c(8);
end Logic;
