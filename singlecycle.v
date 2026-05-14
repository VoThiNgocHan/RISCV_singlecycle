module singlecycle(

    input         i_clk,
    input         i_reset,

    // LSU LOAD DATA
    input  [31:0] i_ld_data,

    // LSU INTERFACE
    output [31:0] o_lsu_addr,
    output [31:0] o_st_data,
    output        o_lsu_wren,
    output        o_lsu_rden,
    output [2:0]  o_lsu_control,

    // DEBUG
    output        o_insn_vld,
    output [31:0] o_pc_debug,
    output [31:0] instr,
    output [3:0]  alu_op
);

////////////////////////////////////////////////////////////
// SIGNALS
////////////////////////////////////////////////////////////

wire [31:0] pc, pc_next, pc_plus4;

wire [31:0] rs1_data, rs2_data, wb_data;
wire [4:0]  rs1_addr, rs2_addr, rd_addr;

wire [31:0] alu_operand_a, alu_operand_b, alu_data;

wire        pc_sel, rd_wren, insn_vld, br_un;
wire        opa_sel, opb_sel;

wire [1:0]  wb_sel;

wire        wr_en;
wire        is_jalr;

wire        br_less, br_equal;

wire        is_load;

wire [31:0] imm_value;
wire [2:0]  ImmSrc;

////////////////////////////////////////////////////////////
// PC
////////////////////////////////////////////////////////////

pc_hold pc_hold_unit (
    .i_clk(i_clk),
    .i_rst(i_reset),
    .i_pc_next(pc_next),
    .o_pc(pc)
);

pc_4 pc_plus4_unit (
    .i_pc(pc),
    .o_pc_four(pc_plus4)
);

////////////////////////////////////////////////////////////
// PC TARGET
////////////////////////////////////////////////////////////

wire [31:0] alu_data_jalr;

assign alu_data_jalr =
    is_jalr ? {alu_data[31:1],1'b0} : alu_data;

// wire [31:0] branch_target;
// assign branch_target = pc + imm_value;

// wire [31:0] pc_target;

// assign pc_target =
//     is_jalr ? alu_data_jalr : branch_target;

wire [31:0] branch_target;
wire [31:0] jal_target;

assign branch_target = pc + imm_value;

assign jal_target = pc + imm_value;

wire [31:0] pc_target;

assign pc_target =
    is_jalr ? alu_data_jalr :
    ((instr[6:0] == 7'b1101111) ? jal_target :
                                      branch_target);

mux_2in1 PC_select (

    .i_sel(pc_sel),

    .i_in0(pc_plus4),
    .i_in1(pc_target),

    .o_out(pc_next)
);

////////////////////////////////////////////////////////////
// INSTRUCTION MEMORY
////////////////////////////////////////////////////////////

instr_mem imem (

    .i_pc_addr(pc),
    .o_instr(instr)
);

////////////////////////////////////////////////////////////
// CONTROL UNIT
////////////////////////////////////////////////////////////

control_unit ctrl (

    .i_inst(instr),

    .i_br_less(br_less),
    .i_br_equal(br_equal),

    .o_pc_sel(pc_sel),

    .o_rd_wren(rd_wren),

    .o_mem_wren(wr_en),

    .o_insn_vld(insn_vld),

    .o_br_un(br_un),

    .o_opa_sel(opa_sel),
    .o_opb_sel(opb_sel),

    .o_alu_op(alu_op),

    .o_wb_sel(wb_sel),

    .o_is_jalr(is_jalr),

    .o_ImmSrc(ImmSrc)
);

////////////////////////////////////////////////////////////
// LOAD DETECT
////////////////////////////////////////////////////////////

assign is_load =
    (instr[6:2] == 5'b00000);

////////////////////////////////////////////////////////////
// REGISTER FILE
////////////////////////////////////////////////////////////

assign rs1_addr = instr[19:15];
assign rs2_addr = instr[24:20];
assign rd_addr  = instr[11:7];

regfile reg_file (

    .i_clk(i_clk),
    .i_rst(i_reset),

    .i_rs1_addr(rs1_addr),
    .i_rs2_addr(rs2_addr),

    .i_rd_addr(rd_addr),
    .i_rd_data(wb_data),

    .i_rd_wren(rd_wren),

    .o_rs1_data(rs1_data),
    .o_rs2_data(rs2_data)
);

////////////////////////////////////////////////////////////
// BRANCH COMPARE
////////////////////////////////////////////////////////////

brc branch_comp (

    .i_rs1_data(rs1_data),
    .i_rs2_data(rs2_data),

    .i_br_un(br_un),

    .o_br_less(br_less),
    .o_br_equal(br_equal)
);

////////////////////////////////////////////////////////////
// IMMEDIATE GENERATOR
////////////////////////////////////////////////////////////

Extend imm_gen (

    .instruction(instr),
    .ImmSrc(ImmSrc),

    .ImmExt(imm_value)
);

////////////////////////////////////////////////////////////
// ALU INPUT SELECT
////////////////////////////////////////////////////////////

// mux_2in1 OPA_sel (

//     .i_sel(opa_sel),

//     .i_in0(rs1_data),
//     .i_in1(pc),

//     .o_out(alu_operand_a)
// );

assign alu_operand_a = (instr[6:0] == 7'b0110111) ? 32'b0 : (opa_sel ? pc : rs1_data);

mux_2in1 OPB_sel (

    .i_sel(opb_sel),

    .i_in0(rs2_data),
    .i_in1(imm_value),

    .o_out(alu_operand_b)
);

////////////////////////////////////////////////////////////
// ALU
////////////////////////////////////////////////////////////

alu alu (

    .i_op_a(alu_operand_a),
    .i_op_b(alu_operand_b),

    .i_alu_op(alu_op),

    .o_alu_data(alu_data)
);

////////////////////////////////////////////////////////////
// LSU INTERFACE
////////////////////////////////////////////////////////////

assign o_lsu_addr    = alu_data;

assign o_st_data     = rs2_data;

assign o_lsu_wren    = wr_en;

assign o_lsu_rden    = is_load;

assign o_lsu_control = instr[14:12];

////////////////////////////////////////////////////////////
// WRITEBACK
////////////////////////////////////////////////////////////

wire [31:0] wb_mid;

mux_2in1 WB_mux1 (

    .i_sel(wb_sel[0]),

    .i_in0(alu_data),
    .i_in1(i_ld_data),

    .o_out(wb_mid)
);

mux_2in1 WB_mux2 (

    .i_sel(wb_sel[1]),

    .i_in0(wb_mid),
    .i_in1(pc_plus4),

    .o_out(wb_data)
);

////////////////////////////////////////////////////////////
// DEBUG
////////////////////////////////////////////////////////////

reg [31:0] pc_debug_reg;

always @(posedge i_clk) begin

    if(i_reset)
        pc_debug_reg <= 32'h0;
    else
        pc_debug_reg <= pc;
end

assign o_pc_debug = pc_debug_reg;

assign o_insn_vld = insn_vld;

endmodule