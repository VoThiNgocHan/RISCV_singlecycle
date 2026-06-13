module register32 (
    input          i_clk,   
    input          i_reset, 
    input          i_we,     
    input   [31:0] i_d,     
    output reg [31:0] o_q       
);
    always @(posedge i_clk) begin
        if (i_reset) begin
            o_q <= 32'b0;       
        end else if (i_we) begin
            o_q <= i_d; 
		  end
	 end
endmodule

