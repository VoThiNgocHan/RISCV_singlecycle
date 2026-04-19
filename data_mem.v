module data_mem (
    input         i_clk,
    input         i_reset,
    input  [31:0] i_addr,
    input  [31:0] i_wdata,
    input  [3:0]  i_bmask,
    input         i_wren,
    input  [2:0]  i_control,

    output reg [31:0] o_rdata
);

  // 2KB memory = 2048 byte
  reg [7:0] memory [0:2047];

  // ===== LOAD TYPE =====
  parameter LB  = 3'b000;
  parameter LH  = 3'b001;
  parameter LW  = 3'b010;
  parameter LBU = 3'b100;
  parameter LHU = 3'b101;

  // ===== ALIGN ADDRESS =====
  reg [11:0] addr_aligned;

  always @(*) begin
    case (i_control)
      LH, LHU: addr_aligned = {i_addr[11:1], 1'b0};
      LW:      addr_aligned = {i_addr[11:2], 2'b00};
      default: addr_aligned = i_addr[11:0];
    endcase
  end

  // ===== VALID ADDRESS =====
  wire addr_valid;
  assign addr_valid = (i_addr[31:16] == 16'h0000) &&
                      (addr_aligned <= 12'd2044);

  // ===== READ =====
  always @(*) begin
    if (!addr_valid) begin
      o_rdata = 32'b0;
    end else begin
      case (i_control)
        LB:
          o_rdata = {{24{memory[addr_aligned][7]}}, memory[addr_aligned]};

        LH:
          o_rdata = {{16{memory[addr_aligned + 1][7]}},
                     memory[addr_aligned + 1],
                     memory[addr_aligned]};

        LW:
          o_rdata = {memory[addr_aligned + 3],
                     memory[addr_aligned + 2],
                     memory[addr_aligned + 1],
                     memory[addr_aligned]};

        LBU:
          o_rdata = {24'b0, memory[i_addr[11:0]]};

        LHU:
          o_rdata = {16'b0,
                     memory[addr_aligned + 1],
                     memory[addr_aligned]};

        default:
          o_rdata = 32'b0;
      endcase
    end
  end

  // ===== WRITE =====
  integer i;

  always @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      for (i = 0; i < 2048; i = i + 1) begin
        memory[i] <= 8'h00;
      end
    end else if (i_wren && addr_valid) begin
      if (i_bmask[0]) memory[addr_aligned    ] <= i_wdata[7:0];
      if (i_bmask[1]) memory[addr_aligned + 1] <= i_wdata[15:8];
      if (i_bmask[2]) memory[addr_aligned + 2] <= i_wdata[23:16];
      if (i_bmask[3]) memory[addr_aligned + 3] <= i_wdata[31:24];
    end
  end

endmodule

