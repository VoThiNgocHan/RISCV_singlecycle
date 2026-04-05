module regfile (
   input i_clk, i_rst, i_rd_wren,
   input [4:0] i_rs1_addr, i_rs2_addr, i_rd_addr,
   input [31:0] i_rd_data,
   output [31:0] o_rs1_data, o_rs2_data
);
reg [31:0] regs [31:0];
integer i;
always @(posedge i_clk or negedge i_rst) begin
    if(!i_rst) begin
        for(i=0; i<32; i=i+1) begin
            regs[i] <= 32'b0;
        end
    end
    else begin
        if(i_rd_wren && i_rd_addr != 5'd0)
            regs[i_rd_addr] <= i_rd_data;
    end
end
assign o_rs1_data = (i_rs1_addr == 5'b0)? 32'b0: regs[i_rs1_addr];
assign o_rs2_data = (i_rs2_addr == 5'b0)? 32'b0: regs[i_rs2_addr];
endmodule
