module comp8 (
    input  logic [7:0] A,
    input  logic [7:0] B,
    output logic EQ,
    output logic LT
);

    logic Eh, El;
    logic Lh, Ll;

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
