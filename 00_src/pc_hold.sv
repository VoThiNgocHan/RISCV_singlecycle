module pc_hold(
    input  logic [31:0] i_pc_next,
    input  logic        i_clk,
    input  logic        i_rst_n,
    output logic [31:0] o_pc
);
always_ff @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) o_pc <= 32'b0;
    else o_pc <= i_pc_next;
end
endmodule
