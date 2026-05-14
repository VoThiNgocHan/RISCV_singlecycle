module hex_slave(
    input         clk,
    input         reset,
    input  [31:0] address,
    input  [31:0] writedata,
    input         write,
    input         read,
    input  [3:0]  byteenable,
    output reg [31:0] readdata,
    output [6:0] ohex0,
    output [6:0] ohex1,
    output [6:0] ohex2,
    output [6:0] ohex3
);
reg [6:0] hex0;
reg [6:0] hex1;
reg [6:0] hex2;
reg [6:0] hex3;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        hex0 <= 7'h00;
        hex1 <= 7'h00;
        hex2 <= 7'h00;
        hex3 <= 7'h00;
    end
    else if(write) begin
        case(address[3:0])
            4'h0:
                if(byteenable[0])
                    hex0 <= writedata[6:0];
            4'h1:
                if(byteenable[0])
                    hex1 <= writedata[6:0];
            4'h2:
                if(byteenable[0])
                    hex2 <= writedata[6:0];
            4'h3:
                if(byteenable[0])
                    hex3 <= writedata[6:0];
        endcase
    end
end
always @(*) begin
    if(read) begin
        case(address[3:0])
            4'h0:
                readdata = {25'h0, hex0};
            4'h1:
                readdata = {25'h0, hex1};
            4'h2:
                readdata = {25'h0, hex2};
            4'h3:
                readdata = {25'h0, hex3};
            default:
                readdata = 32'h0;
        endcase
    end
    else begin
        readdata = 32'h0;
    end
end

assign ohex0 = hex0;
assign ohex1 = hex1;
assign ohex2 = hex2;
assign ohex3 = hex3;

endmodule