library verilog;
use verilog.vl_types.all;
entity register32 is
    port(
        i_clk           : in     vl_logic;
        i_reset         : in     vl_logic;
        i_we            : in     vl_logic;
        i_d             : in     vl_logic_vector(31 downto 0);
        o_q             : out    vl_logic_vector(31 downto 0)
    );
end register32;
