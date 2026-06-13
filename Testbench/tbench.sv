`define RESET_PERIOD 100 //reset giữ trong 100 đơn vị tg
`define CLK_PERIOD   2 //clock đổi trang thái mỗi 2 đv tg
`define FINISH       40_000 //sau 40000 dvtg thì kết thúc

module tbench;

// Clock and reset generator
logic i_clk;
logic i_reset;

initial tsk_clock_gen(i_clk, `CLK_PERIOD); //
initial tsk_reset(i_reset, `RESET_PERIOD); // Active Low Reset
initial tsk_timeout(`FINISH);

// // Wave dumping
// initial begin: proc_dump_shm
//     $shm_open("wave.shm");
//     $shm_probe(dut, "AS");
// end

// TASK: Clock Generator
task automatic tsk_clock_gen(ref logic i_clk, input int CLK_PERIOD);
  begin
    i_clk = 1'b1;
    forever #(CLK_PERIOD) i_clk = !i_clk;
  end
endtask

// TASK: Reset is low active for a period of "RESETPERIOD"
task automatic tsk_reset(ref logic i_reset, input int RESET_PERIOD);
  begin
    i_reset = 1'b0;
    #(RESET_PERIOD) i_reset = 1'b1;
  end
endtask

// TASK: Timeout, assume after a period of "FINISH",
// the design is supposed to be "PASSED"
task automatic tsk_timeout(input int FINISH);
  begin
    #FINISH $display("\nTimeout...\n\n");
            $finish;
  end
endtask

logic [31:0]  i_io_sw  ;
logic [31:0]  o_io_ledr;
logic [31:0]  o_io_ledg;
logic [31:0]  o_io_lcd ;
logic [ 6:0]  o_io_hex0;
logic [ 6:0]  o_io_hex1;
logic [ 6:0]  o_io_hex2;
logic [ 6:0]  o_io_hex3;
logic [ 6:0]  o_io_hex4;
logic [ 6:0]  o_io_hex5;
logic [ 6:0]  o_io_hex6;
logic [ 6:0]  o_io_hex7;
logic [31:0]  o_pc_debug;
logic         o_insn_vld;

singlecycle dut (
    .i_clk       (i_clk     ) ,
    .i_reset     (i_reset   ) ,
    .i_io_sw     (i_io_sw   ) ,
    .o_io_ledr   (o_io_ledr ) ,
    .o_io_ledg   (o_io_ledg ) ,
    .o_io_lcd    (o_io_lcd  ) ,
    .o_io_hex0   (o_io_hex0 ) ,
    .o_io_hex1   (o_io_hex1 ) ,
    .o_io_hex2   (o_io_hex2 ) ,
    .o_io_hex3   (o_io_hex3 ) ,
    .o_io_hex4   (o_io_hex4 ) ,
    .o_io_hex5   (o_io_hex5 ) ,
    .o_io_hex6   (o_io_hex6 ) ,
    .o_io_hex7   (o_io_hex7 ) ,
    .o_pc_debug  (o_pc_debug) ,
    .o_insn_vld  (o_insn_vld)
);

scoreboard scoreboard ( //khối ktr kết quả
    .i_clk       (i_clk     ) ,
    .i_reset     (i_reset   ) ,
    .i_io_sw     (i_io_sw   ) ,
    .o_io_ledr   (o_io_ledr ) ,
    .o_io_ledg   (o_io_ledg ) ,
    .o_io_lcd    (o_io_lcd  ) ,
    .o_io_hex0   (o_io_hex0 ) ,
    .o_io_hex1   (o_io_hex1 ) ,
    .o_io_hex2   (o_io_hex2 ) ,
    .o_io_hex3   (o_io_hex3 ) ,
    .o_io_hex4   (o_io_hex4 ) ,
    .o_io_hex5   (o_io_hex5 ) ,
    .o_io_hex6   (o_io_hex6 ) ,
    .o_io_hex7   (o_io_hex7 ) ,
    .o_pc_debug  (o_pc_debug) ,
    .o_insn_vld  (o_insn_vld)
);

driver driver(
  .i_clk    (i_clk  ),
  .i_reset  (i_reset),
  .o_sw_data(i_io_sw)
);

endmodule : tbench
