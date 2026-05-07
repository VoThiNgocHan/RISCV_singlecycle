module output_buffer (
    input         i_clk,
    input         i_reset,
    input  [2:0]  i_control,
    input  [31:0] i_out_buf_addr,
    input  [31:0] i_out_buf_data,
    input         i_wren,
    input  [3:0]  i_bmask,

    output reg [31:0] o_out_buf_data,
    output [31:0] o_io_ledr,
    output [31:0] o_io_ledg,
    output [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3,
                  o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
    output [31:0] o_io_lcd
);

// funct3
localparam LB  = 3'b000,
           LH  = 3'b001,
           LW  = 3'b010,
           LBU = 3'b100,
           LHU = 3'b101;

// address map
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

// bộ nhớ buffer
reg [7:0] out_buffer_reg [0:16383];

wire reg_buffer_sel;
assign reg_buffer_sel = (i_out_buf_addr[31:16] == 16'h1000);

// WRITE
always @(posedge i_clk or posedge i_reset) begin
    if (i_reset) begin
        out_buffer_reg[red_leds]     <= 8'h0;
        out_buffer_reg[red_leds + 1] <= 8'h0;
        out_buffer_reg[red_leds + 2] <= 8'h0;
        out_buffer_reg[red_leds + 3] <= 8'h0;
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
    else if (reg_buffer_sel && i_wren && i_out_buf_addr[15:0] <= end_addr) begin
        if (i_bmask[0])
            out_buffer_reg[i_out_buf_addr[15:0]]     <= i_out_buf_data[7:0];
        if (i_bmask[1])
            out_buffer_reg[i_out_buf_addr[15:0] + 1] <= i_out_buf_data[15:8];
        if (i_bmask[2])
            out_buffer_reg[i_out_buf_addr[15:0] + 2] <= i_out_buf_data[23:16];
        if (i_bmask[3])
            out_buffer_reg[i_out_buf_addr[15:0] + 3] <= i_out_buf_data[31:24];
    end
end

// READ
reg [7:0] b0, b1, b2, b3;

always @(*) begin
    b0 = out_buffer_reg[i_out_buf_addr[15:0]];
    b1 = out_buffer_reg[i_out_buf_addr[15:0] + 1];
    b2 = out_buffer_reg[i_out_buf_addr[15:0] + 2];
    b3 = out_buffer_reg[i_out_buf_addr[15:0] + 3];

    case(i_control)
        LB:  o_out_buf_data = {{24{b0[7]}}, b0};
        LH:  o_out_buf_data = {{16{b1[7]}}, b1, b0};
        LW:  o_out_buf_data = {b3, b2, b1, b0};
        LBU: o_out_buf_data = {24'h0, b0};
        LHU: o_out_buf_data = {16'h0, b1, b0};
        default: o_out_buf_data = 32'h0;
    endcase
end

// OUTPUT mapping
assign o_io_ledr = {out_buffer_reg[red_leds+3], out_buffer_reg[red_leds+2],
                    out_buffer_reg[red_leds+1], out_buffer_reg[red_leds]};

assign o_io_ledg = {24'h0, out_buffer_reg[green_leds]};

assign o_io_hex0 = out_buffer_reg[hex_0][6:0];
assign o_io_hex1 = out_buffer_reg[hex_1][6:0];
assign o_io_hex2 = out_buffer_reg[hex_2][6:0];
assign o_io_hex3 = out_buffer_reg[hex_3][6:0];
assign o_io_hex4 = out_buffer_reg[hex_4][6:0];
assign o_io_hex5 = out_buffer_reg[hex_5][6:0];
assign o_io_hex6 = out_buffer_reg[hex_6][6:0];
assign o_io_hex7 = out_buffer_reg[hex_7][6:0];

assign o_io_lcd  = {out_buffer_reg[lcd+3], out_buffer_reg[lcd+2],
                    out_buffer_reg[lcd+1], out_buffer_reg[lcd]};

endmodule

