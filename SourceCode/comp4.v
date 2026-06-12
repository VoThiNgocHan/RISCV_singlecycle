module comp4 (
    input   [3:0] A,
    input   [3:0] B,
    output  EQ,
    output  LT
);

    wire Eh, El;
    wire Lh, Ll;

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

