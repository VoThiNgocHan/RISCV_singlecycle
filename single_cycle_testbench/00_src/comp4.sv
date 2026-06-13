module comp4 (
    input  logic [3:0] A,
    input  logic [3:0] B,
    output logic EQ,
    output logic LT
);

    logic Eh, El;
    logic Lh, Ll;

    comp2 upper (
        .A(A[3:2]), .B(B[3:2]),
        .EQ(Eh), .LT(Lh)
    );

    comp2 lower (
        .A(A[1:0]), .B(B[1:0]),
        .EQ(El), .LT(Ll)
    );

    assign EQ = Eh & El;
    assign LT = Lh | (Eh & Ll);

endmodule
