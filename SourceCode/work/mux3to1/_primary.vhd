library verilog;
use verilog.vl_types.all;
entity mux3to1 is
    port(
        i_a             : in     vl_logic_vector(31 downto 0);
        i_b             : in     vl_logic_vector(31 downto 0);
        i_c             : in     vl_logic_vector(31 downto 0);
        i_sel           : in     vl_logic_vector(1 downto 0);
        o_y             : out    vl_logic_vector(31 downto 0)
    );
end mux3to1;
