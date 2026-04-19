module pc_4(
    input  logic [31:0] i_pc,
    output logic [31:0] o_pc_four
);
assign o_pc_four = i_pc + 32'd4;

endmodule

