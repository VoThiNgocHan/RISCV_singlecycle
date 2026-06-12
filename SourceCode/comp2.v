module comp2 (
    input   [1:0] A,
    input   [1:0] B,
    output  EQ,
    output  LT
);

    wire Eh, El;
    wire Lh, Ll;

    comp1 u_msb (
        .A(A[1]), .B(B[1]),
        .E(Eh), .L(Lh)
    );

    comp1 u_lsb (
        .A(A[0]), .B(B[0]),
        .E(El), .L(Ll)
    );

    assign EQ = Eh & El;
    assign LT = Lh | (Eh & Ll);

endmodule

