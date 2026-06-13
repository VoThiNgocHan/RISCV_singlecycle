module scoreboard(
  input           i_clk     ,
  input           i_reset   ,
  input   [31:0]  i_io_sw   ,
  input   [31:0]  o_io_ledr ,
  input   [31:0]  o_io_ledg ,
  input   [ 6:0]  o_io_hex0 ,
  input   [ 6:0]  o_io_hex1 ,
  input   [ 6:0]  o_io_hex2 ,
  input   [ 6:0]  o_io_hex3 ,
  input   [ 6:0]  o_io_hex4 ,
  input   [ 6:0]  o_io_hex5 ,
  input   [ 6:0]  o_io_hex6 ,
  input   [ 6:0]  o_io_hex7 ,
  input   [31:0]  o_io_lcd  ,
  input   [31:0]  o_pc_debug,
  input           o_insn_vld
);

// Display test name
initial begin
  $display("\nSINGLE CYCLE - ISA test\n");
end


always @(negedge i_clk) begin
  if (o_pc_debug == 32'h18) begin
      $write("%s", o_io_ledr[7:0]);
  end

  if (o_pc_debug == 32'h1c) begin
      $display("\nEND of ISA test\n");
      $finish;
  end
end
endmodule
