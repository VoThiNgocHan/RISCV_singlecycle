module control_unit (
    input [31:0] i_inst,
    input i_br_less,
    input i_br_equal,

    output reg o_pc_sel,
    output reg o_rd_wren,
    output reg o_insn_vld,
    output reg o_br_un,
    output reg o_opa_sel, o_opb_sel,
    output reg [3:0] o_alu_op, 
    output reg o_mem_wren,
    output reg [1:0] o_wb_sel,
    output reg [2:0] o_ImmSrc,
    output reg o_is_jalr
);

wire [6:0] opcode;
assign opcode = i_inst[6:0];

wire [2:0] funct3;
assign funct3 = i_inst[14:12];

wire [6:0] funct7;
assign funct7 = i_inst[31:25];

always @(*) begin
    o_pc_sel = 1'b0;
    o_rd_wren = 1'b0;
    o_insn_vld = 1'b1;
    o_br_un = 1'b0;
    o_opa_sel = 1'b0;
    o_opb_sel = 1'b0;
    o_alu_op = 4'b0;
    o_mem_wren = 1'b0;
    o_wb_sel = 2'b01;
    o_ImmSrc = 3'b000;
    o_is_jalr = 1'b0;

    case (opcode)

        7'b0010011, 7'b0000011, 7'b1100111:
            o_ImmSrc = 3'b000;

        7'b0100011:
            o_ImmSrc = 3'b001;

        7'b1100011:
            o_ImmSrc = 3'b010;

        7'b0110111, 7'b0010111:
            o_ImmSrc = 3'b011;

        7'b1101111:
            o_ImmSrc = 3'b100;

    endcase

    case (opcode)

//////////////// R-type //////////////////
        7'b0110011: begin
            o_rd_wren = 1'b1;

            case ({funct7, funct3})
                10'b0000000_000: o_alu_op = 4'b0000;
                10'b0100000_000: o_alu_op = 4'b0001;
                10'b0000000_001: o_alu_op = 4'b0010;
                10'b0000000_010: o_alu_op = 4'b0011;
                10'b0000000_011: o_alu_op = 4'b0100;
                10'b0000000_100: o_alu_op = 4'b0101;
                10'b0000000_101: o_alu_op = 4'b0110;
                10'b0100000_101: o_alu_op = 4'b0111;
                10'b0000000_110: o_alu_op = 4'b1000;
                10'b0000000_111: o_alu_op = 4'b1001;
                default: o_alu_op = 4'b0000;
            endcase
        end

//////////////// I-type //////////////////
        7'b0010011: begin
            o_rd_wren = 1'b1;
            o_opb_sel = 1'b1;

            case(funct3)
                3'b000: o_alu_op = 4'b0000;
                3'b010: o_alu_op = 4'b0011;
                3'b011: o_alu_op = 4'b0100;
                3'b100: o_alu_op = 4'b0101;
                3'b110: o_alu_op = 4'b1000;
                3'b111: o_alu_op = 4'b1001;
                3'b001: o_alu_op = 4'b0010;
                3'b101: o_alu_op = (funct7 == 7'b0100000) ? 4'b0111 : 4'b0110;
                default: o_alu_op = 4'b0000;
            endcase
        end

//////////////// LOAD //////////////////
        7'b0000011: begin
            o_rd_wren = 1'b1;
            o_opb_sel = 1'b1;
            o_wb_sel = 2'b10;
        end

//////////////// STORE //////////////////
        7'b0100011: begin
            o_mem_wren = 1'b1;
            o_opb_sel = 1'b1;
        end

//////////////// BRANCH //////////////////
        7'b1100011: begin
            case(funct3)
                3'b000: o_pc_sel = i_br_equal;
                3'b001: o_pc_sel = ~i_br_equal;
                3'b100: o_pc_sel = i_br_less;
                3'b101: o_pc_sel = ~i_br_less;
                3'b110: begin o_pc_sel = i_br_less; o_br_un = 1'b1; end
                3'b111: begin o_pc_sel = ~i_br_less; o_br_un = 1'b1; end
            endcase
        end

//////////////// JAL //////////////////
        7'b1101111: begin
            o_rd_wren = 1'b1;
            o_pc_sel = 1'b1;
            o_opa_sel = 1'b1;
            o_opb_sel = 1'b1;
            o_wb_sel = 2'b00;
        end

//////////////// JALR //////////////////
        7'b1100111: begin
            o_rd_wren = 1'b1;
            o_pc_sel = 1'b1;
            o_opb_sel = 1'b1;
            o_wb_sel = 2'b00;
            o_is_jalr = 1'b1;
        end

//////////////// LUI //////////////////
        7'b0110111: begin
            o_rd_wren = 1'b1;
            o_opb_sel = 1'b1;
        end

//////////////// AUIPC //////////////////
        7'b0010111: begin
            o_rd_wren = 1'b1;
            o_opa_sel = 1'b1;
            o_opb_sel = 1'b1;
        end

//////////////// DEFAULT //////////////////
        default: o_insn_vld = 1'b0;

    endcase
end

endmodule