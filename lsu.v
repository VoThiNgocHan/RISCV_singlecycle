module lsu (
    input          i_clk,
    input          i_reset,
    input   [31:0] i_lsu_addr,
    input   [31:0] i_st_data,
    input          i_lsu_wren,
    input   [31:0] i_io_sw,
    input   [2:0]  i_control,

    output  reg [31:0] o_ld_data,
    output      [31:0] o_io_ledr,
    output      [31:0] o_io_ledg,
    output      [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3,
                      o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
    output      [31:0] o_io_lcd
);

  // ================= INTERNAL SIGNALS =================
  wire [31:0] in_buf_data;
  wire [31:0] out_buf_data;
  wire [31:0] data_mem_out;

  reg  [3:0]  byte_mask;

  // ================= LOAD DATA MUX =================
  always @(*) begin
    if      (i_lsu_addr[31:16] == 16'h1001)
      o_ld_data = in_buf_data;
    else if (i_lsu_addr[31:16] == 16'h1000)
      o_ld_data = out_buf_data;
    else if (i_lsu_addr[31:16] == 16'h0000)
      o_ld_data = data_mem_out;
    else
      o_ld_data = 32'h0;
  end

  // ================= BYTE MASK =================
  always @(*) begin
    if (i_lsu_wren) begin
      case (i_control)
        3'b000:  byte_mask = 4'b0001 << i_lsu_addr[1:0];       // SB
        3'b001:  byte_mask = i_lsu_addr[1] ? 4'b1100 : 4'b0011; // SH
        3'b010:  byte_mask = 4'b1111;                          // SW
        default: byte_mask = 4'b0000;
      endcase
    end else begin
      byte_mask = 4'b0000;
    end
  end

  // ================= INPUT BUFFER =================
  input_buffer i_buffer_memory (
    .i_control(i_control),
    .i_in_buf_addr(i_lsu_addr),
    .i_io_sw(i_io_sw),
    .o_in_buf_data(in_buf_data)
  );

  // ================= OUTPUT BUFFER =================
  output_buffer o_buffer_memory (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_bmask(byte_mask),
    .i_control(i_control),
    .i_out_buf_addr(i_lsu_addr),
    .i_out_buf_data(i_st_data),
    .i_wren(i_lsu_wren),
    .o_out_buf_data(out_buf_data),
    .o_io_ledr(o_io_ledr),
    .o_io_ledg(o_io_ledg),
    .o_io_hex0(o_io_hex0),
    .o_io_hex1(o_io_hex1),
    .o_io_hex2(o_io_hex2),
    .o_io_hex3(o_io_hex3),
    .o_io_hex4(o_io_hex4),
    .o_io_hex5(o_io_hex5),
    .o_io_hex6(o_io_hex6),
    .o_io_hex7(o_io_hex7),
    .o_io_lcd(o_io_lcd)
  );

  // ================= DATA MEMORY =================
  data_mem data_memory (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_addr(i_lsu_addr),
    .i_wdata(i_st_data),
    .i_bmask(byte_mask),
    .i_wren(i_lsu_wren),
    .i_control(i_control),
    .o_rdata(data_mem_out)
  );

endmodule
