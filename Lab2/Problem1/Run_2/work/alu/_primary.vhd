library verilog;
use verilog.vl_types.all;
entity alu is
    generic(
        WIDTH           : integer := 16
    );
    port(
        A               : in     vl_logic_vector;
        B               : in     vl_logic_vector;
        alu_code        : in     vl_logic_vector(4 downto 0);
        C               : out    vl_logic_vector;
        overflow        : out    vl_logic
    );
end alu;
