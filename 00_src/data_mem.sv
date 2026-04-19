module data_mem (
    input  logic        i_clk,
    input  logic        i_reset,
    input  logic [31:0] i_addr,      // Địa chỉ đọc/ghi
    input  logic [31:0] i_wdata,     // Dữ liệu cần ghi
    input  logic [3:0]  i_bmask,     // Byte mask
    input  logic        i_wren,      // Enable ghi
    input  logic [2:0]  i_control,   // funct3 (opcode của load/store)

    output logic [31:0] o_rdata      // Output data sau khi load
);

  // Bộ nhớ 2KB = 2048 byte
  logic [31:0] memory [0:2047];

  // Các loại lệnh load
  localparam LB  = 3'b000;
  localparam LH  = 3'b001;
  localparam LW  = 3'b010;
  localparam LBU = 3'b100;
  localparam LHU = 3'b101;

  // Địa chỉ căn chỉnh tùy loại access
  logic [11:0] addr_aligned;
  always_comb begin
    case (i_control)
      LH, LHU: addr_aligned = {i_addr[11:1], 1'b0};       // căn theo halfword
      LW:      addr_aligned = {i_addr[11:2], 2'b00};      // căn theo word
      default: addr_aligned = i_addr[11:0];               // byte access giữ nguyên
    endcase
  end

  // Kiểm tra địa chỉ hợp lệ trong khoảng 2KB (0x0000_0000 đến 0x0000_07FF)
  logic addr_valid;
  assign addr_valid = i_addr[31:16] == 16'h0000 && addr_aligned <= 12'd2044;

  // Đọc dữ liệu không đồng bộ
  always_comb begin
    if (!addr_valid) begin
      o_rdata = 32'b0;
    end else begin
      case (i_control)
        //LB:  o_rdata = {{24{memory[i_addr[11:0]][7]}}, memory[i_addr[11:0]]};
        LB:  o_rdata = {{24{memory[addr_aligned][7]}}, memory[addr_aligned]};
        //LH:  o_rdata = {{16{memory[{i_addr[11:1],1'b0} + 1][7]}}, memory[{i_addr[11:1],1'b0} + 1], memory[{i_addr[11:1],1'b0}]};
        LH:  o_rdata = {{16{memory[addr_aligned + 1][7]}}, memory[addr_aligned + 1], memory[addr_aligned]};
  
        LW:  o_rdata = {memory[addr_aligned + 3], memory[addr_aligned + 2],
                        memory[addr_aligned + 1], memory[addr_aligned]};
        LBU: o_rdata = {24'b0, memory[i_addr[11:0]]};
        //LHU: o_rdata = {16'b0, memory[{i_addr[11:1],1'b0} + 1], memory[{i_addr[11:1],1'b0}]};
        LHU: o_rdata = {16'b0, memory[addr_aligned + 1], memory[addr_aligned]};
        default: o_rdata = 32'b0;
      endcase
    end
  end

  // Ghi dữ liệu đồng bộ
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      for (int i = 0; i < 2048; i++) begin
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

