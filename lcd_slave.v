module lcd_slave(
    input         clk,
    input         reset,
    input  [31:0] address,
    input  [31:0] writedata,
    input         write,
    input         read,
    input  [3:0]  byteenable,
    output reg [31:0] readdata,
    output [7:0] lcd0,
    output [7:0] lcd1,
    output [7:0] lcd2,
    output [7:0] lcd3,
    output [7:0] lcd4
);

reg [7:0] lcd_mem [0:31];
integer i;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        for(i=0; i<32; i=i+1)
            lcd_mem[i] <= 8'h00;
    end
    else if(write) begin
        if(byteenable[0])
            lcd_mem[address[4:0]] <= writedata[7:0];
        if(byteenable[1])
            lcd_mem[address[4:0] + 1] <= writedata[15:8];
        if(byteenable[2])
            lcd_mem[address[4:0] + 2] <= writedata[23:16];
        if(byteenable[3])
            lcd_mem[address[4:0] + 3] <= writedata[31:24];
    end
end

always @(*) begin
    if(read) begin
        readdata = {
            lcd_mem[address[4:0] + 3],
            lcd_mem[address[4:0] + 2],
            lcd_mem[address[4:0] + 1],
            lcd_mem[address[4:0]]
        };
    end
    else begin
        readdata = 32'h00000000;
    end
end

assign lcd0 = lcd_mem[0];
assign lcd1 = lcd_mem[1];
assign lcd2 = lcd_mem[2];
assign lcd3 = lcd_mem[3];
assign lcd4 = lcd_mem[4];

endmodule