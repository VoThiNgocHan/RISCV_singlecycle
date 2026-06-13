//tạo dữ liệu đàu vào
module driver (
  input          i_clk    ,
  input          i_reset  ,
  output reg [31:0] o_sw_data
);
initial begin
 o_sw_data = 32'h12345678;
end
endmodule
