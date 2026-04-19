module singlecycle(
    input  logic        i_clk, i_reset,
    input  logic [31:0] i_io_sw,
    output logic        o_insn_vld,
    output logic [31:0] o_pc_debug, o_io_ledr, o_io_ledg, o_io_lcd,
    output logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3,
    o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7
  );

  // ==================== Signal Declarations ====================
  // Program Counter
  logic [31:0] pc, pc_next, pc_plus4;

  // Instruction Memory
  logic [31:0] instr;

  // Register File
  logic [31:0] rs1_data, rs2_data, wb_data;
  logic [4:0]  rs1_addr, rs2_addr, rd_addr;

  // ALU
  logic [31:0] alu_operand_a, alu_operand_b, alu_data;

  // Immediate Generator
  logic [31:0] imm_value;

  // Control Unit
  logic        pc_sel, rd_wren, insn_vld, br_un;
  logic        opa_sel, opb_sel ;
  logic [3:0]  alu_op, bmask;
  logic [1:0]  wb_sel;
  logic        wr_en, rd_en;
  logic        is_jalr;

  // Branch Comparator
  logic        br_less, br_equal;

  // Load-Store Unit
  logic [31:0] ld_data;
  logic [2:0]  lsu_control;

  //logic        is_load;
  // ==================== Module Instantiations ====================

  // PC Update Logic
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

  // JALR target calculation
  logic [31:0] alu_data_jalr ;
  assign alu_data_jalr = is_jalr ? {alu_data[31:1], 1'b0} : alu_data;

  // Branch target
  logic [31:0] branch_target;
  assign branch_target = pc + immgen_data;

  //PC target
  logic [31:0] pc_target;
  assign       pc_target = is_jalr ? alu_data_jalr : branch_target;

  mux_2in1 PC_select (
             .i_sel(pc_sel),
             .i_in0(pc_plus4),
             .i_in1(pc_target),
             .o_out(pc_next)
           );

  // Instruction Memory
  instr_mem imem (
              .i_pc_addr(pc),
              .o_instr(instr)
            );

  // Control Unit
  control_unit ctrl (
                 .i_inst(instr),
                 .i_br_less(br_less),
                 .i_br_equal(br_equal),
                 .o_pc_sel(pc_sel),
                 .o_rd_wren(rd_wren),
                 .o_mem_wren(wr_en),
                 .o_mem_rden(rd_en),
                 .o_insn_vld(insn_vld),
                 .o_br_un(br_un),
                 .o_opa_sel(opa_sel),
                 .o_opb_sel(opb_sel),
                 .o_alu_op(alu_op),
                 //.o_bmask(bmask),
                 .o_wb_sel(wb_sel),
                 .o_is_jalr(is_jalr)
               );

  assign is_load = (instr[6:2] == 5'b00000); // OP_LOAD

  // Register File
  assign rs1_addr = instr[19:15];
  assign rs2_addr = instr[24:20];
  assign rd_addr  = instr[11:7];

  regfile reg_file (
            .i_clk(i_clk),
            .i_reset(i_reset),
            .i_rs1_addr(rs1_addr),
            .i_rs2_addr(rs2_addr),
            .i_rd_addr(rd_addr),
            .i_rd_data(wb_data),
            .i_rd_wren(rd_wren),
            .o_rs1_data(rs1_data),
            .o_rs2_data(rs2_data)
          );

  // Branch Comparator
  brc branch_comp (
        .i_rs1_data(rs1_data),
        .i_rs2_data(rs2_data),
        .i_br_un(br_un),
        .o_br_less(br_less),
        .o_br_equal(br_equal)
      );

  // Immediate Generator
  ImmGen imm_gen (
           .instr(instr),
           .o_immgen(imm_value)
         );

  // ALU Operand MUXes
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

  // ALU
  alu alu (
        .i_op_a(alu_operand_a),
        .i_op_b(alu_operand_b),
        .i_alu_op(alu_op),
        .o_alu_data(alu_data)
      );

  // Load-Store Unit
  assign lsu_control = instr[14:12];

  lsu lsu_unit (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_lsu_addr(alu_data),
        .i_st_data(rs2_data),
        .i_lsu_wren(wr_en),
        .i_io_sw(i_io_sw),
        .i_control(lsu_control),
        //    .i_io_sw(is_load),
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

  // Writeback MUX
  mux_3in1 WB_sel (
             .i_sel(wb_sel),
             .i_in0(pc_plus4),
             .i_in1(alu_data),
             .i_in2(ld_data),
             .o_out(wb_data)
           );

  // Output assignments
  always_ff @(posedge i_clk)
  begin
    if (~i_reset)
      o_pc_debug <= 32'h0;
    else
      o_pc_debug <= pc;
  end

  assign o_insn_vld = insn_vld;
endmodule
