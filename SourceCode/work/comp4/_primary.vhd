library verilog;
use verilog.vl_types.all;
entity comp4 is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        EQ              : out    vl_logic;
        LT              : out    vl_logic
    );
end comp4;
