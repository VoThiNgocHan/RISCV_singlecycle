`timescale 1ns/1ps

module tb_control_unit;
reg  [31:0] i_inst;
reg  i_br_less;
reg  i_br_equal;
wire o_pc_sel;
wire o_rd_wren;
wire o_insn_vld;
wire o_br_un;
wire o_opa_sel;
wire o_opb_sel;
wire [3:0] o_alu_op;
wire o_mem_wren;
wire [1:0] o_wb_sel;
wire [2:0] o_ImmSrc;
wire o_is_jalr;

control_unit dut (
    .i_inst(i_inst),
    .i_br_less(i_br_less),
    .i_br_equal(i_br_equal),
    .o_pc_sel(o_pc_sel),
    .o_rd_wren(o_rd_wren),
    .o_insn_vld(o_insn_vld),
    .o_br_un(o_br_un),
    .o_opa_sel(o_opa_sel),
    .o_opb_sel(o_opb_sel),
    .o_alu_op(o_alu_op),
    .o_mem_wren(o_mem_wren),
    .o_wb_sel(o_wb_sel),
    .o_ImmSrc(o_ImmSrc),
    .o_is_jalr(o_is_jalr)
);

initial begin
    $display("===== CONTROL UNIT TEST =====");
//////////////////////////////////////////////////////////
// ADD
//////////////////////////////////////////////////////////
    i_inst = 32'b0000000_00011_00010_000_00001_0110011;
    i_br_less = 0;
    i_br_equal = 0;
    #10;
    $display("ADD");
    $display("alu_op = %b", o_alu_op);
    $display("rd_wren = %b", o_rd_wren);
//////////////////////////////////////////////////////////
// SUB
//////////////////////////////////////////////////////////
    i_inst = 32'b0100000_00011_00010_000_00001_0110011;
    #10;
    $display("SUB");
    $display("alu_op = %b", o_alu_op);
//////////////////////////////////////////////////////////
// ADDI
//////////////////////////////////////////////////////////
    i_inst = 32'b000000000101_00010_000_00001_0010011;
    #10;
    $display("ADDI");
    $display("opb_sel = %b", o_opb_sel);
    $display("alu_op = %b", o_alu_op);
//////////////////////////////////////////////////////////
// LW
//////////////////////////////////////////////////////////
    i_inst = 32'b000000000100_00010_010_00001_0000011;
    #10;
    $display("LW");
    $display("wb_sel = %b", o_wb_sel);
    $display("rd_wren = %b", o_rd_wren);
//////////////////////////////////////////////////////////
// SW
//////////////////////////////////////////////////////////
    i_inst = 32'b0000000_00001_00010_010_00100_0100011;
    #10;
    $display("SW");
    $display("mem_wren = %b", o_mem_wren);
//////////////////////////////////////////////////////////
// BEQ taken
//////////////////////////////////////////////////////////
    i_inst = 32'b0000000_00001_00010_000_00100_1100011;
    i_br_equal = 1;
    #10;
    $display("BEQ TAKEN");
    $display("pc_sel = %b", o_pc_sel);
//////////////////////////////////////////////////////////
// BLT taken
//////////////////////////////////////////////////////////
    i_inst = 32'b0000000_00001_00010_100_00100_1100011;
    i_br_less = 1;
    #10;
    $display("BLT TAKEN");
    $display("pc_sel = %b", o_pc_sel);
//////////////////////////////////////////////////////////
// JAL
//////////////////////////////////////////////////////////
    i_inst = 32'b0;
    i_inst[6:0] = 7'b1101111;
    #10;
    $display("JAL");
    $display("pc_sel = %b", o_pc_sel);
    $display("rd_wren = %b", o_rd_wren);
//////////////////////////////////////////////////////////
// JALR
//////////////////////////////////////////////////////////
    i_inst = 32'b0;
    i_inst[6:0] = 7'b1100111;
    #10;
    $display("JALR");
    $display("is_jalr = %b", o_is_jalr);
//////////////////////////////////////////////////////////
// LUI
//////////////////////////////////////////////////////////
    i_inst = 32'b0;
    i_inst[6:0] = 7'b0110111;
    #10;
    $display("LUI");
    $display("rd_wren = %b", o_rd_wren);
//////////////////////////////////////////////////////////
// AUIPC
//////////////////////////////////////////////////////////
    i_inst = 32'b0;
    i_inst[6:0] = 7'b0010111;
    #10;
    $display("AUIPC");
    $display("opa_sel = %b", o_opa_sel);
//////////////////////////////////////////////////////////
    #20;
    $finish;
end

endmodule
