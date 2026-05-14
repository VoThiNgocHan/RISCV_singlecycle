module lsu (
    input logic         i_clk,
    input logic         i_reset,
    input logic  [31:0] i_lsu_addr,
    input logic  [31:0] i_st_data,
    input logic         i_lsu_wren,
    input logic  [31:0] i_io_sw,
    input logic  [2:0]  i_control,
    //output logic  [3:0]  o_bmask,

    output logic [31:0] o_ld_data,
    output logic [31:0] o_io_ledr,
    output logic [31:0] o_io_ledg,
    output logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
    output logic [31:0] o_io_lcd
  );

  logic [31:0] in_buf_data, out_buf_data, data_mem;

  //mux load data
  always_comb
  begin
    if      (i_lsu_addr[31:16] == 16'h1001)
      o_ld_data = in_buf_data;
    else if (i_lsu_addr[31:16] == 16'h1000)
      o_ld_data = out_buf_data;
    else if (i_lsu_addr[31:16] == 16'h0000)
      o_ld_data = data_mem;
    else
      o_ld_data = 32'h0;
  end

  //xu ly bmask
  logic [3:0] byte_mask;
  // Khối generate byte mask từ addr và funct3
  // Addr dùng bit [1:0] để xác định byte offset
  always_comb
  begin
    if (i_lsu_wren)
    begin
      case (i_control)
        3'b000:  // SB
          byte_mask = 4'b0001 << i_lsu_addr[1:0];
        3'b001:  // SH
          byte_mask = i_lsu_addr[1] ? 4'b1100 : 4'b0011;
        3'b010: // SW
          byte_mask = 4'b1111;
        default:
          byte_mask = 4'b0000; // default no write
      endcase
    end
  end

  input_buffer i_buffer_memory(
                 .i_control(i_control),
                 .i_in_buf_addr(i_lsu_addr),
                 .i_io_sw(i_io_sw),
                 .o_in_buf_data(in_buf_data)
               );


  output_buffer o_buffer_memory(
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

  data_mem data_memory (
             .i_clk(i_clk),
             .i_reset(i_reset),
             .i_addr(i_lsu_addr),
             .i_wdata(i_st_data),
             .i_bmask(byte_mask),
             .i_wren(i_lsu_wren),
             .i_control(i_control),
             .o_rdata(data_mem)
           );

endmodule


