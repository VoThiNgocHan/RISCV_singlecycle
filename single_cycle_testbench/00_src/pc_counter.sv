module pc_counter (
  input  logic i_clk, 
  input  logic i_reset,
  input  logic [31:0] i_nextpc,
  output logic [31:0] o_pc
);
  always_ff @(posedge i_clk) begin : pc_ff
    if (~i_reset)
	   o_pc <= 32'h0;
	 else 
	   o_pc <= i_nextpc;
  end
endmodule
