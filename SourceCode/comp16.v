module comp16 (
    input   [15:0] A,
    input   [15:0] B,
    output  EQ,
    output  LT
);

    wire Eh, El;
    wire Lh, Ll;

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

