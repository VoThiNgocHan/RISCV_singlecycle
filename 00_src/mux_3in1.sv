module mux_3in1(
    input  logic [31:0] i_in0,
    input  logic [31:0] i_in1,
    input  logic [31:0] i_in2,
    input  logic [1:0]  i_sel,
    output logic [31:0] o_out
);
always_comb begin
    case(i_sel) 
        2'b00: o_out = i_in0;
        2'b01: o_out = i_in1;
        2'b10: o_out = i_in2;
        default: o_out = i_in1;
    endcase
end
endmodule
