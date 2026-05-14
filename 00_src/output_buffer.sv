module output_buffer (
    input logic         i_clk,
    input logic         i_reset,
    input logic [2:0]   i_control,      //funct3
    input logic [31:0]  i_out_buf_addr, //dia chi CPU doc xong dua vao LSU
    input logic [31:0]  i_out_buf_data, //du lieu ghi vao
    input logic         i_wren,         //tin hieu cho phep ghi
    input logic [3:0]   i_bmask,

    output logic [31:0] o_out_buf_data, //du lieu doc
    output logic [31:0] o_io_ledr, o_io_ledg,
    output logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
    output logic [31:0] o_io_lcd
  );

  //func3
  localparam LB  = 3'b000,
             LH  = 3'b001,
             LW  = 3'b010,
             LBU = 3'b100,
             LHU = 3'b101;

  //addr cua ngoai vi
  localparam red_leds    = 16'h0000,
             green_leds  = 16'h1000,
             hex_0       = 16'h2000,
             hex_1       = 16'h2001,
             hex_2       = 16'h2002,
             hex_3       = 16'h2003,
             hex_4       = 16'h3000,
             hex_5       = 16'h3001,
             hex_6       = 16'h3002,
             hex_7       = 16'h3003,
             lcd         = 16'h4000,
             end_addr    = 16'h4FFF;

  //thanh ghi noi bo
  logic [7:0] out_buffer_reg [0:16383]; //chi luu 16 bit thap cua du lieu

  //chon thanh ghi
  logic  reg_buffer_sel;
  assign reg_buffer_sel = (i_out_buf_addr[31:16] == 16'h1000);

  //xu li du lieu
  always_ff @(posedge i_clk or negedge i_reset)
  begin
    if (~i_reset)
    begin
      out_buffer_reg[red_leds    ] <= 8'h0;
      out_buffer_reg[red_leds + 1] <= 8'h0;
      out_buffer_reg[red_leds + 2] <= 8'h0;
      out_buffer_reg[red_leds +3 ] <= 8'h0;
      out_buffer_reg[green_leds]   <= 8'h0;
      out_buffer_reg[hex_0]        <= 8'h0;
      out_buffer_reg[hex_1]        <= 8'h0;
      out_buffer_reg[hex_2]        <= 8'h0;
      out_buffer_reg[hex_3]        <= 8'h0;
      out_buffer_reg[hex_4]        <= 8'h0;
      out_buffer_reg[hex_5]        <= 8'h0;
      out_buffer_reg[hex_6]        <= 8'h0;
      out_buffer_reg[hex_7]        <= 8'h0;
      out_buffer_reg[lcd]          <= 8'h0;
      out_buffer_reg[lcd + 1]      <= 8'h0;
      out_buffer_reg[lcd + 2]      <= 8'h0;
      out_buffer_reg[lcd + 3]      <= 8'h0;
    end


    //ghi du lieu
    /*    else if (reg_buffer_sel && i_wren) begin
            case (i_control[1:0])
     
                2'b00: //SB
                if(i_out_buf_addr[15:0] <= end_addr) begin
                    out_buffer_reg[i_out_buf_addr[15:0]] <= i_out_buf_data[7:0];
                end
                
                2'b01: //SH
                if(i_out_buf_addr[15:0]+1 <= end_addr) begin
                    out_buffer_reg[i_out_buf_addr[15:0]]   <= i_out_buf_data[7:0];
                    out_buffer_reg[i_out_buf_addr[15:0]+1] <= i_out_buf_data[15:8];
                end
                
                2'b10: //SW
                if(i_out_buf_addr[15:0] + 3 <= end_addr) begin
                    out_buffer_reg[i_out_buf_addr[15:0]]   <= i_out_buf_data[7:0];
                    out_buffer_reg[i_out_buf_addr[15:0]+1] <= i_out_buf_data[15:8];
                    out_buffer_reg[i_out_buf_addr[15:0]+2] <= i_out_buf_data[23:16];
                    out_buffer_reg[i_out_buf_addr[15:0]+3] <= i_out_buf_data[31:24];
                end
     
            endcase
        end
    */


    else if (reg_buffer_sel && i_wren && i_out_buf_addr[15:0] <= end_addr)
    begin
      if (i_bmask[0])
        out_buffer_reg[i_out_buf_addr[15:0]    ] <= i_out_buf_data[ 7:0];
      if (i_bmask[1])
        out_buffer_reg[i_out_buf_addr[15:0] + 1] <= i_out_buf_data[15:8];
      if (i_bmask[2])
        out_buffer_reg[i_out_buf_addr[15:0] + 2] <= i_out_buf_data[23:16];
      if (i_bmask[3])
        out_buffer_reg[i_out_buf_addr[15:0] + 3] <= i_out_buf_data[31:24];
    end

  end

  //bien tam de phan du lieu theo byte (8bit)
  logic [7:0] reg_temp [3:0];

  always_comb
  begin
    reg_temp[0] = (i_out_buf_addr[15:0]  <= end_addr) ? out_buffer_reg[i_out_buf_addr[15:0]] : 8'h0;

    reg_temp[1] = (i_out_buf_addr[15:0] + 1 <= end_addr) ? out_buffer_reg[i_out_buf_addr[15:0]+1] : 8'h0;

    reg_temp[2] = (i_out_buf_addr[15:0] + 2 <= end_addr) ? out_buffer_reg[i_out_buf_addr[15:0]+2] : 8'h0;

    reg_temp[3] = (i_out_buf_addr[15:0] + 3 <= end_addr) ? out_buffer_reg[i_out_buf_addr[15:0]+3] : 8'h0;
  end

  always_comb
  begin
    case(i_control)
      //k dung reg_temp[0] o LB, LBU vi tiet kiem tai nguyen, ton them 1 phep gan
      LB:
        o_out_buf_data = (i_out_buf_addr[15:0] <= end_addr) ? {{24{out_buffer_reg[i_out_buf_addr[15:0]][7]}},out_buffer_reg[i_out_buf_addr[15:0]]} : 32'h0;
      LH:
        o_out_buf_data = (i_out_buf_addr[15:0] + 1 <= end_addr) ? {{16{reg_temp[1][7]}}, reg_temp[1], reg_temp[0]} : 32'h0;
      LW:
        o_out_buf_data = (i_out_buf_addr[15:0] + 3 <= end_addr) ? {reg_temp[3], reg_temp[2], reg_temp[1], reg_temp[0]} : 32'h0;
      LBU:
        o_out_buf_data = (i_out_buf_addr[15:0] <= end_addr) ? {24'h0, out_buffer_reg[i_out_buf_addr[15:0]]} : 32'h0;
      LHU:
        o_out_buf_data = (i_out_buf_addr[15:0] + 1 <= end_addr) ? {16'h0, reg_temp[1], reg_temp[0]} : 32'h0;
      default:
        o_out_buf_data = 32'h0;
    endcase
  end

  assign o_io_ledr = {out_buffer_reg[red_leds+3], out_buffer_reg[red_leds+2], out_buffer_reg[red_leds+1], out_buffer_reg[red_leds]};
  assign o_io_ledg = {24'h0, out_buffer_reg[green_leds]};
  assign o_io_hex0 = out_buffer_reg[hex_0][6:0];
  assign o_io_hex1 = out_buffer_reg[hex_1][6:0];
  assign o_io_hex2 = out_buffer_reg[hex_2][6:0];
  assign o_io_hex3 = out_buffer_reg[hex_3][6:0];
  assign o_io_hex4 = out_buffer_reg[hex_4][6:0];
  assign o_io_hex5 = out_buffer_reg[hex_5][6:0];
  assign o_io_hex6 = out_buffer_reg[hex_6][6:0];
  assign o_io_hex7 = out_buffer_reg[hex_7][6:0];
  assign o_io_lcd  = {out_buffer_reg[lcd+3], out_buffer_reg[lcd+2], out_buffer_reg[lcd+1], out_buffer_reg[lcd]};


endmodule
