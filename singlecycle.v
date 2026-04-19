module singlecycle(
    input          i_clk, i_reset,
    input  [31:0]  i_io_sw,
    output         o_insn_vld,
    output reg [31:0] o_pc_debug,
    output [31:0] o_io_ledr, o_io_ledg, o_io_lcd,
    output [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3,
              o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7
);

  // ==================== Signals ====================

  // PC
  wire [31:0] pc, pc_next, pc_plus4;

  // Instruction
  wire [31:0] instr;

  // Register File
  wire [31:0] rs1_data, rs2_data, wb_data;
  wire [4:0]  rs1_addr, rs2_addr, rd_addr;

  // ALU
  wire [31:0] alu_operand_a, alu_operand_b, alu_data;

  // Immediate
  wire [31:0] imm_value;

  // Control
  wire        pc_sel, rd_wren, insn_vld, br_un;
  wire        opa_sel, opb_sel;
  wire [3:0]  alu_op;
  wire [1:0]  wb_sel;
  wire        wr_en;
  wire        is_jalr;

  // Branch
  wire br_less, br_equal;

  // LSU
  wire [31:0] ld_data;
  wire [2:0]  lsu_control;

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

  wire [31:0] branch_target = pc + imm_value;
  wire [31:0] pc_target     = is_jalr ? alu_data_jalr : branch_target;

  pc_mux PC_select (
      .alu_data(pc_target),
      .pc_four(pc_plus4),
      .pc_sel(pc_sel),
      .pc_next(pc_next)
  );

  // ==================== Instruction Memory ====================
/*  instr_mem mem (
      .i_clk(i_clk),
      .i_rst(i_reset),
      .i_wren(1'b0),
      .i_bmask(4'b0000),
      .i_addr(pc),
      .i_wdata(32'b0),
      .o_rdata(instr)
  );
  */
    instr_mem imem (
              .i_pc_addr(pc),
              .o_instr(instr)
            );

  // ==================== Control ====================

  control_unit ctrl (
      .instr(instr),
      .br_less(br_less),
      .br_equal(br_equal),
      .pc_sel(pc_sel),
      .rd_wren(rd_wren),
      .insn_vld(insn_vld),
      .br_un(br_un),
      .opa_sel(opa_sel),
      .opb_sel(opb_sel),
      .alu_op(alu_op),
      .mem_wren(wr_en),
      .wb_sel(wb_sel)
  );

  assign is_jalr = 1'b0; 

  // ==================== Register File ====================

  assign rs1_addr = instr[19:15];
  assign rs2_addr = instr[24:20];
  assign rd_addr  = instr[11:7];

  regfile reg_file (
      .i_clk(i_clk),
      .i_rst(i_reset),
      .i_rd_wren(rd_wren),
      .i_rs1_addr(rs1_addr),
      .i_rs2_addr(rs2_addr),
      .i_rd_addr(rd_addr),
      .i_rd_data(wb_data),
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

  ImmGen imm_gen (
      .instr(instr),
      .o_immgen(imm_value)
  );

  // ==================== ALU ====================

  opa_mux OPA_sel (
      .pc(pc),
      .rs1_data(rs1_data),
      .opa_sel(opa_sel),
      .operand_a(alu_operand_a)
  );

  opb_mux OPB_sel (
      .rs2_data(rs2_data),
      .imm(imm_value),
      .opb_sel(opb_sel),
      .operand_b(alu_operand_b)
  );

  alu alu (
      .i_op_a(alu_operand_a),
      .i_op_b(alu_operand_b),
      .i_alu_op(alu_op),
      .o_alu_data(alu_data)
  );

  // ==================== LSU ====================

    wire [31:0] ledr_wire, ledg_wire, lcd_wire;
    wire [6:0] hex0_wire, hex1_wire, hex2_wire, hex3_wire;
    wire [6:0] hex4_wire, hex5_wire, hex6_wire, hex7_wire;

    lsu lsu_unit (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_lsu_addr(alu_data),
        .i_st_data(rs2_data),
        .i_lsu_wren(wr_en),
        .i_io_sw(i_io_sw),
        .i_control(lsu_control),

        .o_ld_data(ld_data),

        .o_io_ledr(ledr_wire),
        .o_io_ledg(ledg_wire),

        .o_io_hex0(hex0_wire),
        .o_io_hex1(hex1_wire),
        .o_io_hex2(hex2_wire),
        .o_io_hex3(hex3_wire),
        .o_io_hex4(hex4_wire),
        .o_io_hex5(hex5_wire),
        .o_io_hex6(hex6_wire),
        .o_io_hex7(hex7_wire),

        .o_io_lcd(lcd_wire)
    );

    assign o_io_ledr = ledr_wire;
    assign o_io_ledg = ledg_wire;
    assign o_io_lcd  = lcd_wire;

    assign o_io_hex0 = hex0_wire;
    assign o_io_hex1 = hex1_wire;
    assign o_io_hex2 = hex2_wire;
    assign o_io_hex3 = hex3_wire;
    assign o_io_hex4 = hex4_wire;
    assign o_io_hex5 = hex5_wire;
    assign o_io_hex6 = hex6_wire;
    assign o_io_hex7 = hex7_wire;

  // ==================== Writeback ====================

  wb_mux WB_sel (
      .pc_four(pc_plus4),
      .alu_data(alu_data),
      .ld_data(ld_data),
      .wb_sel(wb_sel),
      .wb_data(wb_data)
  );

  // ==================== Output ====================

  always @(posedge i_clk) begin
      if (~i_reset)
          o_pc_debug <= 32'h0;
      else
          o_pc_debug <= pc;
  end

  assign o_insn_vld = insn_vld;

endmodule
