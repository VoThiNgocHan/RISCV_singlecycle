module input_buffer (
    input  [2:0]   i_control,
    input  [31:0]  i_in_buf_addr,
    input  [31:0]  i_io_sw,
    output reg [31:0] o_in_buf_data
);

// Address range
localparam SW_BASE_ADRR = 32'h10010000;
localparam SW_TOP_ADDR  = 32'h10010FFF;

// funct3
localparam LB  = 3'b000,
           LH  = 3'b001,
           LW  = 3'b010,
           LBU = 3'b100,
           LHU = 3'b101;

reg [1:0] byte_offset;
wire [31:0] sw_data;

assign sw_data = i_io_sw;

// tách byte
wire [7:0] temp0, temp1, temp2, temp3;

assign temp0 = sw_data[7:0];
assign temp1 = sw_data[15:8];
assign temp2 = sw_data[23:16];
assign temp3 = sw_data[31:24];

always @(*) begin
    if ((i_in_buf_addr >= SW_BASE_ADRR) && (i_in_buf_addr <= SW_TOP_ADDR)) begin
        byte_offset = i_in_buf_addr[1:0];

        case (i_control)
            LB:
                case(byte_offset)
                    2'b00: o_in_buf_data = {{24{temp0[7]}}, temp0};
                    2'b01: o_in_buf_data = {{24{temp1[7]}}, temp1};
                    2'b10: o_in_buf_data = {{24{temp2[7]}}, temp2};
                    2'b11: o_in_buf_data = {{24{temp3[7]}}, temp3};
                endcase

            LH:
                case(byte_offset)
                    2'b00: o_in_buf_data = {{16{temp1[7]}}, temp1, temp0};
                    2'b01: o_in_buf_data = {{16{temp2[7]}}, temp2, temp1};
                    2'b10: o_in_buf_data = {{16{temp3[7]}}, temp3, temp2};
                    default: o_in_buf_data = 32'b0;
                endcase

            LW:
                if (byte_offset == 2'b00)
                    o_in_buf_data = {temp3, temp2, temp1, temp0};
                else
                    o_in_buf_data = 32'b0;

            LBU:
                case(byte_offset)
                    2'b00: o_in_buf_data = {24'b0, temp0};
                    2'b01: o_in_buf_data = {24'b0, temp1};
                    2'b10: o_in_buf_data = {24'b0, temp2};
                    2'b11: o_in_buf_data = {24'b0, temp3};
                endcase

            LHU:
                case(byte_offset)
                    2'b00: o_in_buf_data = {16'b0, temp1, temp0};
                    2'b01: o_in_buf_data = {16'b0, temp2, temp1};
                    2'b10: o_in_buf_data = {16'b0, temp3, temp2};
                    default: o_in_buf_data = 32'b0;
                endcase

            default:
                o_in_buf_data = 32'b0;
        endcase
    end else begin
        o_in_buf_data = 32'b0;
    end
end

endmodule

