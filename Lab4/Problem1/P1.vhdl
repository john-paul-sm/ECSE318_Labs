-- and2: 2-input AND gate
entity and2 is
port (a, b : in bit; y : out bit);
end entity and2;

architecture basic of and2 is
begin
and2beh: process is
begin
y <= a and b after 2 ns;
wait on a, b;
end process and2beh;
end architecture basic;

-- fa: full adder
entity fa is
port (a, b, cin : in bit; sout, cout : out bit);
end entity fa;

architecture basic of fa is
begin
fabeh: process is
begin
sout <= a xor b xor cin after 2 ns;
cout <= (a and b) or (a and cin) or (b and cin) after 2 ns;
wait on a, b, cin;
end process fabeh;
end architecture basic;

-- csa_cell: one square box
entity csa_cell is
port (a, b, sin, cin : in bit; sout, cout : out bit);
end entity csa_cell;

use work.all;
architecture struct of csa_cell is
component and2 port (a, b : in bit; y : out bit); end component;
component fa port (a, b, cin : in bit; sout, cout : out bit); end component;
signal pp : bit;
begin
gate : and2 port map (a, b, pp);
adder : fa port map (pp, sin, cin, sout, cout);
end architecture struct;

-- mult4x4: top level
entity mult4x4 is
port (x, y : in bit_vector(3 downto 0);
      p : out bit_vector(7 downto 0));
end entity mult4x4;

use work.all;
architecture gen of mult4x4 is
component csa_cell port (a, b, sin, cin : in bit; sout, cout : out bit); end component;
component fa port (a, b, cin : in bit; sout, cout : out bit); end component;

type rowarray is array (0 to 3) of bit_vector(3 downto 0);
signal s, c : rowarray;
signal car : bit_vector(4 downto 0);
signal gnd : bit := '0';
begin

-- CSA array: 4 rows/columns
ROWS: for i in 0 to 3 generate
  COLS: for j in 0 to 3 generate
    -- row x0: Sin = 0, Cin = 0
    TOPROW: if i = 0 generate
      cell: csa_cell port map (x(i), y(j), gnd, gnd, s(i)(j), c(i)(j));
    end generate TOPROW;
    -- leftmost cell: Sin = 0
    LEFTCELL: if i > 0 and j = 3 generate
      cell: csa_cell port map (x(i), y(j), gnd, c(i - 1)(j), s(i)(j), c(i)(j));
    end generate LEFTCELL;

    INNER: if i > 0 and j < 3 generate
      cell: csa_cell port map (x(i), y(j), s(i - 1)(j + 1), c(i - 1)(j), s(i)(j), c(i)(j));
    end generate INNER;

  end generate COLS;

  p(i) <= s(i)(0);
end generate ROWS;

-- CPA: 4-bit ripple-carry adder
car(0) <= '0';
CPA: for k in 0 to 3 generate
  LOWER: if k < 3 generate
    add: fa port map (s(3)(k + 1), c(3)(k), car(k), p(k + 4), car(k + 1));
  end generate LOWER;
  TOPBIT: if k = 3 generate
    add: fa port map (gnd, c(3)(k), car(k), p(k + 4), car(k + 1));
  end generate TOPBIT;
end generate CPA;

end architecture gen;