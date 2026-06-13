module control_unit (
    input  [31:0] i_inst,
    input         i_br_less,
    input         i_br_equal,

    output reg        o_inst_vld,
    output reg        o_rd_wren,
    output reg        o_br_un,
    output reg        o_lsu_wren,
    output reg        o_pc_sel,
    output reg        o_opa_sel,
    output reg        o_opb_sel,
    output reg [1:0]  o_wb_sel,
    output reg [3:0]  o_alu_op
);

  wire [6:0] opcode;
  wire [2:0] funct3;
  wire       funct7;

  reg [1:0] alu_dec;

  assign opcode = i_inst[6:0];
  assign funct3 = i_inst[14:12];
  assign funct7 = i_inst[30];

  always @(*) begin
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
          3'b000: begin
            o_br_un    = 1'b0;
            o_pc_sel   = (i_br_equal) ? 1'b1 : 1'b0;
            o_inst_vld = 1'b1;
          end

          3'b001: begin
            o_br_un    = 1'b0;
            o_pc_sel   = (~i_br_equal) ? 1'b1 : 1'b0;
            o_inst_vld = 1'b1;
          end

          3'b100: begin
            o_br_un    = 1'b0;
            o_pc_sel   = (i_br_less) ? 1'b1 : 1'b0;
            o_inst_vld = 1'b1;
          end

          3'b101: begin
            o_br_un    = 1'b0;
            o_pc_sel   = (~i_br_less) ? 1'b1 : 1'b0;
            o_inst_vld = 1'b1;
          end

          3'b110: begin
            o_br_un    = 1'b1;
            o_pc_sel   = (i_br_less) ? 1'b1 : 1'b0;
            o_inst_vld = 1'b1;
          end

          3'b111: begin
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

  always @(*) begin
    case (alu_dec)
      2'b00: o_alu_op = 4'b0000;

      2'b01: begin
        case (funct3)
          3'b000: o_alu_op = ((funct7 == 1'b1) && (i_inst[5] == 1'b1)) ? 4'b0001 : 4'b0000;
          3'b001: o_alu_op = 4'b0010;
          3'b010: o_alu_op = 4'b0011;
          3'b011: o_alu_op = 4'b0100;
          3'b100: o_alu_op = 4'b0101;
          3'b101: o_alu_op = (funct7 == 1'b0) ? 4'b0110 : 4'b0111;
          3'b110: o_alu_op = 4'b1000;
          3'b111: o_alu_op = 4'b1001;
          default: o_alu_op = 4'b0000;
        endcase
      end

      2'b10: o_alu_op = 4'b1010;

      default: o_alu_op = 4'b0000;
    endcase
  end

endmodule
