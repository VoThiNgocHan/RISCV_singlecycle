library verilog;
use verilog.vl_types.all;
entity control_unit is
    port(
        i_inst          : in     vl_logic_vector(31 downto 0);
        i_br_less       : in     vl_logic;
        i_br_equal      : in     vl_logic;
        o_pc_sel        : out    vl_logic;
        o_rd_wren       : out    vl_logic;
        o_insn_vld      : out    vl_logic;
        o_br_un         : out    vl_logic;
        o_opa_sel       : out    vl_logic;
        o_opb_sel       : out    vl_logic;
        o_alu_op        : out    vl_logic_vector(3 downto 0);
        o_mem_wren      : out    vl_logic;
        o_wb_sel        : out    vl_logic_vector(1 downto 0);
        o_ImmSrc        : out    vl_logic_vector(2 downto 0);
        o_is_jalr       : out    vl_logic
    );
end control_unit;
