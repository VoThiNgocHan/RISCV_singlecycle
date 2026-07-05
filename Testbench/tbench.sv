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


////////////////////////////////////////////////////////////////////////////////

// `timescale 1ns/1ps

// `define CLK_PERIOD  2
// `define FINISH      1000

// module tb_singlecycle_mmio;

//     reg         i_clk;
//     reg         i_reset;
//     reg  [31:0] i_io_sw;

//     wire [31:0] o_io_ledr;
//     wire [31:0] o_io_ledg;
//     wire [31:0] o_io_lcd;

//     wire [6:0] o_io_hex0;
//     wire [6:0] o_io_hex1;
//     wire [6:0] o_io_hex2;
//     wire [6:0] o_io_hex3;
//     wire [6:0] o_io_hex4;
//     wire [6:0] o_io_hex5;
//     wire [6:0] o_io_hex6;
//     wire [6:0] o_io_hex7;

//     wire [31:0] o_pc_debug;
//     wire        o_insn_vld;

//     integer test_pass;


//     // ============================================================
//     // DUT
//     // ============================================================

//     singlecycle dut (
//         .i_clk       (i_clk),
//         .i_reset     (i_reset),
//         .i_io_sw     (i_io_sw),

//         .o_io_ledr   (o_io_ledr),
//         .o_io_ledg   (o_io_ledg),
//         .o_io_lcd    (o_io_lcd),

//         .o_io_hex0   (o_io_hex0),
//         .o_io_hex1   (o_io_hex1),
//         .o_io_hex2   (o_io_hex2),
//         .o_io_hex3   (o_io_hex3),
//         .o_io_hex4   (o_io_hex4),
//         .o_io_hex5   (o_io_hex5),
//         .o_io_hex6   (o_io_hex6),
//         .o_io_hex7   (o_io_hex7),

//         .o_pc_debug  (o_pc_debug),
//         .o_insn_vld  (o_insn_vld)
//     );


//     // ============================================================
//     // CLOCK GENERATOR
//     // ============================================================

//     initial begin
//         i_clk = 1'b0;

//         forever begin
//             #(`CLK_PERIOD);
//             i_clk = ~i_clk;
//         end
//     end


//     // ============================================================
//     // INITIALIZATION + RESET
//     // ============================================================

//     initial begin

//         test_pass = 0;

//         // Dữ liệu đầu vào giả lập từ Switch
//         i_io_sw = 32'h1234_5678;

//         // Active-low reset
//         i_reset = 1'b0;

//         // Giữ reset trong 10 chu kỳ clock
//         repeat (10) @(negedge i_clk);

//         // Nhả reset tại cạnh xuống
//         // PC vẫn còn bằng 0 tại thời điểm này
//         i_reset = 1'b1;

//         #1;

//         // ========================================================
//         // STEP 1
//         // ========================================================

//         $display("");
//         $display("============================================================");
//         $display("       RISC-V SINGLE-CYCLE MMIO INTEGRATION TEST");
//         $display("============================================================");
//         $display("------------------------------------------------------------");
//         $display("Switch input = 0x%h", i_io_sw);
//         $display("============================================================");

//         $display("");
//         $display("[CPU TRACE] PC=%08h | INSTR=%08h | VALID=%b",
//                  o_pc_debug, dut.instr, o_insn_vld);

//         $display("");
//         $display("[STEP 1] FETCH / DECODE");
//         $display("PC          : 0x%h", o_pc_debug);
//         $display("Instruction : 0x%h", dut.instr);
//         $display("Assembly    : LUI x1, 0x10010");
//         $display("Expected    : x1 = 0x10010000");
//         $display("Purpose     : Load SWITCH address");

//         // Kiểm tra PC
//         if (o_pc_debug !== 32'h0000_0000) begin

//             $display("[FAIL] Incorrect PC at STEP 1");
//             $display("Expected PC : 0x00000000");
//             $display("Actual PC   : 0x%h", o_pc_debug);

//             $finish;
//         end

//         // Kiểm tra instruction
//         if (dut.instr !== 32'h1001_00B7) begin

//             $display("[FAIL] Incorrect instruction at STEP 1");
//             $display("Expected : 0x100100B7");
//             $display("Actual   : 0x%h", dut.instr);

//             $finish;
//         end

//         // Kiểm tra Control Unit nhận dạng lệnh hợp lệ
//         if (o_insn_vld !== 1'b1) begin

//             $display("[FAIL] LUI instruction is not valid");

//             $finish;
//         end

//         $display("[PASS] Instruction fetched and decoded correctly");

//     end


//     // ============================================================
//     // CPU EXECUTION CHECK
//     // ============================================================

//     always @(negedge i_clk) begin

//         if (i_reset) begin

//             // Không xử lý PC = 0 ở đây vì STEP 1 đã kiểm tra
//             // ngay sau khi reset được nhả

//             case (o_pc_debug)


//                 // =================================================
//                 // STEP 2
//                 // LW x2, 0(x1)
//                 // =================================================

//                 32'h0000_0004: begin

//                     $display("");
//                     $display("[CPU TRACE] PC=%08h | INSTR=%08h | VALID=%b",
//                              o_pc_debug, dut.instr, o_insn_vld);

//                     $display("");
//                     $display("[STEP 2] LOAD FROM MMIO");
//                     $display("Instruction : LW x2, 0(x1)");
//                     $display("rs1_data    : 0x%h", dut.rs1_data);
//                     $display("ALU address : 0x%h", dut.alu_data);
//                     $display("Switch data : 0x%h", i_io_sw);
//                     $display("LSU output  : 0x%h", dut.ld_data);


//                     // Kiểm tra instruction
//                     if (dut.instr !== 32'h0000_A103) begin

//                         $display("[FAIL] Incorrect instruction at STEP 2");
//                         $display("Expected : 0x0000A103");
//                         $display("Actual   : 0x%h", dut.instr);

//                         $finish;
//                     end


//                     // Kết quả LUI trước đó phải nằm trong x1
//                     if (dut.rs1_data !== 32'h1001_0000) begin

//                         $display("[FAIL] LUI did not create SWITCH address");
//                         $display("Expected x1 : 0x10010000");
//                         $display("Actual x1   : 0x%h", dut.rs1_data);

//                         $finish;
//                     end


//                     // Kiểm tra địa chỉ do ALU tính
//                     if (dut.alu_data !== 32'h1001_0000) begin

//                         $display("[FAIL] Incorrect SWITCH address");
//                         $display("Expected : 0x10010000");
//                         $display("Actual   : 0x%h", dut.alu_data);

//                         $finish;
//                     end


//                     // Kiểm tra dữ liệu LSU đọc
//                     if (dut.ld_data !== i_io_sw) begin

//                         $display("[FAIL] LSU did not read SWITCH correctly");
//                         $display("Expected : 0x%h", i_io_sw);
//                         $display("Actual   : 0x%h", dut.ld_data);

//                         $finish;
//                     end


//                     $display("[PASS] SWITCH read correctly");

//                 end


//                 // =================================================
//                 // STEP 3
//                 // LUI x3, 0x10000
//                 // =================================================

//                 32'h0000_0008: begin

//                     $display("");
//                     $display("[CPU TRACE] PC=%08h | INSTR=%08h | VALID=%b",
//                              o_pc_debug, dut.instr, o_insn_vld);

//                     $display("");
//                     $display("[STEP 3] FETCH / DECODE");
//                     $display("Instruction : LUI x3, 0x10000");
//                     $display("Expected    : x3 = 0x10000000");
//                     $display("Purpose     : Load LEDR address");


//                     if (dut.instr !== 32'h1000_01B7) begin

//                         $display("[FAIL] Incorrect instruction at STEP 3");
//                         $display("Expected : 0x100001B7");
//                         $display("Actual   : 0x%h", dut.instr);

//                         $finish;
//                     end


//                     if (o_insn_vld !== 1'b1) begin

//                         $display("[FAIL] LUI instruction is not valid");

//                         $finish;
//                     end


//                     $display("[PASS] Instruction fetched and decoded correctly");

//                 end


//                 // =================================================
//                 // STEP 4
//                 // SW x2, 0(x3)
//                 // =================================================

//                 32'h0000_000C: begin

//                     $display("");
//                     $display("[CPU TRACE] PC=%08h | INSTR=%08h | VALID=%b",
//                              o_pc_debug, dut.instr, o_insn_vld);

//                     $display("");
//                     $display("[STEP 4] STORE TO MMIO");
//                     $display("Instruction : SW x2, 0(x3)");
//                     $display("rs1_data    : 0x%h", dut.rs1_data);
//                     $display("rs2_data    : 0x%h", dut.rs2_data);
//                     $display("ALU address : 0x%h", dut.alu_data);
//                     $display("Write data  : 0x%h", dut.rs2_data);


//                     // Kiểm tra instruction
//                     if (dut.instr !== 32'h0021_A023) begin

//                         $display("[FAIL] Incorrect instruction at STEP 4");
//                         $display("Expected : 0x0021A023");
//                         $display("Actual   : 0x%h", dut.instr);

//                         $finish;
//                     end


//                     // Kiểm tra x3
//                     if (dut.rs1_data !== 32'h1000_0000) begin

//                         $display("[FAIL] Incorrect LEDR base address");
//                         $display("Expected x3 : 0x10000000");
//                         $display("Actual x3   : 0x%h", dut.rs1_data);

//                         $finish;
//                     end


//                     // Kiểm tra dữ liệu x2
//                     if (dut.rs2_data !== i_io_sw) begin

//                         $display("[FAIL] Incorrect STORE data");
//                         $display("Expected : 0x%h", i_io_sw);
//                         $display("Actual   : 0x%h", dut.rs2_data);

//                         $finish;
//                     end


//                     // Kiểm tra địa chỉ ALU
//                     if (dut.alu_data !== 32'h1000_0000) begin

//                         $display("[FAIL] Incorrect LEDR address");
//                         $display("Expected : 0x10000000");
//                         $display("Actual   : 0x%h", dut.alu_data);

//                         $finish;
//                     end


//                     $display("[PASS] STORE address and data are correct");

//                 end


//                 // =================================================
//                 // STEP 5
//                 // FINAL RESULT
//                 // =================================================

//                 32'h0000_0010: begin

//                     $display("");
//                     $display("[CPU TRACE] PC=%08h | INSTR=%08h | VALID=%b",
//                              o_pc_debug, dut.instr, o_insn_vld);

//                     $display("");
//                     $display("[STEP 5] FINAL RESULT CHECK");
//                     $display("Switch input : 0x%h", i_io_sw);
//                     $display("LEDR output  : 0x%h", o_io_ledr);


//                     if (o_io_ledr === i_io_sw) begin

//                         test_pass = 1;

//                         $display("");
//                         $display("============================================================");
//                         $display("                 MMIO TEST PASSED");
//                         $display("============================================================");
//                         $display("CPU successfully executed the complete data path:");
//                         $display("");
//                         $display(" Instruction Memory");
//                         $display("        |");
//                         $display("        v");
//                         $display(" Decode -> Register File -> ALU");
//                         $display("        |");
//                         $display("        v");
//                         $display(" LSU reads SWITCH = 0x%h", i_io_sw);
//                         $display("        |");
//                         $display("        v");
//                         $display(" Register File -> LSU -> LEDR");
//                         $display("        |");
//                         $display("        v");
//                         $display(" LEDR output      = 0x%h", o_io_ledr);
//                         $display("");
//                         $display("RESULT: SWITCH DATA WAS CORRECTLY TRANSFERRED TO LEDR");
//                         $display("============================================================");

//                         $finish;

//                     end
//                     else begin

//                         $display("");
//                         $display("============================================================");
//                         $display("                 MMIO TEST FAILED");
//                         $display("============================================================");
//                         $display("Expected LEDR : 0x%h", i_io_sw);
//                         $display("Actual LEDR   : 0x%h", o_io_ledr);
//                         $display("============================================================");

//                         $finish;

//                     end

//                 end

//             endcase

//         end

//     end


//     // ============================================================
//     // TIMEOUT
//     // ============================================================

//     initial begin

//         #(`FINISH);

//         if (test_pass == 0) begin

//             $display("");
//             $display("============================================================");
//             $display("                 MMIO TEST FAILED");
//             $display("                    TIMEOUT");
//             $display("============================================================");
//             $display("Last PC      : 0x%h", o_pc_debug);
//             $display("Last instr   : 0x%h", dut.instr);
//             $display("Switch input : 0x%h", i_io_sw);
//             $display("LEDR output  : 0x%h", o_io_ledr);
//             $display("============================================================");

//         end

//         $finish;

//     end

// endmodule
////////////////////////////////////////////////////////////////////////////////////////////////
// `timescale 1ns/1ps

// `define CLK_PERIOD 2
// `define RESET_PERIOD 20
// `define FINISH 1000

// module tb_singlecycle_hello;

//     reg         i_clk;
//     reg         i_reset;
//     reg  [31:0] i_io_sw;

//     wire [31:0] o_io_ledr;
//     wire [31:0] o_io_ledg;
//     wire [31:0] o_io_lcd;

//     wire [6:0] o_io_hex0;
//     wire [6:0] o_io_hex1;
//     wire [6:0] o_io_hex2;
//     wire [6:0] o_io_hex3;
//     wire [6:0] o_io_hex4;
//     wire [6:0] o_io_hex5;
//     wire [6:0] o_io_hex6;
//     wire [6:0] o_io_hex7;

//     wire [31:0] o_pc_debug;
//     wire        o_insn_vld;

//     integer char_count;
//     integer test_pass;

//     reg [7:0] actual_string [0:4];


//     // ============================================================
//     // DUT
//     // ============================================================

//     singlecycle dut (
//         .i_clk       (i_clk),
//         .i_reset     (i_reset),
//         .i_io_sw     (i_io_sw),

//         .o_io_ledr   (o_io_ledr),
//         .o_io_ledg   (o_io_ledg),
//         .o_io_lcd    (o_io_lcd),

//         .o_io_hex0   (o_io_hex0),
//         .o_io_hex1   (o_io_hex1),
//         .o_io_hex2   (o_io_hex2),
//         .o_io_hex3   (o_io_hex3),
//         .o_io_hex4   (o_io_hex4),
//         .o_io_hex5   (o_io_hex5),
//         .o_io_hex6   (o_io_hex6),
//         .o_io_hex7   (o_io_hex7),

//         .o_pc_debug  (o_pc_debug),
//         .o_insn_vld  (o_insn_vld)
//     );


//     // ============================================================
//     // CLOCK
//     // ============================================================

//     initial begin
//         i_clk = 1'b1;

//         forever begin
//             #(`CLK_PERIOD);
//             i_clk = ~i_clk;
//         end
//     end


//     // ============================================================
//     // RESET + INITIALIZATION
//     //
//     // Chú ý:
//     // pc_counter của mày reset active-low
//     // ============================================================

//     initial begin

//         i_io_sw    = 32'd0;
//         char_count = 0;
//         test_pass  = 0;

//         actual_string[0] = 8'd0;
//         actual_string[1] = 8'd0;
//         actual_string[2] = 8'd0;
//         actual_string[3] = 8'd0;
//         actual_string[4] = 8'd0;

//         i_reset = 1'b0;

//         #(`RESET_PERIOD);

//         i_reset = 1'b1;

       
//     end


//     // ============================================================
//     // COMPLETE CPU TRACE
//     //
//     // Hiển thị trạng thái CPU tại mỗi chu kỳ
//     // ============================================================

//     always @(negedge i_clk) begin

//         if (i_reset === 1'b1) begin

//             $display("");
//             $display("======================================================");
//             $display(" TIME          = %0t",  $time);
//             $display(" PC            = %08h", dut.pc);
//             $display(" INSTRUCTION   = %08h", dut.instr);
//             $display(" RS1_DATA      = %08h", dut.rs1_data);
//             $display(" RS2_DATA      = %08h", dut.rs2_data);
//             $display(" IMMEDIATE     = %08h", dut.imm);
//             $display(" OPERAND_A     = %08h", dut.operand_a);
//             $display(" OPERAND_B     = %08h", dut.operand_b);
//             $display(" ALU_OP        = %04b", dut.alu_op);
//             $display(" ALU_DATA      = %08h", dut.alu_data);
//             $display(" LSU_ADDR      = %08h", dut.alu_data);
//             $display(" STORE_DATA    = %08h", dut.rs2_data);
//             $display(" LSU_WREN      = %b",   dut.lsu_wren);
//             $display(" LD_DATA       = %08h", dut.ld_data);
//             $display(" WB_SEL        = %02b", dut.wb_sel);
//             $display(" WB_DATA       = %08h", dut.wb_data);
//             $display(" RD_WREN       = %b",   dut.rd_wren);
//             $display(" INSN_VALID    = %b",   o_insn_vld);
//             $display("======================================================");

//         end

//     end


//     // ============================================================
//     // ALU DATA MONITOR
//     // ============================================================

//     always @(dut.alu_data) begin

//         if (i_reset === 1'b1) begin

//             $display("");
//             $display("------------------------------------------");
//             $display(" ALU_DATA CHANGED");
//             $display(" TIME       = %0t",  $time);
//             $display(" PC         = %08h", dut.pc);
//             $display(" INSTR      = %08h", dut.instr);
//             $display(" ALU_DATA   = %08h", dut.alu_data);
//             $display("------------------------------------------");

//         end

//     end


//     // ============================================================
//     // WRITE BACK MONITOR
//     //
//     // Chỉ hiện khi lệnh thực sự ghi Register File
//     // ============================================================

//     always @(negedge i_clk) begin

//         if ((i_reset === 1'b1) &&
//             (dut.rd_wren === 1'b1)) begin

            
//             $display(" WRITEBACK UPDATED");
//             $display(" TIME       = %0t",  $time);
//             $display(" PC         = %08h", dut.pc);
//             $display(" WB_DATA    = %08h", dut.wb_data);
//             $display(" RD_ADDR    = %0d",  dut.instr[11:7]);
//         end

//     end


//     // ============================================================
//     // HELLO PROGRAM MONITOR
//     //
//     // Chương trình:
//     //
//     // PC 00 : LUI  x1, 0x10000
//     // PC 04 : ADDI x2, x0, 'H'
//     // PC 08 : SW   x2, 0(x1)
//     //
//     // PC 0C : ADDI x2, x0, 'E'
//     // PC 10 : SW   x2, 0(x1)
//     //
//     // PC 14 : ADDI x2, x0, 'L'
//     // PC 18 : SW   x2, 0(x1)
//     //
//     // PC 1C : ADDI x2, x0, 'L'
//     // PC 20 : SW   x2, 0(x1)
//     //
//     // PC 24 : ADDI x2, x0, 'O'
//     // PC 28 : SW   x2, 0(x1)
//     //
//     // PC 2C : JAL x0, 0
//     // ============================================================

//     always @(negedge i_clk) begin

//         if (i_reset === 1'b1) begin

//             case (dut.pc)

//                 // =================================================
//                 // CHARACTER H
//                 // =================================================

//                 32'h0000_0008: begin

//                     $display("");
                    
//                   //  $display(" CHARACTER NO = 1");
//                     $display(" PC           = %08h", dut.pc);
//                     $display(" INSTRUCTION  = %08h", dut.instr);
//                     $display(" LSU_ADDR     = %08h", dut.alu_data);
//                     $display(" STORE_DATA   = %08h", dut.rs2_data);
//                     $display(" ASCII        = %02h", dut.rs2_data[7:0]);
//                     $display(" CHARACTER    = %c",   dut.rs2_data[7:0]);

//                     actual_string[0] = dut.rs2_data[7:0];

//                     if (dut.rs2_data[7:0] === 8'h48) begin
//                         char_count = char_count + 1;
//                         $display(" RESULT       = PASS");
//                     end
//                     else begin
//                         $display(" RESULT       = ERROR");
//                         $display(" EXPECTED     = H");
//                         $finish;
//                     end

//                     $display(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

//                 end


//                 // =================================================
//                 // CHARACTER E
//                 // =================================================

//                 32'h0000_0010: begin

                    
//                    // $display(" CHARACTER NO = 2");
//                     $display(" PC           = %08h", dut.pc);
//                     $display(" INSTRUCTION  = %08h", dut.instr);
//                     $display(" LSU_ADDR     = %08h", dut.alu_data);
//                     $display(" STORE_DATA   = %08h", dut.rs2_data);
//                     $display(" ASCII        = %02h", dut.rs2_data[7:0]);
//                     $display(" CHARACTER    = %c",   dut.rs2_data[7:0]);

//                     actual_string[1] = dut.rs2_data[7:0];

//                     if (dut.rs2_data[7:0] === 8'h45) begin
//                         char_count = char_count + 1;
//                         $display(" RESULT       = PASS");
//                     end
//                     else begin
//                         $display(" RESULT       = ERROR");
//                         $display(" EXPECTED     = E");
//                         $finish;
//                     end

//                    // $display(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

//                 end


//                 // =================================================
//                 // CHARACTER L
//                 // =================================================

//                 32'h0000_0018: begin

                   
//                     $display(" PC           = %08h", dut.pc);
//                     $display(" INSTRUCTION  = %08h", dut.instr);
//                     $display(" LSU_ADDR     = %08h", dut.alu_data);
//                     $display(" STORE_DATA   = %08h", dut.rs2_data);
//                     $display(" ASCII        = %02h", dut.rs2_data[7:0]);
//                     $display(" CHARACTER    = %c",   dut.rs2_data[7:0]);

//                     actual_string[2] = dut.rs2_data[7:0];

//                     if (dut.rs2_data[7:0] === 8'h4C) begin
//                         char_count = char_count + 1;
//                         $display(" RESULT       = PASS");
//                     end
//                     else begin
//                         $display(" RESULT       = ERROR");
//                         $display(" EXPECTED     = L");
//                         $finish;
//                     end

//                     //$display(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

//                 end


//                 // =================================================
//                 // CHARACTER L
//                 // =================================================

//                 32'h0000_0020: begin

                  
//                     $display(" PC           = %08h", dut.pc);
//                     $display(" INSTRUCTION  = %08h", dut.instr);
//                     $display(" LSU_ADDR     = %08h", dut.alu_data);
//                     $display(" STORE_DATA   = %08h", dut.rs2_data);
//                     $display(" ASCII        = %02h", dut.rs2_data[7:0]);
//                     $display(" CHARACTER    = %c",   dut.rs2_data[7:0]);

//                     actual_string[3] = dut.rs2_data[7:0];

//                     if (dut.rs2_data[7:0] === 8'h4C) begin
//                         char_count = char_count + 1;
//                         $display(" RESULT       = PASS");
//                     end
//                     else begin
//                         $display(" RESULT       = ERROR");
//                         $display(" EXPECTED     = L");
//                         $finish;
//                     end

//                     //$display(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

//                 end


//                 // =================================================
//                 // CHARACTER O
//                 // =================================================

//                 32'h0000_0028: begin

                   
//                     $display(" PC           = %08h", dut.pc);
//                     $display(" INSTRUCTION  = %08h", dut.instr);
//                     $display(" LSU_ADDR     = %08h", dut.alu_data);
//                     $display(" STORE_DATA   = %08h", dut.rs2_data);
//                     $display(" ASCII        = %02h", dut.rs2_data[7:0]);
//                     $display(" CHARACTER    = %c",   dut.rs2_data[7:0]);

//                     actual_string[4] = dut.rs2_data[7:0];

//                     if (dut.rs2_data[7:0] === 8'h4F) begin
//                         char_count = char_count + 1;
//                         $display(" RESULT       = PASS");
//                     end
//                     else begin
//                         $display(" RESULT       = ERROR");
//                         $display(" EXPECTED     = O");
//                         $finish;
//                     end

//                    // $display(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

//                 end


//                 // =================================================
//                 // FINAL CHECK
//                 // =================================================

//                 32'h0000_002C: begin

//                     if (char_count == 5) begin

//                         test_pass = 1;

                       
//                         $display("#                                                    #");
//                         $display("#               HELLO PROGRAM PASSED                 #");
//                         $display(" EXPECTED STRING = HELLO");
//                         $write  (" ACTUAL STRING   = ");

//                         $write("%c", actual_string[0]);
//                         $write("%c", actual_string[1]);
//                         $write("%c", actual_string[2]);
//                         $write("%c", actual_string[3]);
//                         $write("%c", actual_string[4]);

                      
//                         $finish;

//                     end
//                     else begin

//                         $display("");
//                         $display("#               HELLO PROGRAM FAILED                 #");
//                         $display(" EXPECTED CHARACTERS = 5");
//                         $display(" ACTUAL CHARACTERS   = %0d", char_count);

//                         $finish;

//                     end

//                 end

//             endcase

//         end

//     end


//     // ============================================================
//     // TIMEOUT
//     // ============================================================

//     initial begin

//         #(`FINISH);

//         if (test_pass == 0) begin

//             $display("");
           
//             $display("#               HELLO PROGRAM FAILED                 #");
           
//             $display(" REASON              = TIMEOUT");
//             $display(" LAST PC             = %08h", dut.pc);
//             $display(" CHARACTERS RECEIVED = %0d", char_count);

//         end

//         $finish;

//     end

// endmodule