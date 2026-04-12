module lsu (
    input i_clk,
    input i_reset,
    input [31:0] i_lsu_addr,
    input [31:0] i_st_data,
    input i_lsu_wren,
    input [31:0] i_io_sw,
    output reg [31:0] o_ld_data,
    output reg [31:0] o_io_ledr,
    output reg [31:0] o_io_ledg,
    output [6:0] o_io_hex07,
    output [31:0] o_io_lcd
);

reg [31:0] mem [0:511];
initial begin
    $readmemh("mem.dump", mem); 
end

wire is_mem   = (i_lsu_addr < 32'h0000_0800);
wire is_ledr  = (i_lsu_addr == 32'h1000_0000);
wire is_ledg  = (i_lsu_addr == 32'h1000_1000);
wire is_sw    = (i_lsu_addr == 32'h1001_0000);

//////////////////////write///////////////////
always @(posedge i_clk) begin
    if(i_reset) begin
        o_io_ledg <= 0;
        o_io_ledr <= 0;
    end 
    if(i_lsu_wren) begin
        if(is_mem) begin
            mem[i_lsu_addr[10:2]] <= i_st_data;
        end
        else if(is_ledr) begin
            o_io_ledr <= i_st_data;
        end
        else if(is_ledg) begin
            o_io_ledg <= i_st_data;
        end
    end
end

////////////////////////////////////read////////////////////////
always @(*) begin
        if(is_mem) begin
           o_ld_data = mem[i_lsu_addr[10:2]];
        end
        else if(is_sw) begin
            o_ld_data = i_io_sw;
        end
        else begin
            o_ld_data = 32'b0;
        end
end



endmodule
