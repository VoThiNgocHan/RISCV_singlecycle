`timescale 1ns/1ps

module testbench;

  // Clock and reset
  logic i_clk = 0;
  logic i_reset;

  // Inputs
  logic [31:0] i_io_sw = 32'h0;

  // Outputs
  logic [31:0] o_pc_debug;
  logic        o_insn_vld;
  logic [31:0] o_io_ledr;
  logic [31:0] o_io_ledg;
  logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3;
  logic [6:0]  o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7;
  logic [31:0] o_io_lcd;

  // Clock generation: 10ns period (100MHz)
  always #5 i_clk = ~i_clk;

  // Reset logic
  initial begin
    i_reset = 1;
    #20;
    i_reset = 0;
  end

  // DUT instantiation
  singlecycle dut (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_io_sw(i_io_sw),
    .o_pc_debug(o_pc_debug),
    .o_insn_vld(o_insn_vld),
    .o_io_ledr(o_io_ledr),
    .o_io_ledg(o_io_ledg),
    .o_io_hex0(o_io_hex0),
    .o_io_hex1(o_io_hex1),
    .o_io_hex2(o_io_hex2),
    .o_io_hex3(o_io_hex3),
    .o_io_hex4(o_io_hex4),
    .o_io_hex5(o_io_hex5),
    .o_io_hex6(o_io_hex6),
    .o_io_hex7(o_io_hex7),
    .o_io_lcd(o_io_lcd)
  );

  // Optional: Display useful debug information every cycle
  always @(posedge i_clk) begin
    if (o_insn_vld)
      $display("[Time %0t] PC: %h | LEDR: %h | HEX0: %b | LCD: %h",
               $time, o_pc_debug, o_io_ledr, o_io_hex0, o_io_lcd);
  end


  initial begin
    $display("Loading ISA_mem...");
    // internal IMEM in singlecycle should do this
    //$readmemh("D:/NLS_Intern/risc_v/mem.dump", dut.i_imem.i_mem);

  end


  // Timeout
  initial begin
    #100000; // 100us sim time
    $display("Timeout: Testbench finished.");
    $finish;
  end

endmodule

