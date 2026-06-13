module memory
(
	input logic i_clk,
	input logic i_reset,
	input logic i_wren,
	input logic [8:0] i_addr,			 
	input logic [31:0] i_wdata,		    
	input logic [3:0] i_bmask,		   
	output logic [31:0] o_rdata
);
        logic [7:0] mem0 [0:511];
        logic [7:0] mem1 [0:511];
        logic [7:0] mem2 [0:511];
        logic [7:0] mem3 [0:511];
	
	assign o_rdata = {mem3[i_addr], mem2[i_addr], mem1[i_addr], mem0[i_addr]};
	
	
	always @ (posedge i_clk) begin
		if(i_reset) begin
			for (int i = 0; i < 512; i++) begin
				mem0[i] <= 8'b0;
				mem1[i] <= 8'b0;
				mem2[i] <= 8'b0;
				mem3[i] <= 8'b0;
			end
		end
		else begin
			if(i_wren) begin
				if(i_bmask[0]) begin
					mem0[i_addr] <= i_wdata[7:0];
				end
				if(i_bmask[1]) begin
					mem1[i_addr] <= i_wdata[15:8];
				end
				if(i_bmask[2]) begin
					mem2[i_addr]<= i_wdata[23:16];
				end
				if(i_bmask[3]) begin
					mem3[i_addr] <= i_wdata[31:24];
				end
			end
		end
	end
	
endmodule
