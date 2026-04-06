module opa_mux(
    input [31:0] pc,
    input [31:0] rs1_data,
    input opa_sel,
    output operand_a
);
assign operand_a = (opa_sel)? pc: rs1_data;
endmodule
