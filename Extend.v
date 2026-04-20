module Extend(
    input [31:7] instruction, 
    input [2:0]  ImmSrc,
    output reg [31:0] ImmExt
);

always @(*) begin
    case(ImmSrc)
        3'b000: 
            ImmExt = {{20{instruction[31]}}, instruction[31:20]};// I-type
        3'b001: 
            ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};// S-type
        3'b010: 
            ImmExt = {{19{instruction[31]}}, instruction[31], instruction[7],
                      instruction[30:25], instruction[11:8], 1'b0};// B-type
        3'b011:
            ImmExt = {instruction[31:12], 12'b0};// U-type
        3'b100:
            ImmExt = {{11{instruction[31]}}, instruction[31],
                      instruction[19:12], instruction[20],
                      instruction[30:21], 1'b0};// J-type
        default: ImmExt = 32'b0;
    endcase
end
endmodule
