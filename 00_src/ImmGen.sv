module ImmGen(
    input  logic [31:0] instr,    // Lệnh đầu vào
    output logic [31:0] o_immgen   // Giá trị immediate đầu ra
);

localparam  
	I_TYPE = 5'b00100,
        I_LOAD = 5'b00000,
	JALR   = 5'b11001,
	STORE  = 5'b01000,
	BRANCH = 5'b11000,
	LUI    = 5'b01101,
	AUIPC  = 5'b00101,
	JAL    = 5'b11011;

    always_comb begin
        case (instr[6:2])
            I_TYPE : // I-type (ALU immediate instructions)
                o_immgen = {{20{instr[31]}}, instr[31:20]};
            
            I_LOAD: // I-load (Load instructions)
                o_immgen = {{20{instr[31]}}, instr[31:20]};
            
            JALR: // I-type (JALR instruction)
                o_immgen = {{20{instr[31]}}, instr[31:20]};
            
            STORE: // S-type
                o_immgen = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            
            BRANCH: // B-type
                o_immgen = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            
            LUI: // U-type - LUI
                o_immgen = {instr[31:12], 12'b0};
            
            AUIPC : // AUIPCAUIPC
                o_immgen = {instr[31:12], 12'b0};

            JAL: // J-type
                o_immgen = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            
            default:
               o_immgen = 32'b0; // Mặc định giá trị là 0 nếu không khớp opcode nào
        endcase
    end
endmodule


