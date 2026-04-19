module ALU_control(
    input [6:0] opcode,
    output reg [1:0] ALUop
); 
    always @(*) begin
        case (opcode)
            7'b0110011: ALUop = 2'b10;
            7'b0010011: ALUop = 2'b10;
            7'b0000011: ALUop = 2'b00; //add
            7'b0100011: ALUop = 2'b00; //add
            7'b1100011: ALUop = 2'b01; //sub
            default: ALUop = 2'b00;
        endcase
    end
endmodule
