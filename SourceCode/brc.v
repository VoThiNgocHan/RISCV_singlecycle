module brc
(
    input  [31:0] i_rs1_data,
    input  [31:0] i_rs2_data,
    input         i_br_un,      // 1 = signed, 0 = unsigned

    output        o_br_less,
    output        o_br_equal
);

    wire less_u;
    wire eq_u;

    comp32 u_cmp32 (
        .A (i_rs1_data),
        .B (i_rs2_data),
        .EQ(eq_u),
        .LT(less_u)
    );

    assign o_br_equal = eq_u;

    reg less_s;

    always @(*) begin
        if (i_rs1_data[31] != i_rs2_data[31]) begin
            less_s = i_rs1_data[31];
        end else begin
            less_s = less_u;
        end
    end

    assign o_br_less = (i_br_un) ? less_u : less_s;

endmodule
