module pc_hold(
    input   [31:0] i_pc_next,
    input   i_clk,
    input   i_rst,
    output reg [31:0] o_pc
);
always @(posedge i_clk or posedge i_rst) begin
    if(i_rst) o_pc <= 32'b0;
    else o_pc <= i_pc_next;
end
endmodule

