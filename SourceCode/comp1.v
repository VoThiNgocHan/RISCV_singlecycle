module comp1 (
    input   A,
    input   B,
    output  E,   // Equal
    output  L    // Less
);
    assign E = ~(A ^ B);     
    assign L = (~A) & B;     // A < B
endmodule

