module comp8 (
    input   [7:0] A,
    input   [7:0] B,
    output  EQ,
    output  LT
);

    wire Eh, El;
    wire Lh, Ll;

    comp4 upper (
        .A(A[7:4]), .B(B[7:4]),
        .EQ(Eh), .LT(Lh)
    );

    comp4 lower (
        .A(A[3:0]), .B(B[3:0]),
        .EQ(El), .LT(Ll)
    );

    assign EQ = Eh & El;
    assign LT = Lh | (Eh & Ll);

endmodule

