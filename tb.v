module tb;
reg [31:0] a, b;
reg [3:0] op;
wire [31:0] alu_out;
reg [31:0] rs1, rs2;
reg br_un;
wire br_less, br_equal;

alu alu_dut (
    .i_op_a(a),
    .i_op_b(b),
    .i_alu_op(op),
    .o_alu_data(alu_out)
);

brc brc_dut (
    .i_rs1_data(rs1),
    .i_rs2_data(rs2),
    .i_br_un(br_un),
    .o_br_less(br_less),
    .o_br_equal(br_equal)
);

initial begin
    a = 10; b = 5; op = 0; #10;   // add
    a = 10; b = 5; op = 1; #10;   // sub
    a = -5; b = 3; op = 2; #10;   // slt
    a = 32'hFFFFFFFF; b = 1; op = 3; #10; // sltu
    a = 6; b = 3; op = 4; #10;    // xor
    a = 6; b = 3; op = 5; #10;    // or
    a = 6; b = 3; op = 6; #10;    // and
    a = 1; b = 2; op = 7; #10;    // sll
    a = 8; b = 2; op = 8; #10;    // srl
    a = -8; b = 2; op = 9; #10;   // sra

    rs1 = 5; rs2 = 5; br_un = 0; #10;          // equal
    rs1 = -5; rs2 = 3; br_un = 1; #10;         // signed <
    rs1 = 5; rs2 = 10; br_un = 0; #10;         // unsigned <
    rs1 = 32'hFFFFFFFF; rs2 = 1; br_un = 0; #10; // unsigned >
    rs1 = 32'hFFFFFFFF; rs2 = 1; br_un = 1; #10; // signed <

    $stop;
end

endmodule
