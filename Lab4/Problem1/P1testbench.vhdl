entity testbench is
end entity testbench;

architecture testmult of testbench is
signal x, y : bit_vector(3 downto 0);
signal p : bit_vector(7 downto 0);
begin

dut : entity work.mult4x4(gen)
port map (x, y, p);

stimulus : process is
begin
-- Case 1: 2 * 4 = 8
x <= B"0010"; y <= B"0100"; wait for 50 ns;
assert p = B"0000_1000" report "2*4 FAILED: expected 8" severity error;
report "2 * 4 done (expect p = 00001000 = 8)";

-- Case 2: 15 * 3 = 45
x <= B"1111"; y <= B"0011"; wait for 50 ns;
assert p = B"0010_1101" report "15*3 FAILED: expected 45" severity error;
report "15 * 3 done (expect p = 00101101 = 45)";

-- Case 3: 15 * 15 = 225
x <= B"1111"; y <= B"1111"; wait for 50 ns;
assert p = B"1110_0001" report "15*15 FAILED: expected 225" severity error;
report "15 * 15 done (expect p = 11100001 = 225)";

wait;
end process stimulus;

end architecture testmult;