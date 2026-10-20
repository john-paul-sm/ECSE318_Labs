library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Divider is
port(
clk, reset, start : in std_logic;
dividend, divisor : in std_logic_vector(3 downto 0);
quotient : out std_logic_vector(3 downto 0);
remainder : out std_logic_vector(3 downto 0);
busy, done : out std_logic
);
end Divider;

architecture Logic of Divider is
type state_type is (Idle, Divide, True, Finish);
signal state : state_type := Idle;
signal M : signed(4 downto 0) := (others => '0');
signal R : signed(4 downto 0) := (others => '0');
signal D : std_logic_vector(3 downto 0) := (others => '0');
signal CNT : integer range 0 to 4 := 0;

begin
quotient <= D;
remainder <= std_logic_vector(R(3 downto 0));
busy <= '1' when state = Divide or state = True else '0';
done <= '1' when state = Finish else '0';

process(clk, reset)
variable R_shift : signed(4 downto 0);
variable D_shift : std_logic_vector(3 downto 0);
variable R_next : signed(4 downto 0);

begin
if reset = '1' then
state <= Idle;
M <= (others => '0');
R <= (others => '0');
D <= (others => '0');
CNT <= 0;

elsif rising_edge(clk) then
case state is
when Idle =>
if start = '1' then
M <= signed('0' & divisor);
R <= (others => '0');
D <= dividend;
CNT <= 4;
state <= Divide;

end if;
when Divide =>
R_shift := signed(R(3 downto 0) & D(3));
D_shift := D(2 downto 0) & '0';
if R(4) = '0' then
R_next := R_shift - M;
else
R_next := R_shift + M;

end if;
if R_next(4) = '0' then
D_shift(0) := '1';
else
D_shift(0) := '0';

end if;
R <= R_next;
D <= D_shift;
CNT <= CNT - 1;
if CNT = 1 then
state <= True;

end if;
when True =>
if R(4) = '1' then
R <= R + M;

end if;
state <= Finish;
when Finish =>
state <= Idle;

end case;
end if;
end process;
end Logic;
