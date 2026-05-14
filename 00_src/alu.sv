module alu(
  input logic  [31:0] i_op_a,
  input logic  [31:0] i_op_b,
  input logic  [3:0]  i_alu_op, 
  output logic [31:0] o_alu_data
);

  //alu_op
  localparam [3:0]  ADD  = 4'b0000,
					SUB  = 4'b0001,
					SLL  = 4'b0010,
					SLT  = 4'b0011,
					SLTU = 4'b0100,
					XOR  = 4'b0101,
					SRL  = 4'b0110,
					SRA  = 4'b0111,
					OR   = 4'b1000,
					AND  = 4'b1001,
					OPB  = 4'b1010;
    logic [32:0] sub_pre;
    logic [31:0] state0, state1, state2, state3;

    assign sub_pre = {1'b0,i_op_a} + ~ {1'b0,i_op_b} + 1'b1;
	always_comb begin 

	 state0 = 32'b0;
	 state1 = 32'b0;
	 state2 = 32'b0;
         state3 = 32'b0;

    case (i_alu_op)
        ADD: o_alu_data = i_op_a + i_op_b;
        SUB: o_alu_data = sub_pre[31:0];
        XOR: o_alu_data = i_op_a ^ i_op_b;
        OR : o_alu_data = i_op_a | i_op_b;
        AND: o_alu_data = i_op_a & i_op_b;

        SLT: begin
             if(i_op_a[31] ^ i_op_b[31] == 1'b0) o_alu_data = {31'b0,sub_pre[31]};
             else o_alu_data = {31'b0,i_op_a[31]};
        end

        SLTU: begin
				o_alu_data = {31'b0, sub_pre[32]}; 
				end
				
        SLL: begin
            state0     = i_op_b[0] ? {i_op_a[30:0], 1'b0}  : i_op_a;
            state1     = i_op_b[1] ? {state0[29:0], 2'b0}  : state0;
            state2     = i_op_b[2] ? {state1[27:0], 4'b0}  : state1;
            state3     = i_op_b[3] ? {state2[23:0], 8'b0}  : state2;
            o_alu_data = i_op_b[4] ? {state3[15:0], 16'b0} : state3;
        end

        SRL: begin
            state0     = i_op_b[0] ? {1'b0,  i_op_a[31:1]}  : i_op_a;
            state1     = i_op_b[1] ? {2'b0,  state0[31:2]}  : state0;
            state2     = i_op_b[2] ? {4'b0,  state1[31:4]}  : state1;
            state3     = i_op_b[3] ? {8'b0,  state2[31:8]}  : state2;
            o_alu_data = i_op_b[4] ? {16'b0, state3[31:16]} : state3;
        end

        SRA: begin
            state0     = i_op_b[0] ? {i_op_a[31],     i_op_a[31:1]}  : i_op_a;
            state1     = i_op_b[1] ? {{2{i_op_a[31]}}, state0[31:2]} : state0;
            state2     = i_op_b[2] ? {{4{state1[31]}}, state1[31:4]} : state1;
            state3     = i_op_b[3] ? {{8{state2[31]}}, state2[31:8]} : state2;
            o_alu_data = i_op_b[4] ? {{16{state3[31]}},state3[31:16]}: state3;
        end

        OPB: o_alu_data = i_op_b;

        default: o_alu_data = 32'b0;
    endcase
end

endmodule

