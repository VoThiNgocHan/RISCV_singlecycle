module mux3to1(
  input   [31:0] i_a, i_b, i_c,
  input   [1:0]  i_sel,
  output reg [31:0] o_y
);
  always @(*) begin
    case(i_sel)
	   2'b00  : o_y = i_a  ;
		2'b01  : o_y = i_b  ;
		2'b10  : o_y = i_c  ;
		default: o_y = 32'b0;
	 endcase
  end
endmodule

