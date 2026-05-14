module mux_2in1(
    input  logic [31:0] i_in0,
    input  logic [31:0] i_in1,
    input  logic        i_sel,
    output logic [31:0] o_out
);
 assign o_out = i_sel ? i_in1 : i_in0;

endmodule