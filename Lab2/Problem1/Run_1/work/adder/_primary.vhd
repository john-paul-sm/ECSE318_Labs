library verilog;
use verilog.vl_types.all;
entity adder is
    generic(
        WIDTH           : integer := 16
    );
    port(
        A               : in     vl_logic_vector;
        B               : in     vl_logic_vector;
        CODE            : in     vl_logic_vector(2 downto 0);
        cin             : in     vl_logic;
        coe             : in     vl_logic;
        C               : out    vl_logic_vector;
        vout            : out    vl_logic;
        cout            : out    vl_logic
    );
end adder;
