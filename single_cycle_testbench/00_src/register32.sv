module register32 (
    input  logic        i_clk,   
    input  logic        i_reset, 
    input  logic        i_we,     
    input  logic [31:0] i_d,     
    output logic [31:0] o_q       
);
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            o_q <= 32'b0;       
        end else if (i_we) begin
            o_q <= i_d; 
		  end
	 end
endmodule
