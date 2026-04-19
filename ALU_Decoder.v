module ALU_decoder (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    input [1:0] ALUop,
    output reg [3:0] ALU_control
);
    localparam ADD  = 4'b0000,
               SUB  = 4'b0001,
               SLL  = 4'b0010,
               SLT  = 4'b0011,
               SLTU = 4'b0100,
               XOR  = 4'b0101,
               SRL  = 4'b0110,
               SRA  = 4'b0111,
               OR   = 4'b1000,
               AND  = 4'b1001;

always @(*) begin
    case (ALUop)
        2'b00: ALU_control = ADD;
        2'b01: ALU_control = SUB;
        2'b10: begin
            case(funct3)
                3'b000: begin
                    if (funct7 == 7'b0100000)
                        ALU_control = SUB;
                    else
                        ALU_control = ADD;
                end
                3'b001: ALU_control = SLL;
                3'b010: ALU_control = SLT;
                3'b011: ALU_control = SLTU;
                3'b100: ALU_control = XOR;
                3'b101: begin
                    if(funct7 == 7'b0100000)
                        ALU_control = SRA;
                    else ALU_control = SRL;
                end
                3'b110: ALU_control = OR;
                3'b111: ALU_control = AND;
                default: ALU_control = ADD; 
            endcase
        end
        default: ALU_control = ADD;
    endcase
end

endmodule