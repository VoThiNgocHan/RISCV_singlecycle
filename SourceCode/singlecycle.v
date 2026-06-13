module singlecycle (
    input         i_clk,
    input         i_reset,
    input  [31:0] i_io_sw,
    output [31:0] o_io_ledr,
    output [31:0] o_io_ledg,
    output [31:0] o_io_lcd,
    output [6:0]  o_io_hex0,
    output [6:0]  o_io_hex1,
    output [6:0]  o_io_hex2,
    output [6:0]  o_io_hex3,
    output [6:0]  o_io_hex4,
    output [6:0]  o_io_hex5,
    output [6:0]  o_io_hex6,
    output [6:0]  o_io_hex7,
    output [31:0] o_pc_debug,
    output        o_insn_vld
);

    wire [31:0] pc_next, pc, pc_four;

    wire [31:0] instr;
    wire [31:0] rs1_data, rs2_data;

    wire [31:0] imm;
    wire [31:0] operand_a, operand_b;

    wire [31:0] alu_data;
    wire [31:0] ld_data;

    wire [31:0] wb_data;

    wire        rd_wren;
    wire        br_un;
    wire        lsu_wren;
    wire        pc_sel;
    wire        opa_sel;
    wire        opb_sel;
    wire        br_less;
    wire        br_equal;
    wire [1:0]  wb_sel;
    wire [3:0]  alu_op;

    // PC + 4
    adder_32bit adder4 (
        .a(pc),
        .b(32'h4),
        .cin(1'b0),
        .sum(pc_four),
        .cout()
    );

    assign pc_next = (pc_sel) ? alu_data : pc_four;

    pc_counter pc_counter (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_nextpc(pc_next),
        .o_pc(pc)
    );

    instruction_memory u_imem (
        .i_addr(pc[12:2]),
        .o_instr(instr)
    );

    regfile register_file (
        .i_clk(i_clk),
        .i_reset(~i_reset),
        .i_rs1_addr(instr[19:15]),
        .i_rs2_addr(instr[24:20]),
        .i_rd_addr(instr[11:7]),
        .i_rd_data(wb_data),
        .i_rd_wren(rd_wren),
        .o_rs1_data(rs1_data),
        .o_rs2_data(rs2_data)
    );

    immgen u_immgen (
        .i_instr(instr),
        .o_imm_data(imm)
    );

    control_unit control (
        .i_inst(instr),
        .i_br_less(br_less),
        .i_br_equal(br_equal),
        .o_inst_vld(o_insn_vld),
        .o_rd_wren(rd_wren),
        .o_br_un(br_un),
        .o_lsu_wren(lsu_wren),
        .o_pc_sel(pc_sel),
        .o_opa_sel(opa_sel),
        .o_opb_sel(opb_sel),
        .o_wb_sel(wb_sel),
        .o_alu_op(alu_op)
    );

    assign operand_a = (opa_sel) ? pc : rs1_data;
    assign operand_b = (opb_sel) ? imm : rs2_data;

    alu u_alu (
        .i_op_a(operand_a),
        .i_op_b(operand_b),
        .i_alu_op(alu_op),
        .o_alu_data(alu_data)
    );

    brc u_brc (
        .i_rs1_data(rs1_data),
        .i_rs2_data(rs2_data),
        .i_br_un(br_un),
        .o_br_less(br_less),
        .o_br_equal(br_equal)
    );

    lsu u_lsu (
        .i_clk(i_clk),
        .i_reset(~i_reset),
        .i_lsu_addr(alu_data),
        .i_st_data(rs2_data),
        .i_lsu_wren(lsu_wren),
        .i_io_sw(i_io_sw),
        .i_funct3(instr[14:12]),
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
        .o_io_hex7(o_io_hex7)
    );

    mux3to1 mux3 (
        .i_a(ld_data),
        .i_b(alu_data),
        .i_c(pc_four),
        .i_sel(wb_sel),
        .o_y(wb_data)
    );

    assign o_pc_debug = pc;

endmodule
