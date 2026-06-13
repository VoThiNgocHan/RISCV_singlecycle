module comp1 (
    input  logic A,
    input  logic B,
    output logic E,   // Equal
    output logic L    // Less
);
    assign E = ~(A ^ B);     
    assign L = (~A) & B;     // A < B
endmodule
