module adder_8bit(
  input  [7:0] a, b,
  input  cin,
  output [7:0] sum,
  output cout
);
  wire c;

  adder_4bit low (
    .a(a[3:0]),
    .b(b[3:0]),
    .cin(cin),
    .sum(sum[3:0]),
    .cout(c)
  );

  adder_4bit high (
    .a(a[7:4]),
    .b(b[7:4]),
    .cin(c),
    .sum(sum[7:4]),
    .cout(cout)
  );

endmodule

