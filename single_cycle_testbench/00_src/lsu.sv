module lsu
(
    input  logic        i_clk,
    input  logic        i_reset,
    input  logic [31:0] i_lsu_addr,
    input  logic [31:0] i_st_data,
    input  logic        i_lsu_wren,
    input  logic [31:0] i_io_sw,
    input  logic [2:0]  i_funct3,

    output logic [31:0] o_ld_data,
    output logic [31:0] o_io_ledr,
    output logic [31:0] o_io_ledg,

    output logic [6:0]  o_io_hex0,
    output logic [6:0]  o_io_hex1,
    output logic [6:0]  o_io_hex2,
    output logic [6:0]  o_io_hex3,
    output logic [6:0]  o_io_hex4,
    output logic [6:0]  o_io_hex5,
    output logic [6:0]  o_io_hex6,
    output logic [6:0]  o_io_hex7,

    output logic [31:0] o_io_lcd
);

    // IO buffers
    logic [31:0] output_buffer_ledr;
    logic [31:0] output_buffer_ledg;
    logic [31:0] output_buffer_seven_seg1;
    logic [31:0] output_buffer_seven_seg2;
    logic [31:0] output_buffer_lcd;
    logic [31:0] input_buffer;

    assign o_io_ledr = output_buffer_ledr;
    assign o_io_ledg = output_buffer_ledg;

    assign o_io_hex0 = output_buffer_seven_seg1[6:0];
    assign o_io_hex1 = output_buffer_seven_seg1[14:8];
    assign o_io_hex2 = output_buffer_seven_seg1[22:16];
    assign o_io_hex3 = output_buffer_seven_seg1[30:24];

    assign o_io_hex4 = output_buffer_seven_seg2[6:0];
    assign o_io_hex5 = output_buffer_seven_seg2[14:8];
    assign o_io_hex6 = output_buffer_seven_seg2[22:16];
    assign o_io_hex7 = output_buffer_seven_seg2[30:24];

    assign o_io_lcd    = output_buffer_lcd;
    assign input_buffer = i_io_sw;

    // Address decode
    logic mem, led_r, led_g, seven_seg1, seven_seg2, lcd, switch;

    assign mem        = (i_lsu_addr[31:12] == 20'h00000);
    assign led_r      = (i_lsu_addr[31:12] == 20'h10000);
    assign led_g      = (i_lsu_addr[31:12] == 20'h10001);
    assign seven_seg1 = (i_lsu_addr[31:12] == 20'h10002); // HEX0–3
    assign seven_seg2 = (i_lsu_addr[31:12] == 20'h10003); // HEX4–7
    assign lcd        = (i_lsu_addr[31:12] == 20'h10004);
    assign switch     = (i_lsu_addr[31:12] == 20'h10010);

    logic [6:0] select;
    assign select = {mem, led_r, led_g, seven_seg1, seven_seg2, lcd, switch};
	 
    logic [31:0] read_data;
    logic [3:0]  bmask;
    logic [31:0] data_write;

    memory u_memory
    (
        .i_clk     (i_clk),
        .i_reset   (i_reset),
        .i_addr    (i_lsu_addr[10:2]),
        .i_wdata   (data_write),
        .i_bmask   (bmask),
        .i_wren    (i_lsu_wren),
        .o_rdata   (read_data)
    );

    // LOAD
    always_comb begin
        unique case (select)
            7'b1000000: begin
                // MEM
                unique case (i_funct3)
                    3'b010: o_ld_data = read_data; // LW

                    3'b000: begin // LB
                        unique case (i_lsu_addr[1:0])
                            2'b00: o_ld_data = {{24{read_data[7]}},  read_data[7:0]};
                            2'b01: o_ld_data = {{24{read_data[15]}}, read_data[15:8]};
                            2'b10: o_ld_data = {{24{read_data[23]}}, read_data[23:16]};
                            2'b11: o_ld_data = {{24{read_data[31]}}, read_data[31:24]};
                        endcase
                    end

                    3'b100: begin // LBU
                        unique case (i_lsu_addr[1:0])
                            2'b00: o_ld_data = {24'd0, read_data[7:0]};
                            2'b01: o_ld_data = {24'd0, read_data[15:8]};
                            2'b10: o_ld_data = {24'd0, read_data[23:16]};
                            2'b11: o_ld_data = {24'd0, read_data[31:24]};
                        endcase
                    end

                    3'b001: begin // LH
                        if (i_lsu_addr[1] == 1'b0)
                            o_ld_data = {{16{read_data[15]}}, read_data[15:0]};
                        else
                            o_ld_data = {{16{read_data[31]}}, read_data[31:16]};
                    end

                    3'b101: begin // LHU
                        if (i_lsu_addr[1] == 1'b0)
                            o_ld_data = {16'd0, read_data[15:0]};
                        else
                            o_ld_data = {16'd0, read_data[31:16]};
                    end

                    default: o_ld_data = read_data;
                endcase
            end

            7'b0100000: o_ld_data = output_buffer_ledr;
            7'b0010000: o_ld_data = output_buffer_ledg;
            7'b0001000: o_ld_data = output_buffer_seven_seg1;
            7'b0000100: o_ld_data = output_buffer_seven_seg2;
            7'b0000010: o_ld_data = output_buffer_lcd;
            7'b0000001: o_ld_data = input_buffer;

            default:    o_ld_data = 32'd0;
        endcase
    end

    // STORE
    logic [1:0] byte_off;
    assign byte_off = i_lsu_addr[1:0];

    always_comb begin
        bmask = 4'b0000;

        if (i_lsu_wren & mem) begin
            unique case (i_funct3)
                // SB
                3'b000: begin
                    unique case (byte_off)
                        2'b00: bmask = 4'b0001;
                        2'b01: bmask = 4'b0010;
                        2'b10: bmask = 4'b0100;
                        2'b11: bmask = 4'b1000;
                    endcase
                end

                // SH
                3'b001: begin
                    if (byte_off[1] == 1'b0)
                        bmask = 4'b0011;
                    else
                        bmask = 4'b1100;
                end

                // SW
                3'b010: bmask = 4'b1111;

                default: bmask = 4'b0000;
            endcase
        end
    end

    always_comb begin
        data_write = 32'd0;

        if (i_lsu_wren & mem) begin
            unique case (i_funct3)

                // SB
                3'b000: begin
                    unique case (byte_off)
                        2'b00: data_write = {24'd0, i_st_data[7:0]};
                        2'b01: data_write = {16'd0, i_st_data[7:0], 8'd0};
                        2'b10: data_write = { 8'd0, i_st_data[7:0], 16'd0};
                        2'b11: data_write = {i_st_data[7:0], 24'd0};
                    endcase
                end

                // SH
                3'b001: begin
                    if (byte_off[1] == 1'b0)
                        data_write = {16'd0, i_st_data[15:0]};
                    else
                        data_write = {       i_st_data[15:0], 16'd0};
                end

                // SW
                3'b010: data_write = i_st_data;

                default: data_write = 32'd0;
            endcase
        end
    end

    always_ff @(posedge i_clk or posedge i_reset) begin
        if (i_reset) begin
            output_buffer_ledr       <= 32'd0;
            output_buffer_ledg       <= 32'd0;
            output_buffer_seven_seg1 <= 32'd0;
            output_buffer_seven_seg2 <= 32'd0;
            output_buffer_lcd        <= 32'd0;
        end
        else begin
		    if (i_lsu_wren) begin
            if (led_r) begin
                output_buffer_ledr <= i_st_data;
            end
				else if (led_g) begin
                output_buffer_ledg <= i_st_data;
				end
            else if (seven_seg1) begin
                output_buffer_seven_seg1 <= i_st_data;
				end
            else if (seven_seg2) begin
                output_buffer_seven_seg2 <= i_st_data;
				end
            else if (lcd) begin
                output_buffer_lcd <= i_st_data;
				end
        end
    end
	 end
endmodule
