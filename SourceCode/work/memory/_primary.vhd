library verilog;
use verilog.vl_types.all;
entity memory is
    port(
        i_clk           : in     vl_logic;
        i_reset         : in     vl_logic;
        i_wren          : in     vl_logic;
        i_addr          : in     vl_logic_vector(8 downto 0);
        i_wdata         : in     vl_logic_vector(31 downto 0);
        i_bmask         : in     vl_logic_vector(3 downto 0);
        o_rdata         : out    vl_logic_vector(31 downto 0)
    );
end memory;
