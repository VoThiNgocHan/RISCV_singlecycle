library verilog;
use verilog.vl_types.all;
entity mux32_1 is
    port(
        sel             : in     vl_logic_vector(4 downto 0);
        d               : in     vl_logic_vector(31 downto 0);
        y               : out    vl_logic
    );
end mux32_1;
