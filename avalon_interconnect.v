module avalon_interconnect(
    input [31:0] address,
    input [31:0] writedata,
    input        write,
    input        read,
    input [3:0]  byteenable,
    input [31:0] sram_readdata,
    input [31:0] led_readdata,
    input [31:0] hex_readdata,
    input [31:0] lcd_readdata,
    output reg [31:0] readdata,
    output sram_write,
    output led_write,
    output hex_write,
    output lcd_write,
    output sram_read,
    output led_read,
    output hex_read,
    output lcd_read
);

wire sram_sel;
wire led_sel;
wire hex_sel;
wire lcd_sel;

assign sram_sel = (address[31:16] == 16'h0000);
assign led_sel = (address == 32'h10000000);
assign hex_sel = (address[31:16] == 16'h1000) && (address[15:12] == 4'h2);
assign lcd_sel = (address[31:16] == 16'h1000) && (address[15:12] == 4'h4);

////////////////////////////////////////////////////////////
// WRITE ROUTING
////////////////////////////////////////////////////////////

assign sram_write = write & sram_sel;
assign led_write  = write & led_sel;
assign hex_write  = write & hex_sel;
assign lcd_write  = write & lcd_sel;

////////////////////////////////////////////////////////////
// READ ROUTING
////////////////////////////////////////////////////////////

assign sram_read = read & sram_sel;
assign led_read  = read & led_sel;
assign hex_read  = read & hex_sel;
assign lcd_read  = read & lcd_sel;

////////////////////////////////////////////////////////////
// READ DATA MUX
////////////////////////////////////////////////////////////

always @(*) begin
    if(sram_sel)
        readdata = sram_readdata;
    else if(led_sel)
        readdata = led_readdata;
    else if(hex_sel)
        readdata = hex_readdata;
    else if(lcd_sel)
        readdata = lcd_readdata;
    else
        readdata = 32'h0;
end
endmodule