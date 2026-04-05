module brc(
    input [31:0] i_rs1_data,
    input [31:0] i_rs2_data,
    input i_br_un,
    output o_br_less, o_br_equal
);

wire [31:0] diff = i_rs1_data + (~i_rs2_data + 1);
wire sign_a = i_rs1_data[31];
wire sign_b = i_rs2_data[31];

wire slt_o = (sign_a ^ sign_b)? sign_a: diff[31];
wire [32:0] temp = {1'b0, i_rs1_data} + {1'b0, ~i_rs2_data} + 1;
wire sltu_o = ~temp[32];   
assign o_br_equal = (i_rs1_data == i_rs2_data);
assign o_br_less = (i_br_un)? slt_o: sltu_o;

endmodule


