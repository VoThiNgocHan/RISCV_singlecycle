module comp16 (
    input  logic [15:0] A,
    input  logic [15:0] B,
    output logic EQ,
    output logic LT
);

    logic Eh, El;
    logic Lh, Ll;

    // MSB 15:8
    comp8 upper (
        .A(A[15:8]), .B(B[15:8]),
        .EQ(Eh), .LT(Lh)
    );

    // LSB 7:0
    comp8 lower (
        .A(A[7:0]), .B(B[7:0]),
        .EQ(El), .LT(Ll)
    );

    assign EQ = Eh & El;
    assign LT = Lh | (Eh & Ll);

endmodule
