module memory
(
    input         i_clk,
    input         i_reset,
    input         i_wren,
    input  [8:0]  i_addr,
    input  [31:0] i_wdata,
    input  [3:0]  i_bmask,
    output [31:0] o_rdata
);

    reg [7:0] mem0 [0:511];
    reg [7:0] mem1 [0:511];
    reg [7:0] mem2 [0:511];
    reg [7:0] mem3 [0:511];

    integer i;

    assign o_rdata = {mem3[i_addr], mem2[i_addr], mem1[i_addr], mem0[i_addr]};

    always @(posedge i_clk) begin
        if (i_reset) begin
            for (i = 0; i < 512; i = i + 1) begin
                mem0[i] <= 8'b0;
                mem1[i] <= 8'b0;
                mem2[i] <= 8'b0;
                mem3[i] <= 8'b0;
            end
        end
        else begin
            if (i_wren) begin
                if (i_bmask[0])
                    mem0[i_addr] <= i_wdata[7:0];

                if (i_bmask[1])
                    mem1[i_addr] <= i_wdata[15:8];

                if (i_bmask[2])
                    mem2[i_addr] <= i_wdata[23:16];

                if (i_bmask[3])
                    mem3[i_addr] <= i_wdata[31:24];
            end
        end
    end

endmodule