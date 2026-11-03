library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CSA is
port(
x0, x1, x2, x3, x4, x5, x6, x7, x8, x9 : in std_logic_vector(7 downto 0);
S : out std_logic_vector(11 downto 0)
);
end CSA;

architecture Logic of CSA is
function CSA_Sum(a, b, c : unsigned(11 downto 0))
return unsigned is
begin
return a xor b xor c;
end CSA_Sum;

function CSA_Carry(a, b, c : unsigned(11 downto 0))
return unsigned is
begin
return shift_left((a and b) or (a and c) or (b and c), 1);
end CSA_Carry;

signal s1, c1, s2, c2, s3, c3 : unsigned(11 downto 0);
signal s4, c4, s5, c5 : unsigned(11 downto 0);
signal s6, c6, s7, c7, s8, c8 : unsigned(11 downto 0);

signal Total : unsigned(11 downto 0);

begin
-- Part 1: 10 inputs to 7 outputs
s1 <= CSA_Sum(resize(unsigned(x0),12), resize(unsigned(x1),12), resize(unsigned(x2),12));
c1 <= CSA_Carry(resize(unsigned(x0),12), resize(unsigned(x1),12), resize(unsigned(x2),12));

s2 <= CSA_Sum(resize(unsigned(x3),12), resize(unsigned(x4),12), resize(unsigned(x5),12));
c2 <= CSA_Carry(resize(unsigned(x3),12), resize(unsigned(x4),12), resize(unsigned(x5),12));

s3 <= CSA_Sum(resize(unsigned(x6),12), resize(unsigned(x7),12), resize(unsigned(x8),12));
c3 <= CSA_Carry(resize(unsigned(x6),12), resize(unsigned(x7),12), resize(unsigned(x8),12));

-- Part 2: 7 inputs to 5 outputs
s4 <= CSA_Sum(s1, c1, s2);
c4 <= CSA_Carry(s1, c1, s2);

s5 <= CSA_Sum(c2, s3, c3);
c5 <= CSA_Carry(c2, s3, c3);

-- Part 3: 5 inputs to 4 outputs
s6 <= CSA_Sum(s4, c4, s5);
c6 <= CSA_Carry(s4, c4, s5);

-- Part 4: 4 inputs to 3 outputs
s7 <= CSA_Sum(s6, c6, c5);
c7 <= CSA_Carry(s6, c6, c5);

-- Part 5: 3 inputs to 2 outputs
s8 <= CSA_Sum(s7, c7, resize(unsigned(x9),12));
c8 <= CSA_Carry(s7, c7, resize(unsigned(x9),12));

-- Part 6: Final adder
Total <= s8 + c8;

S <= std_logic_vector(Total);

end Logic;

