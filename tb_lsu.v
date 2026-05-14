`timescale 1ns/1ps

module tb_lsu;

reg         i_clk;
reg         i_reset;
reg  [31:0] i_lsu_addr;
reg  [31:0] i_st_data;
reg         i_lsu_wren;
reg  [31:0] i_io_sw;
reg  [2:0]  i_control;

wire [31:0] o_ld_data;
wire [31:0] o_io_ledr;
wire [31:0] o_io_ledg;
wire [6:0] o_io_hex0;
wire [6:0] o_io_hex1;
wire [6:0] o_io_hex2;
wire [6:0] o_io_hex3;
wire [6:0] o_io_hex4;
wire [6:0] o_io_hex5;
wire [6:0] o_io_hex6;
wire [6:0] o_io_hex7;
wire [31:0] o_io_lcd;

////////////////////////////////////////////////////////////
// DUT
////////////////////////////////////////////////////////////

lsu dut (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_lsu_addr(i_lsu_addr),
    .i_st_data(i_st_data),
    .i_lsu_wren(i_lsu_wren),
    .i_io_sw(i_io_sw),
    .i_control(i_control),

    .o_ld_data(o_ld_data),
    .o_io_ledr(o_io_ledr),
    .o_io_ledg(o_io_ledg),

    .o_io_hex0(o_io_hex0),
    .o_io_hex1(o_io_hex1),
    .o_io_hex2(o_io_hex2),
    .o_io_hex3(o_io_hex3),
    .o_io_hex4(o_io_hex4),
    .o_io_hex5(o_io_hex5),
    .o_io_hex6(o_io_hex6),
    .o_io_hex7(o_io_hex7),

    .o_io_lcd(o_io_lcd)
);

always #5 i_clk = ~i_clk;

////////////////////////////////////////////////////////////
// TASK DISPLAY
////////////////////////////////////////////////////////////

task show_outputs;
begin
    $display("----------------------------------------");
    $display("TIME = %0t", $time);

    $display("ADDR      = %h", i_lsu_addr);
    $display("ST_DATA   = %h", i_st_data);
    $display("WREN      = %b", i_lsu_wren);
    $display("CONTROL   = %b", i_control);

    $display("LD_DATA   = %h", o_ld_data);

    $display("LEDR      = %h", o_io_ledr);
    $display("LEDG      = %h", o_io_ledg);

    $display("HEX0      = %b", o_io_hex0);
    $display("HEX1      = %b", o_io_hex1);
    $display("HEX2      = %b", o_io_hex2);
    $display("HEX3      = %b", o_io_hex3);
    $display("HEX4      = %b", o_io_hex4);
    $display("HEX5      = %b", o_io_hex5);
    $display("HEX6      = %b", o_io_hex6);
    $display("HEX7      = %b", o_io_hex7);

    $display("LCD       = %h", o_io_lcd);
    $display("----------------------------------------\n");
end
endtask

////////////////////////////////////////////////////////////
// TEST
////////////////////////////////////////////////////////////

initial begin

    // INIT

    i_clk       = 0;
    i_reset     = 1;

    i_lsu_addr  = 0;
    i_st_data   = 0;
    i_lsu_wren  = 0;
    i_io_sw     = 0;
    i_control   = 0;

    #20;

    i_reset = 0;

////////////////////////////////////////////////////////////
// TEST 1 : INPUT BUFFER (SWITCH)
////////////////////////////////////////////////////////////

    $display("TEST 1 : INPUT BUFFER");

    i_lsu_addr = 32'h1001_0000;
    i_io_sw    = 32'hA5A5_F0F0;
    i_lsu_wren = 0;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 2 : STORE WORD TO DATA MEMORY
////////////////////////////////////////////////////////////

    $display("TEST 2 : STORE WORD");

    i_lsu_addr = 32'h0000_0004;
    i_st_data  = 32'h12345678;
    i_control  = 3'b010; // SW
    i_lsu_wren = 1;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 3 : LOAD WORD FROM DATA MEMORY
////////////////////////////////////////////////////////////

    $display("TEST 3 : LOAD WORD");

    i_lsu_addr = 32'h0000_0004;
    i_lsu_wren = 0;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 4 : STORE BYTE
////////////////////////////////////////////////////////////

    $display("TEST 4 : STORE BYTE");

    i_lsu_addr = 32'h0000_0001;
    i_st_data  = 32'h000000AA;
    i_control  = 3'b000; // SB
    i_lsu_wren = 1;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 5 : STORE HALFWORD
////////////////////////////////////////////////////////////

    $display("TEST 5 : STORE HALFWORD");

    i_lsu_addr = 32'h0000_0002;
    i_st_data  = 32'h0000BBBB;
    i_control  = 3'b001; // SH
    i_lsu_wren = 1;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 6 : OUTPUT BUFFER (LEDR)
////////////////////////////////////////////////////////////

    $display("TEST 6 : OUTPUT BUFFER");

    i_lsu_addr = 32'h1000_0000;
    i_st_data  = 32'h000000FF;
    i_control  = 3'b010;
    i_lsu_wren = 1;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 7 : OUTPUT BUFFER (HEX)
////////////////////////////////////////////////////////////

    $display("TEST 7 : HEX DISPLAY");

    i_lsu_addr = 32'h1000_2000;
    i_st_data  = 32'h12345678;
    i_control  = 3'b010;
    i_lsu_wren = 1;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 8 : LCD
////////////////////////////////////////////////////////////

    $display("TEST 8 : LCD");

    i_lsu_addr = 32'h1000_4000;
    i_st_data  = 32'hDEADBEEF;
    i_control  = 3'b010;
    i_lsu_wren = 1;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////

    #50;

    $finish;

end

endmodule
