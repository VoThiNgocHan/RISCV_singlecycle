library verilog;
use verilog.vl_types.all;
entity comp32 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        EQ              : out    vl_logic;
        LT              : out    vl_logic
    );
end comp32;
