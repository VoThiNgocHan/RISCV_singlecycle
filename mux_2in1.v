module mux_2in1 #(
    parameter WIDTH = 32
)(
    input i_sel,
    input [WIDTH-1:0] i_in0,
    input [WIDTH-1:0] i_in1,
    output [WIDTH-0:0] o_out
);  
assign o_out = (i_sel)? i_in1: i_in0;
endmodule
