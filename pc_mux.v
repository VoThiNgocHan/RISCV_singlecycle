module pc_mux(
    input [31:0] alu_data,
    input [31:0] pc_four,
    input pc_sel,
    output [31:0] pc_next
);
assign pc_next = (pc_sel)? alu_data: pc_four;
endmodule
