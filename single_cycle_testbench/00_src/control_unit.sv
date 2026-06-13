module control_unit (
    input  logic [31:0] i_inst,
    input  logic        i_br_less, 
    input  logic        i_br_equal,

    output logic        o_inst_vld,
    output logic        o_rd_wren,
    output logic        o_br_un,
    output logic        o_lsu_wren,
    output logic        o_pc_sel,
    output logic        o_opa_sel,
    output logic        o_opb_sel,
    output logic [1:0]  o_wb_sel,
    output logic [3:0]  o_alu_op
);

  logic [6:0] opcode;
  logic [2:0] funct3;
  logic       funct7;
  //logic [1:0] alu_dec;

  assign opcode = i_inst[6:0];
  assign funct3 = i_inst[14:12];
  assign funct7 = i_inst[30];

  always_comb begin
    case (opcode)
      7'b0110011: begin // R-type
        o_pc_sel   = 1'b0;
        o_rd_wren  = 1'b1;
        o_br_un    = 1'b0;
        o_opa_sel  = 1'b0;
        o_opb_sel  = 1'b0;
        alu_dec    = 2'b01;
        o_lsu_wren = 1'b0;
        o_wb_sel   = 2'b01;
        o_inst_vld = 1'b1;
      end

      7'b0010011: begin // I-type
        o_pc_sel   = 1'b0;
        o_rd_wren  = 1'b1;
        o_br_un    = 1'b0;
        o_opa_sel  = 1'b0;
        o_opb_sel  = 1'b1;
        alu_dec    = 2'b01;
        o_lsu_wren = 1'b0;
        o_wb_sel   = 2'b01;
        o_inst_vld = 1'b1;
      end

      7'b0000011: begin // Load
        o_pc_sel   = 1'b0;
        o_rd_wren  = 1'b1;
        o_br_un    = 1'b0;
        o_opa_sel  = 1'b0;
        o_opb_sel  = 1'b1;
        alu_dec    = 2'b00;
        o_lsu_wren = 1'b0;
        o_wb_sel   = 2'b00;
        o_inst_vld = 1'b1;
      end

      7'b0100011: begin // Store
        o_pc_sel   = 1'b0;
        o_rd_wren  = 1'b0;
        o_br_un    = 1'b0;
        o_opa_sel  = 1'b0;
        o_opb_sel  = 1'b1;
        alu_dec    = 2'b00;
        o_lsu_wren = 1'b1;
        o_wb_sel   = 2'b01;
        o_inst_vld = 1'b1;
      end

      7'b1100011: begin // Branch
        case (funct3)
          3'b000: begin // BEQ
            o_br_un    = 1'b0;
            o_pc_sel   = (i_br_equal) ? 1'b1 : 1'b0;
            o_inst_vld = 1'b1;
          end
          3'b001: begin // BNE
            o_br_un    = 1'b0;
            o_pc_sel   = (~i_br_equal) ? 1'b1 : 1'b0;
            o_inst_vld = 1'b1;
          end
          3'b100: begin // BLT
            o_br_un    = 1'b0;
            o_pc_sel   = (i_br_less) ? 1'b1 : 1'b0;
            o_inst_vld = 1'b1;
          end
          3'b101: begin // BGE
            o_br_un    = 1'b0;
            o_pc_sel   = (~i_br_less) ? 1'b1 : 1'b0;
            o_inst_vld = 1'b1;
          end
          3'b110: begin // BLTU
            o_br_un    = 1'b1;
            o_pc_sel   = (i_br_less) ? 1'b1 : 1'b0;
            o_inst_vld = 1'b1;
          end
          3'b111: begin // BGEU
            o_br_un    = 1'b1;
            o_pc_sel   = (~i_br_less) ? 1'b1 : 1'b0;
            o_inst_vld = 1'b1;
          end
          default: begin
            o_br_un    = 1'b0;
            o_pc_sel   = 1'b0;
            o_inst_vld = 1'b0;
          end
        endcase
        o_rd_wren  = 1'b0;
        o_opa_sel  = 1'b1;
        o_opb_sel  = 1'b1;
        alu_dec    = 2'b00;
        o_lsu_wren = 1'b0;
        o_wb_sel   = 2'b01;
      end

      7'b1101111: begin // JAL
        o_pc_sel   = 1'b1;
        o_rd_wren  = 1'b1;
        o_br_un    = 1'b0;
        o_opa_sel  = 1'b1;
        o_opb_sel  = 1'b1;
        alu_dec    = 2'b00;
        o_lsu_wren = 1'b0;
        o_wb_sel   = 2'b10;
        o_inst_vld = 1'b1;
      end

      7'b0110111: begin // LUI
        o_pc_sel   = 1'b0;
        o_rd_wren  = 1'b1;
        o_br_un    = 1'b0;
        o_opa_sel  = 1'b0;
        o_opb_sel  = 1'b1;
        alu_dec    = 2'b10;
        o_lsu_wren = 1'b0;
        o_wb_sel   = 2'b01;
        o_inst_vld = 1'b1;
      end

      7'b0010111: begin // AUIPC
        o_pc_sel   = 1'b0;
        o_rd_wren  = 1'b1;
        o_br_un    = 1'b0;
        o_opa_sel  = 1'b1;
        o_opb_sel  = 1'b1;
        alu_dec    = 2'b00;
        o_lsu_wren = 1'b0;
        o_wb_sel   = 2'b01;
        o_inst_vld = 1'b1;
      end

      7'b1100111: begin // JALR
        o_pc_sel   = 1'b1;
        o_rd_wren  = 1'b1;
        o_br_un    = 1'b0;
        o_opa_sel  = 1'b0;
        o_opb_sel  = 1'b1;
        alu_dec    = 2'b00;
        o_lsu_wren = 1'b0;
        o_wb_sel   = 2'b10;
        o_inst_vld = 1'b1;
      end

      default: begin
        o_pc_sel   = 1'b0;
        o_rd_wren  = 1'b0;
        o_br_un    = 1'b0;
        o_opa_sel  = 1'b0;
        o_opb_sel  = 1'b0;
        alu_dec    = 2'b00;
        o_lsu_wren = 1'b0;
        o_wb_sel   = 2'b01;
        o_inst_vld = 1'b0;
      end
    endcase
  end
  
  logic [1:0] alu_dec;
  
  always_comb begin
    case (alu_dec)
      2'b00: o_alu_op = 4'b0000; // ADD
      2'b01: begin
        case (funct3)
          3'b000: o_alu_op = ((funct7 == 1'b1) && (i_inst[5] == 1'b1)) ? 4'b0001 : 4'b0000; // ADD/SUB
          3'b001: o_alu_op = 4'b0010; // SLL
          3'b010: o_alu_op = 4'b0011; // SLT
          3'b011: o_alu_op = 4'b0100; // SLTU
          3'b100: o_alu_op = 4'b0101; // XOR
          3'b101: o_alu_op = (funct7 == 1'b0) ? 4'b0110 : 4'b0111; // SRL/SRA
          3'b110: o_alu_op = 4'b1000; // OR
          3'b111: o_alu_op = 4'b1001; // AND
          default: o_alu_op = 4'b0000;
        endcase
      end
      2'b10: o_alu_op = 4'b1010; // LUI
      default: o_alu_op = 4'b0000;
    endcase
  end

endmodule
