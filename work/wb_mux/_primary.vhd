library verilog;
use verilog.vl_types.all;
entity wb_mux is
    port(
        pc_four         : in     vl_logic_vector(31 downto 0);
        alu_data        : in     vl_logic_vector(31 downto 0);
        ld_data         : in     vl_logic_vector(31 downto 0);
        wb_sel          : in     vl_logic_vector(1 downto 0);
        wb_data         : out    vl_logic_vector(31 downto 0)
    );
end wb_mux;
