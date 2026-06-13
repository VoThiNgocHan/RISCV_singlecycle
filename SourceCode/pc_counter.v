module pc_counter (
  input   i_clk, 
  input   i_reset,
  input   [31:0] i_nextpc,
  output reg [31:0] o_pc
);
  always @(posedge i_clk) begin : pc_ff
    if (~i_reset)
	   o_pc <= 32'h0;
	 else 
	   o_pc <= i_nextpc;
  end
endmodule

