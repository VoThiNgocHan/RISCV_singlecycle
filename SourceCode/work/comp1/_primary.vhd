library verilog;
use verilog.vl_types.all;
entity comp1 is
    port(
        A               : in     vl_logic;
        B               : in     vl_logic;
        E               : out    vl_logic;
        L               : out    vl_logic
    );
end comp1;
