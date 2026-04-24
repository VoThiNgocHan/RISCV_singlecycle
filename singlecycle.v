module singlecycle(
    input        i_clk, i_reset,
    input  [31:0] i_io_sw,
    output       o_insn_vld,
    output [31:0] o_pc_debug, o_io_ledr, o_io_ledg, o_io_lcd,
    output [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3,
                  o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
    output wire [31:0] instr,
    output wire [3:0]  alu_op
);

  // ==================== Signals ====================

  wire [31:0] pc, pc_next, pc_plus4;
  //wire [31:0] instr;

  wire [31:0] rs1_data, rs2_data, wb_data;
  wire [4:0]  rs1_addr, rs2_addr, rd_addr;

  wire [31:0] alu_operand_a, alu_operand_b, alu_data;

  wire        pc_sel, rd_wren, insn_vld, br_un;
  wire        opa_sel, opb_sel;
  //wire [3:0]  alu_op;
  wire [1:0]  wb_sel;
  wire        wr_en; //rd_en;
  wire        is_jalr;

  wire        br_less, br_equal;

  wire [31:0] ld_data;
  wire [2:0]  lsu_control;

  wire is_load;

  wire [31:0] imm_value;   
  wire [2:0]  ImmSrc;    

  // ==================== PC ====================

  pc_hold pc_hold_unit (
      .i_clk(i_clk),
      .i_rst_n(i_reset),
      .i_pc_next(pc_next),
      .o_pc(pc)
  );

  pc_4 pc_plus4_unit (
      .i_pc(pc),
      .o_pc_four(pc_plus4)
  );

  // ==================== PC Target ====================

  wire [31:0] alu_data_jalr;
  assign alu_data_jalr = is_jalr ? {alu_data[31:1], 1'b0} : alu_data;

  wire [31:0] branch_target;
  assign branch_target = pc + imm_value;

  wire [31:0] pc_target;
  assign pc_target = is_jalr ? alu_data_jalr : branch_target;

  mux_2in1 PC_select (
      .i_sel(pc_sel),
      .i_in0(pc_plus4),
      .i_in1(pc_target),
      .o_out(pc_next)
  );

  // ==================== Instruction Memory ====================

  instr_mem imem (
      .i_pc_addr(pc),
      .o_instr(instr)
  );

  // ==================== Control ====================

  control_unit ctrl (
      .i_inst(instr),
      .i_br_less(br_less),
      .i_br_equal(br_equal),
      .o_pc_sel(pc_sel),
      .o_rd_wren(rd_wren),
      .o_mem_wren(wr_en),
      //.o_mem_rden(rd_en),
      .o_insn_vld(insn_vld),
      .o_br_un(br_un),
      .o_opa_sel(opa_sel),
      .o_opb_sel(opb_sel),
      .o_alu_op(alu_op),
      .o_wb_sel(wb_sel),
      .o_is_jalr(is_jalr),
      .o_ImmSrc(ImmSrc)
  );

  assign is_load = (instr[6:2] == 5'b00000);

  // ==================== Register File ====================

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

  // ==================== Branch ====================

  brc branch_comp (
      .i_rs1_data(rs1_data),
      .i_rs2_data(rs2_data),
      .i_br_un(br_un),
      .o_br_less(br_less),
      .o_br_equal(br_equal)
  );

  // ==================== Immediate ====================    

    Extend imm_gen (
        .instruction(instr[31:7]),
        .ImmSrc(ImmSrc),
        .ImmExt(imm_value)
    );

  // ==================== ALU ====================

  mux_2in1 OPA_sel (
      .i_sel(opa_sel),
      .i_in0(rs1_data),
      .i_in1(pc),
      .o_out(alu_operand_a)
  );

  mux_2in1 OPB_sel (
      .i_sel(opb_sel),
      .i_in0(rs2_data),
      .i_in1(imm_value),
      .o_out(alu_operand_b)
  );

  alu alu (
      .i_op_a(alu_operand_a),
      .i_op_b(alu_operand_b),
      .i_alu_op(alu_op),
      .o_alu_data(alu_data)
  );

  // ==================== LSU ====================

  assign lsu_control = instr[14:12];

  lsu lsu_unit (
      .i_clk(i_clk),
      .i_reset(i_reset),
      .i_lsu_addr(alu_data),
      .i_st_data(rs2_data),
      .i_lsu_wren(wr_en),
      .i_io_sw(i_io_sw),
      .i_control(lsu_control),
      .o_ld_data(ld_data),
      .o_io_ledr(o_io_ledr),
      .o_io_ledg(o_io_ledg),
      .o_io_hex0(o_io_hex0),
      .o_io_hex1(o_io_hex1),
      .o_io_hex2(o_io_hex2),
      .o_io_hex3(o_io_hex3),
      .o_io_hex4(o_io_hex4),
      .o_io_hex5(o_io_hex5),
      .o_io_hex6(o_io_hex6),
      .o_io_hex7(o_io_hex7),
      .o_io_lcd(o_io_lcd)
  );

  // ==================== WRITEBACK ====================

  wire [31:0] wb_mid;

  mux_2in1 WB_mux1 (
      .i_sel(wb_sel[0]),
      .i_in0(alu_data),
      .i_in1(ld_data),
      .o_out(wb_mid)
  );

  mux_2in1 WB_mux2 (
      .i_sel(wb_sel[1]),
      .i_in0(wb_mid),
      .i_in1(pc_plus4),
      .o_out(wb_data)
  );

  // ==================== OUTPUT ====================

  reg [31:0] pc_debug_reg;

  always @(posedge i_clk) begin
      if (~i_reset)
          pc_debug_reg <= 32'h0;
      else
          pc_debug_reg <= pc;
  end

  assign o_pc_debug = pc_debug_reg;
  assign o_insn_vld = insn_vld;

endmodule