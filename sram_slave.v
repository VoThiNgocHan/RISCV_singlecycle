module sram_slave(
    input         clk,
    input         reset,
    input  [31:0] address,
    input  [31:0] writedata,
    input         write,
    input         read,
    input  [3:0]  byteenable,
    output reg [31:0] readdata
);
    reg [7:0] mem [0:4095];
////////////////////////write logic//////////////////////////
    always @(posedge clk) begin
        if(write) begin
            if(byteenable[0])
                mem[address] <= writedata[7:0];
                
            if(byteenable[1])
                mem[address+1] <= writedata[15:8];

            if(byteenable[2])
                mem[address+2] <= writedata[23:16];

            if(byteenable[3])
                mem[address+3] <= writedata[31:24];
        end
    end
////////////////////////////read logic///////////////////////////
    always @(*) begin
        if(read)
            readdata =
            {
                mem[address+3],
                mem[address+2],
                mem[address+1],
                mem[address]
            };
        else
            readdata = 32'h0;
    end
endmodule
