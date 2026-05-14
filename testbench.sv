`timescale 1ns/1ps

module tb_singlecycle;

////////////////////////////////////////////////////////////
// INPUTS
////////////////////////////////////////////////////////////

reg         i_clk;
reg         i_reset;

reg [31:0]  i_ld_data;

////////////////////////////////////////////////////////////
// OUTPUTS
////////////////////////////////////////////////////////////

wire        o_insn_vld;

wire [31:0] o_pc_debug;

wire [31:0] instr;

wire [3:0]  alu_op;

wire [31:0] o_lsu_addr;
wire [31:0] o_st_data;

wire        o_lsu_wren;
wire        o_lsu_rden;

wire [2:0]  o_lsu_control;

////////////////////////////////////////////////////////////
// DUT
////////////////////////////////////////////////////////////

singlecycle dut(

    .i_clk(i_clk),
    .i_reset(i_reset),

    .i_ld_data(i_ld_data),

    .o_insn_vld(o_insn_vld),

    .o_pc_debug(o_pc_debug),

    .instr(instr),

    .alu_op(alu_op),

    .o_lsu_addr(o_lsu_addr),
    .o_st_data(o_st_data),

    .o_lsu_wren(o_lsu_wren),
    .o_lsu_rden(o_lsu_rden),

    .o_lsu_control(o_lsu_control)
);

////////////////////////////////////////////////////////////
// CLOCK
////////////////////////////////////////////////////////////

always #5 i_clk = ~i_clk;

////////////////////////////////////////////////////////////
// MONITOR
////////////////////////////////////////////////////////////

always @(posedge i_clk) begin

    $display("====================================================");

    $display("TIME          = %0t", $time);

    $display("PC            = %h", o_pc_debug);

    $display("INSTRUCTION   = %h", instr);

    $display("ALU_OP        = %b", alu_op);

    $display("LSU_ADDR      = %h", o_lsu_addr);

    $display("STORE_DATA    = %h", o_st_data);

    $display("LSU_WREN      = %b", o_lsu_wren);

    $display("LSU_RDEN      = %b", o_lsu_rden);

    $display("LSU_CONTROL   = %b", o_lsu_control);

    $display("LD_DATA       = %h", i_ld_data);

    $display("INSN_VALID    = %b", o_insn_vld);

    $display("====================================================\n");

end

////////////////////////////////////////////////////////////
// ALU CHANGE MONITOR
////////////////////////////////////////////////////////////

always @(dut.alu_data) begin

    $display("--------------------------------------------");

    $display("ALU_DATA CHANGED");

    $display("TIME      = %0t", $time);

    $display("PC        = %h", o_pc_debug);

    $display("INSTR     = %h", instr);

    $display("ALU_DATA  = %h", dut.alu_data);

    $display("--------------------------------------------\n");

end

////////////////////////////////////////////////////////////
// WRITEBACK MONITOR
////////////////////////////////////////////////////////////

always @(posedge i_clk) begin
    if(dut.rd_wren) begin
        $display("********************************************");

        $display("WRITEBACK UPDATED");

        $display("TIME      = %0t", $time);

        $display("PC        = %h", o_pc_debug);

        $display("WB_DATA   = %h", dut.wb_data);

        $display("RD_ADDR   = %d", dut.rd_addr);

        $display("********************************************\n");
    end
end

////////////////////////////////////////////////////////////
// LOAD / STORE MONITOR
////////////////////////////////////////////////////////////
always @(posedge i_clk) begin

    if(o_lsu_wren) begin

        $display("######## STORE DETECTED ########");

        $display("TIME          = %0t", $time);

        $display("STORE_ADDR    = %h", o_lsu_addr);

        $display("STORE_DATA    = %h", o_st_data);

        $display("FUNCT3        = %b", o_lsu_control);

        if(o_lsu_addr[31:16] == 16'h1000) begin

            $display("LCD WRITE : %c", o_st_data[7:0]);

        end

        $display("################################\n");

    end

    if(o_lsu_rden) begin

        $display("######## LOAD DETECTED #########");

        $display("TIME          = %0t", $time);

        $display("LOAD_ADDR     = %h", o_lsu_addr);

        $display("LOAD_DATA     = %h", i_ld_data);

        $display("FUNCT3        = %b", o_lsu_control);

        $display("################################\n");

    end

end

////////////////////////////////////////////////////////////
// BRANCH MONITOR
////////////////////////////////////////////////////////////

always @(posedge i_clk) begin

    if(dut.pc_sel) begin

        $display("$$$$$$$$ BRANCH / JUMP $$$$$$$$$");

        $display("TIME          = %0t", $time);

        $display("PC_OLD        = %h", dut.pc);

        $display("PC_NEW        = %h", dut.pc_next);

        $display("TARGET        = %h", dut.pc_target);

        $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");

    end

end

////////////////////////////////////////////////////////////
// TEST SEQUENCE
////////////////////////////////////////////////////////////

initial begin

    ////////////////////////////////////////////////////////
    // INIT
    ////////////////////////////////////////////////////////

    i_clk      = 0;

    i_reset    = 1;

    i_ld_data  = 32'h0;

    ////////////////////////////////////////////////////////
    // RESET
    ////////////////////////////////////////////////////////

    #20;

    i_reset = 0;

    ////////////////////////////////////////////////////////
    // LOAD DATA TEST
    ////////////////////////////////////////////////////////

    #30;

    i_ld_data = 32'h12345678;

    #20;

    i_ld_data = 32'hDEADBEEF;

    #20;

    i_ld_data = 32'hCAFEBABE;

    ////////////////////////////////////////////////////////
    // RUN CPU
    ////////////////////////////////////////////////////////

    #300;

    ////////////////////////////////////////////////////////
    // FINISH
    ////////////////////////////////////////////////////////

    $display("\n====================================");
    $display("SIMULATION FINISHED");
    $display("====================================\n");

    $finish;

end

endmodule