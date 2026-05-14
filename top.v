module top(

    input clk,
    input reset,

    input  [31:0] sw,

    output [31:0] ledr,

    output [6:0] hex0,
    output [6:0] hex1,
    output [6:0] hex2,
    output [6:0] hex3,

    output [31:0] lcd
);

////////////////////////////////////////////////////////////
// CPU <-> LSU
////////////////////////////////////////////////////////////

wire [31:0] lsu_addr;
wire [31:0] st_data;
wire [31:0] ld_data;

wire        lsu_wren;
wire        lsu_rden;

wire [2:0]  lsu_control;

////////////////////////////////////////////////////////////
// LSU <-> AVALON INTERCONNECT
////////////////////////////////////////////////////////////

wire [31:0] avm_address;
wire [31:0] avm_writedata;
wire [31:0] avm_readdata;

wire        avm_write;
wire        avm_read;

wire [3:0]  avm_byteenable;

////////////////////////////////////////////////////////////
// INTERCONNECT <-> SLAVES
////////////////////////////////////////////////////////////

wire sram_write;
wire led_write;
wire hex_write;
wire lcd_write;

wire sram_read;
wire led_read;
wire hex_read;
wire lcd_read;

////////////////////////////////////////////////////////////
// SLAVE READ DATA
////////////////////////////////////////////////////////////

wire [31:0] sram_readdata;
wire [31:0] led_readdata;
wire [31:0] hex_readdata;
wire [31:0] lcd_readdata;

////////////////////////////////////////////////////////////
// CPU
////////////////////////////////////////////////////////////

cpu cpu_inst(

    .i_clk(clk),
    .i_reset(reset),

    // LSU interface
    .o_lsu_addr(lsu_addr),
    .o_st_data(st_data),
    .o_lsu_wren(lsu_wren),
    .o_lsu_rden(lsu_rden),
    .o_lsu_control(lsu_control),

    .i_ld_data(ld_data)
);

////////////////////////////////////////////////////////////
// LSU
////////////////////////////////////////////////////////////

lsu lsu_inst(

    .i_clk(clk),
    .i_reset(reset),

    // from CPU
    .i_lsu_addr(lsu_addr),
    .i_st_data(st_data),
    .i_lsu_wren(lsu_wren),
    .i_lsu_rden(lsu_rden),
    .i_control(lsu_control),

    // from bus
    .i_avm_readdata(avm_readdata),
    .i_avm_waitrequest(1'b0),

    // back to CPU
    .o_ld_data(ld_data),

    // Avalon-MM master
    .o_avm_address(avm_address),
    .o_avm_writedata(avm_writedata),
    .o_avm_write(avm_write),
    .o_avm_read(avm_read),
    .o_avm_byteenable(avm_byteenable)
);

////////////////////////////////////////////////////////////
// AVALON INTERCONNECT
////////////////////////////////////////////////////////////

avalon_interconnect interconnect(

    .address(avm_address),
    .writedata(avm_writedata),

    .write(avm_write),
    .read(avm_read),

    .byteenable(avm_byteenable),

    // slave read data
    .sram_readdata(sram_readdata),
    .led_readdata(led_readdata),
    .hex_readdata(hex_readdata),
    .lcd_readdata(lcd_readdata),

    // back to LSU
    .readdata(avm_readdata),

    // slave control
    .sram_write(sram_write),
    .led_write(led_write),
    .hex_write(hex_write),
    .lcd_write(lcd_write),

    .sram_read(sram_read),
    .led_read(led_read),
    .hex_read(hex_read),
    .lcd_read(lcd_read)
);

////////////////////////////////////////////////////////////
// SRAM SLAVE
////////////////////////////////////////////////////////////

sram_slave sram_inst(

    .clk(clk),
    .reset(reset),

    .address(avm_address),
    .writedata(avm_writedata),

    .write(sram_write),
    .read(sram_read),

    .byteenable(avm_byteenable),

    .readdata(sram_readdata)
);

////////////////////////////////////////////////////////////
// LED SLAVE
////////////////////////////////////////////////////////////

led_slave led_inst(

    .clk(clk),
    .reset(reset),

    .address(avm_address),
    .writedata(avm_writedata),

    .write(led_write),
    .read(led_read),

    .byteenable(avm_byteenable),

    .readdata(led_readdata),

    .ledr(ledr)
);

////////////////////////////////////////////////////////////
// HEX SLAVE
////////////////////////////////////////////////////////////

hex_slave hex_inst(

    .clk(clk),
    .reset(reset),

    .address(avm_address),
    .writedata(avm_writedata),

    .write(hex_write),
    .read(hex_read),

    .byteenable(avm_byteenable),

    .readdata(hex_readdata),

    .ohex0(hex0),
    .ohex1(hex1),
    .ohex2(hex2),
    .ohex3(hex3)
);

////////////////////////////////////////////////////////////
// LCD SLAVE
////////////////////////////////////////////////////////////

lcd_slave lcd_inst(

    .clk(clk),
    .reset(reset),

    .address(avm_address),
    .writedata(avm_writedata),

    .write(lcd_write),
    .read(lcd_read),

    .byteenable(avm_byteenable),

    .readdata(lcd_readdata),

    .lcdr(lcd)
);



endmodule
