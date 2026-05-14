`timescale 1ns/1ps

module tb_output_buffer;

reg         i_clk;
reg         i_reset;
reg  [2:0]  i_control;
reg  [31:0] i_out_buf_addr;
reg  [31:0] i_out_buf_data;
reg         i_wren;
reg  [3:0]  i_bmask;

wire [31:0] o_out_buf_data;
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


output_buffer dut (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_control(i_control),
    .i_out_buf_addr(i_out_buf_addr),
    .i_out_buf_data(i_out_buf_data),
    .i_wren(i_wren),
    .i_bmask(i_bmask),

    .o_out_buf_data(o_out_buf_data),
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

////////////////////////////////////////////////////////////
// CLOCK
////////////////////////////////////////////////////////////

always #5 i_clk = ~i_clk;

////////////////////////////////////////////////////////////
// DISPLAY TASK
////////////////////////////////////////////////////////////

task show_outputs;
begin
    $display("====================================");
    $display("TIME         = %0t", $time);

    $display("ADDR         = %h", i_out_buf_addr);
    $display("DATA_IN      = %h", i_out_buf_data);
    $display("WREN         = %b", i_wren);
    $display("BMASK        = %b", i_bmask);
    $display("CONTROL      = %b", i_control);

    $display("OUT_DATA     = %h", o_out_buf_data);

    $display("LEDR         = %h", o_io_ledr);
    $display("LEDG         = %h", o_io_ledg);

    $display("HEX0         = %b", o_io_hex0);
    $display("HEX1         = %b", o_io_hex1);
    $display("HEX2         = %b", o_io_hex2);
    $display("HEX3         = %b", o_io_hex3);
    $display("HEX4         = %b", o_io_hex4);
    $display("HEX5         = %b", o_io_hex5);
    $display("HEX6         = %b", o_io_hex6);
    $display("HEX7         = %b", o_io_hex7);

    $display("LCD          = %h", o_io_lcd);

    $display("====================================\n");
end
endtask

////////////////////////////////////////////////////////////
// TEST
////////////////////////////////////////////////////////////

initial begin

////////////////////////////////////////////////////////////
// INIT
////////////////////////////////////////////////////////////

    i_clk           = 0;
    i_reset         = 1;

    i_control       = 3'b010;
    i_out_buf_addr  = 0;
    i_out_buf_data  = 0;
    i_wren          = 0;
    i_bmask         = 0;

    #20;

    i_reset = 0;

////////////////////////////////////////////////////////////
// TEST 1 : RESET CHECK
////////////////////////////////////////////////////////////

    $display("TEST 1 : RESET CHECK");

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 2 : WRITE LEDR
////////////////////////////////////////////////////////////

    $display("TEST 2 : WRITE LEDR");

    i_out_buf_addr = 32'h1000_0000;
    i_out_buf_data = 32'h12345678;

    i_wren  = 1;
    i_bmask = 4'b1111;

    #10;

    i_wren = 0;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 3 : READ LEDR
////////////////////////////////////////////////////////////

    $display("TEST 3 : READ LEDR");

    i_control = 3'b010;
    i_out_buf_addr = 32'h1000_0000;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 4 : WRITE GREEN LED
////////////////////////////////////////////////////////////

    $display("TEST 4 : WRITE GREEN LED");

    i_out_buf_addr = 32'h1000_1000;
    i_out_buf_data = 32'h000000AA;

    i_wren  = 1;
    i_bmask = 4'b0001;

    #10;

    i_wren = 0;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 5 : WRITE HEX0
////////////////////////////////////////////////////////////

    $display("TEST 5 : WRITE HEX0");

    i_out_buf_addr = 32'h1000_2000;
    i_out_buf_data = 32'h0000003F;

    i_wren  = 1;
    i_bmask = 4'b0001;

    #10;

    i_wren = 0;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 6 : WRITE HEX1
////////////////////////////////////////////////////////////

    $display("TEST 6 : WRITE HEX1");

    i_out_buf_addr = 32'h1000_2001;
    i_out_buf_data = 32'h00000006;

    i_wren  = 1;
    i_bmask = 4'b0001;

    #10;

    i_wren = 0;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 7 : WRITE LCD
////////////////////////////////////////////////////////////

    $display("TEST 7 : WRITE LCD");

    i_out_buf_addr = 32'h1000_4000;
    i_out_buf_data = 32'hDEADBEEF;

    i_wren  = 1;
    i_bmask = 4'b1111;

    #10;

    i_wren = 0;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 8 : STORE BYTE
////////////////////////////////////////////////////////////

    $display("TEST 8 : STORE BYTE");

    i_out_buf_addr = 32'h1000_0001;
    i_out_buf_data = 32'h0000AA00;

    i_wren  = 1;

    i_bmask = 4'b0010;

    #10;

    i_wren = 0;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 9 : LB
////////////////////////////////////////////////////////////

    $display("TEST 9 : LOAD BYTE");

    i_control = 3'b000;
    i_out_buf_addr = 32'h1000_0001;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////
// TEST 10 : LW
////////////////////////////////////////////////////////////

    $display("TEST 10 : LOAD WORD");

    i_control = 3'b010;
    i_out_buf_addr = 32'h1000_0000;

    #10;

    show_outputs();

////////////////////////////////////////////////////////////

    #50;

    $finish;

end

endmodule
