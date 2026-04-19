module regfile(
    input  logic        i_clk, 
    input  logic        i_reset,
    input  logic [4:0]  i_rs1_addr,
    input  logic [4:0]  i_rs2_addr,
    input  logic [4:0]  i_rd_addr,
    input  logic [31:0] i_rd_data,
    input  logic        i_rd_wren,
    output logic [31:0] o_rs1_data, o_rs2_data
);
logic [31:0] registers [0:31];
int i;

always_ff @(posedge i_clk or negedge i_reset) begin 
    if(!i_reset) begin 
        for(i=0;i<=31;i++)begin
           registers[i] = 32'b0;
        end
    end else if (i_rd_addr != 5'b0 && i_rd_wren ) registers[i_rd_addr] = i_rd_data;
    else registers[0] = 32'b0;
end
          
assign o_rs1_data = (i_rs1_addr != 5'b0) ? registers[i_rs1_addr] : 32'b0;
assign o_rs2_data = (i_rs2_addr != 5'b0) ? registers[i_rs2_addr] : 32'b0;
endmodule
