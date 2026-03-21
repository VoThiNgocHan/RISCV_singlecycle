module alu(
    input [31:0] i_op_a,
    input [31:0] i_op_b,
    input [3:0] i_alu_op,
    output reg [31:0] o_alu_data
);
parameter add = 4'b0000,
          sub = 4'b0001,
          slt = 4'b0010,
          sltu = 4'b0011,
          xxor = 4'b0100,
          oor = 4'b0101,
          aand = 4'b0110,
          sll = 4'b0111,
          srl = 4'b1000,
          sra = 4'b1001;

wire [31:0] bsub = ~i_op_b + 1;
wire [31:0] diff = i_op_a + bsub;

wire sign_a = i_op_a[31];
wire sign_b = i_op_b[31];

//////slt signed////
wire slt_res = (sign_a ^ sign_b)? sign_a: diff[31];
/////slt unsigned////
wire [32:0] temp = {1'b0, i_op_a} + {1'b0,~i_op_b} + 1;
wire sltu_res = ~temp[32];

wire [31:0] sll_res, srl_res, sra_res;

/////////////sll////////////
wire [31:0] l1, l2, l3, l4, l5;
assign l1 = i_op_b[0]? {i_op_a[30:0], 1'b0}: i_op_a;
assign l2 = i_op_b[1]? {l1[29:0], 2'b0}: l1;
assign l3 = i_op_b[2]? {l2[27:0], 4'b0}: l2;
assign l4 = i_op_b[3]? {l3[23:0], 8'b0}: l3;
assign l5 = i_op_b[4]? {l4[15:0], 16'b0}: l4;
assign sll_res = l5;

//////////////srl//////////////
wire[31:0] r1, r2, r3, r4, r5;
assign r1 = i_op_b[0]? {1'b0, i_op_a[31:1]}: i_op_a;
assign r2 = i_op_b[1]? {2'b0, r1[31:2]}: r1;
assign r3 = i_op_b[2]? {4'b0, r2[31:4]}: r2;
assign r4 = i_op_b[3]? {8'b0, r3[31:8]}: r3;
assign r5 = i_op_b[4]? {16'b0, r4[31:16]}: r4;
assign srl_res = r5;

////////////////////sra////////////////////////
wire [31:0] a1, a2, a3, a4, a5;
assign a1 = i_op_b[0]? {i_op_a[31], i_op_a[31:1]}: i_op_a;
assign a2 = i_op_b[1]? {{2{a1[31]}}, a1[31:2]}: a1;
assign a3 = i_op_b[2]? {{4{a2[31]}}, a2[31:4]}: a2;
assign a4 = i_op_b[3]? {{8{a3[31]}}, a3[31:8]}: a3;
assign a5 = i_op_b[4]? {{16{a4[31]}}, a4[31:16]}: a4;
assign sra_res = a5;

always @(*) begin
    case (i_alu_op)
        add: o_alu_data = i_op_a + i_op_b;
        sub: o_alu_data = i_op_a + bsub;
        slt: o_alu_data = {31'd0, slt_res};
        sltu: o_alu_data = {31'd0, sltu_res};
        xxor: o_alu_data = i_op_a ^ i_op_b;
        oor: o_alu_data = i_op_a | i_op_b;
        aand: o_alu_data = i_op_a & i_op_b;
        sll: o_alu_data = sll_res;
        srl: o_alu_data = srl_res;
        sra: o_alu_data = sra_res;
        default: o_alu_data = 32'd0;
    endcase
end
endmodule

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

