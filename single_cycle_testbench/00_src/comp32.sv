module comp32 (
    input  logic [31:0] A,
    input  logic [31:0] B,
    output logic EQ,
    output logic LT
);

    logic Eh, El;
    logic Lh, Ll;

    // MSB 31:16
    comp16 upper (
        .A(A[31:16]), .B(B[31:16]),
        .EQ(Eh), .LT(Lh)
    );

    // LSB 15:0
    comp16 lower (
        .A(A[15:0]), .B(B[15:0]),
        .EQ(El), .LT(Ll)
    );

    assign EQ = Eh & El;          // A == B
    assign LT = Lh | (Eh & Ll);   // A < B

endmodule
