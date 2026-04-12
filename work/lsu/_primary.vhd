library verilog;
use verilog.vl_types.all;
entity lsu is
    port(
        i_clk           : in     vl_logic;
        i_reset         : in     vl_logic;
        i_lsu_addr      : in     vl_logic_vector(31 downto 0);
        i_st_data       : in     vl_logic_vector(31 downto 0);
        i_lsu_wren      : in     vl_logic;
        i_io_sw         : in     vl_logic_vector(31 downto 0);
        o_ld_data       : out    vl_logic_vector(31 downto 0);
        o_io_ledr       : out    vl_logic_vector(31 downto 0);
        o_io_ledg       : out    vl_logic_vector(31 downto 0);
        o_io_hex07      : out    vl_logic_vector(6 downto 0);
        o_io_lcd        : out    vl_logic_vector(31 downto 0)
    );
end lsu;
