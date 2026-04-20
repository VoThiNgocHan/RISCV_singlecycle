module alu(
    input  [31:0] i_op_a,
    input  [31:0] i_op_b,
    input  [3:0]  i_alu_op,
    output reg [31:0] o_alu_data
);

localparam ADD  = 4'b0000,
           SUB  = 4'b0001,
           SLL  = 4'b0010,
           SLT  = 4'b0011,
           SLTU = 4'b0100,
           XOR  = 4'b0101,
           SRL  = 4'b0110,
           SRA  = 4'b0111,
           OR   = 4'b1000,
           AND  = 4'b1001;

always @(*) begin
    case (i_alu_op)
        ADD:  o_alu_data = i_op_a + i_op_b;
        SUB:  o_alu_data = i_op_a - i_op_b;

        SLL:  o_alu_data = i_op_a << i_op_b[4:0];
        SRL:  o_alu_data = i_op_a >> i_op_b[4:0];
        SRA:  o_alu_data = $signed(i_op_a) >>> i_op_b[4:0];

        SLT:  o_alu_data = ($signed(i_op_a) < $signed(i_op_b)) ? 32'd1 : 32'd0;
        SLTU: o_alu_data = (i_op_a < i_op_b) ? 32'd1 : 32'd0;

        XOR:  o_alu_data = i_op_a ^ i_op_b;
        OR:   o_alu_data = i_op_a | i_op_b;
        AND:  o_alu_data = i_op_a & i_op_b;

        default: o_alu_data = 32'd0;
    endcase
end

endmodule