library verilog;
use verilog.vl_types.all;
entity pc_mux is
    port(
        alu_data        : in     vl_logic_vector(31 downto 0);
        pc_four         : in     vl_logic_vector(31 downto 0);
        pc_sel          : in     vl_logic;
        pc_next         : out    vl_logic_vector(31 downto 0)
    );
end pc_mux;
