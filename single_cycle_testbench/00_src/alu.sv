module alu (
  input  logic [31:0] 	i_op_a,
  input logic 	[31:0] 	i_op_b,
  input  logic [3:0] 	i_alu_op,
  output logic [31:0] 	o_alu_data
);

  localparam ALU_ADD  = 4'b0000;
  localparam ALU_SUB  = 4'b0001;
  localparam ALU_SLL  = 4'b0010;
  localparam ALU_SLT  = 4'b0011;
  localparam ALU_SLTU = 4'b0100;
  localparam ALU_XOR  = 4'b0101;
  localparam ALU_SRL  = 4'b0110;
  localparam ALU_SRA  = 4'b0111;
  localparam ALU_OR   = 4'b1000;
  localparam ALU_AND  = 4'b1001;
  localparam ALU_LUI  = 4'b1010;
  
  logic [31:0] s,b;
  logic cout, c;

  //tru
  		  adder_32bit adder(
		    .a(i_op_a),
			 .b(b),
			 .cin(c),
			 .sum(s),
			 .cout(cout)
		  );
		  
  logic borrow;
  assign borrow = ~cout;
  
  logic overflow;
  assign overflow = (i_op_a[31] & ~i_op_b[31] & ~s[31]) | (~i_op_a[31] & i_op_b[31] & s[31]);
  
  //SLL
  logic [31:0] sll1, sll2, sll3, sll4, sll5, sll_out;
  assign sll1 = (i_op_b[0]) ? {i_op_a[30:0], 1'b0} : i_op_a;
  assign sll2 = (i_op_b[1]) ? {sll1[29:0], 2'b0}   : sll1;
  assign sll3 = (i_op_b[2]) ? {sll2[27:0], 4'b0}   : sll2;
  assign sll4 = (i_op_b[3]) ? {sll3[23:0], 8'b0}   : sll3;
  assign sll5 = (i_op_b[4]) ? {sll4[15:0],16'b0}   : sll4;
  assign sll_out = sll5;
  
  //SRL
  logic [31:0] srl1, srl2, srl3, srl4, srl5, srl_out;
  assign srl1 = (i_op_b[0]) ? {1'b0, i_op_a[31:1]} : i_op_a;
  assign srl2 = (i_op_b[1]) ? {2'b0, srl1[31:2]}   : srl1;
  assign srl3 = (i_op_b[2]) ? {4'b0, srl2[31:4]}   : srl2;
  assign srl4 = (i_op_b[3]) ? {8'b0, srl3[31:8]}   : srl3;
  assign srl5 = (i_op_b[4]) ? {16'b0, srl4[31:16]} : srl4;
  assign srl_out = srl5;
  
   //SRA
  logic [31:0] sra1, sra2, sra3, sra4, sra5, sra_out;
  assign sra1 = (i_op_b[0]) ? {{1{i_op_a[31]}}, i_op_a[31:1]} : i_op_a;
  assign sra2 = (i_op_b[1]) ? {{2{sra1[31]}}, sra1[31:2]}     : sra1;
  assign sra3 = (i_op_b[2]) ? {{4{sra2[31]}}, sra2[31:4]}     : sra2;
  assign sra4 = (i_op_b[3]) ? {{8{sra3[31]}}, sra3[31:8]}     : sra3;
  assign sra5 = (i_op_b[4]) ? {{16{sra4[31]}}, sra4[31:16]}   : sra4;
  assign sra_out = sra5;
  
// input 
  always_comb begin
    case(i_alu_op)
	 ALU_ADD: begin
	   b = i_op_b;
		c = 1'b0;
	 end
	 ALU_SUB: begin
	   b = ~i_op_b;
		c = 1'b1;
	 end
	 ALU_SLL: begin
	   b = i_op_b;
		c = 1'b0;
	 end
	 ALU_SLT: begin
	   b = ~i_op_b;
		c = 1'b1;
	 end
	 ALU_SLTU:begin
	   b = ~i_op_b;
		c = 1'b1;
	 end
	 ALU_XOR: begin
	   b = i_op_b;
		c = 1'b0;
	 end
	 ALU_SRL: begin
	   b = i_op_b;
		c = 1'b0;
	 end
	 ALU_SRA: begin
	   b = i_op_b;
		c = 1'b0;
	 end
	 ALU_OR:  begin
	   b = i_op_b;
		c = 1'b0;
	 end
	 ALU_AND: begin
	   b = i_op_b;
		c = 1'b0;
	 end
	 default: begin
	   b = i_op_b;
		c = 1'b0;
	 end
	 endcase
  end
  
  always_comb begin
    case(i_alu_op)
	   ALU_ADD: o_alu_data = s; //ADD	
		ALU_SUB: o_alu_data = s; //SUB
		ALU_SLL: o_alu_data = sll_out;
		ALU_SLT: o_alu_data = {30'b0, s[31] ^ overflow};
		ALU_SLTU:o_alu_data = {30'b0, borrow};
		ALU_XOR: o_alu_data = i_op_a ^ i_op_b;                 //XOR
		ALU_SRL: o_alu_data = srl_out;
		ALU_SRA: o_alu_data = sra_out;
		ALU_OR : o_alu_data = i_op_a | i_op_b;                 //OR
		ALU_AND: o_alu_data = i_op_a & i_op_b;                 //AND
		ALU_LUI: o_alu_data = i_op_b;
		default: o_alu_data = 32'b0;
	 endcase
  end
endmodule
