module pc_hold(
    input   [31:0] i_pc_next,
    input   i_clk,
    input   i_rst_n,
    output reg [31:0] o_pc
);
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) o_pc <= 32'b0;
    else o_pc <= i_pc_next;
end
endmodule

