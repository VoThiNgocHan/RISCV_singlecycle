module opb_mux(
    input [31:0] rs2_data,
    input [31:0] imm,
    input opb_sel,
    output [31:0] operand_b
);
assign operand_b = (opb_sel)? imm : rs2_data;
endmodule
