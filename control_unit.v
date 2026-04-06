module control_unit {
    input [31:0] instr,
    input br_less,
    input br_equal,

    output reg pc_sel,
    output reg rd_wren,
    output reg insn_vld,
    output reg br_un,
    output reg opa_sel, opb_sel,
    output reg [3:0] alu_op, 
    output reg mem_wren,
    output reg [1:0] wb_sel
};
wire [6:0] opcode = instr[6:0];
wire [2:0] funct3 = instr[14:12];
wire [6:0] funct7 = instr[31:25];

always @(*) begin
    pc_sel = 1'b0;
    rd_wren = 1'b0;
    insn_vld = 1'b0;
    br_un = 1'b0;
    opa_sel = 1'b0;
    opb_sel = 1'b0;
    alu_op = 4'b0;
    mem_wren = 1'b0;
    wb_sel = 2'b01;

    case (opcode)
///////////////////////////////R-type///////////////////////////
        7'b0110011: begin
            rd_wren = 1'b1;
            opa_sel = 1'b1;
            opa_sel = 1'b0;
            wb_sel = 2'b01;

            case ({funct7, funct3})
                10'b0000000_000: alu_op = 4'b0000; //add
                10'b0100000_000: alu_op = 4'b0001; //sub
                10'b0000000_010: alu_op = 4'b0010; //sll
                10'b0000000_011: alu_op = 4'b0011; //slt
                10'b0000000_100: alu_op = 4'b0100; //sltu
                10'b0000000_110: alu_op = 4'b0101; //xor
                10'b0000000_111: alu_op = 4'b0110; //srl
                10'b0000000_001: alu_op = 4'b0111; //sra
                10'b0000000_101: alu_op = 4'b1000; //or
                10'b0100000_101: alu_op = 4'b1001; //and
            endcase
        end
///////////////////////////////I-type//////////////////////////////
        7'0010011: begin
            rd_wren = 1'b1;
            opa_sel = 1'b1;
            opb_sel = 1'b1;
            wb_sel = 2'b01;

            case(funct3)
                3'b000: alu_op = 4'b0000; //addi
                3'b010: alu_op = 4'b0010; //slti
                3'b011: alu_op = 4'b0011; //sltiu
                3'b100: alu_op = 4'b0100; //xori
                3'b110: alu_op = 4'b0110; //ori
                3'b111: alu_op = 4'b0111; //andi
                3'b001: begin
                    if(funct7 == 0000000)
                        alu_op = 4'b0111; //slli
                end
                3'b101: begin
                    if(funct7 == 7'0000000)
                        alu_op = 4'b1000; //srli
                    else if(funct7 == 7'b0100000)
                        alu_op = 4'b1001; //srai
                end
            endcase
        end
    endcase
end
endmodule
