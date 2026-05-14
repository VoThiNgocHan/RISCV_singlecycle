module led_slave(
    input         clk,
    input         reset,
    input  [31:0] address,
    input  [31:0] writedata,
    input         write,
    input         read,
    input  [3:0]  byteenable,
    output reg [31:0] readdata,
    output [31:0] ledr
);
    reg [31:0] led_reg;
    always @(posedge clk or posedge reset) begin
        if(reset) led_reg <= 32'h0;
        else 
            if (write) begin
                if(byteenable[0])
                    led_reg[7:0] <= writedata[7:0];
                if(byteenable[1])
                    led_reg[15:8] <= writedata[15:8];
                if(byteenable[2])
                    led_reg[23:16] <= writedata[23:16];
                if(byteenable[3])
                    led_reg[31:24] <= writedata[31:24];
            end
    end
    always @(*) begin
        if(read) readdata = led_reg;
        else readdata = 32'h0;
    end
    assign ledr = led_reg;
endmodule
