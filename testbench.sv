`timescale 1ns/1ps

module tb_singlecycle;

////////////////////////////////////////////////////////////
// CLOCK / RESET
////////////////////////////////////////////////////////////

reg clk;
reg reset;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    #20;
    reset = 0;
end

////////////////////////////////////////////////////////////
// DUT
////////////////////////////////////////////////////////////

wire        insn_vld;
wire [31:0] pc;
wire [31:0] instr;
wire [3:0]  alu_op;

wire [31:0] ledr;
wire [31:0] ledg;
wire [31:0] lcd;

wire [6:0] hex0, hex1, hex2, hex3;
wire [6:0] hex4, hex5, hex6, hex7;

singlecycle dut (
    .i_clk(clk),
    .i_reset(reset),
    .i_io_sw(32'b0),

    .o_insn_vld(insn_vld),
    .o_pc_debug(pc),

    .o_io_ledr(ledr),
    .o_io_ledg(ledg),
    .o_io_lcd(lcd),

    .o_io_hex0(hex0),
    .o_io_hex1(hex1),
    .o_io_hex2(hex2),
    .o_io_hex3(hex3),
    .o_io_hex4(hex4),
    .o_io_hex5(hex5),
    .o_io_hex6(hex6),
    .o_io_hex7(hex7),

    .instr(instr),
    .alu_op(alu_op)
);

////////////////////////////////////////////////////////////
// RV32I DECODER
////////////////////////////////////////////////////////////

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;

assign opcode = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];

////////////////////////////////////////////////////////////
// HELLO MONITOR
////////////////////////////////////////////////////////////

reg [3:0] hello_state;

initial begin
    hello_state = 0;
end

always @(posedge clk) begin

    if(!reset) begin

        case(pc)

            32'h00000000:
                if(hello_state == 0) begin
                    $write("H");
                    hello_state <= 1;
                end

            32'h00000004:
                if(hello_state == 1) begin
                    $write("E");
                    hello_state <= 2;
                end

            32'h00000008:
                if(hello_state == 2) begin
                    $write("L");
                    hello_state <= 3;
                end

            32'h0000000C:
                if(hello_state == 3) begin
                    $write("L");
                    hello_state <= 4;
                end

            32'h00000010:
                if(hello_state == 4) begin
                    $write("O\n");
                    hello_state <= 5;
                end

        endcase
    end
end

////////////////////////////////////////////////////////////
// EXECUTION TRACE
////////////////////////////////////////////////////////////

always @(posedge clk) begin

    if (!reset && insn_vld) begin

        $display("\n====================================");

        $display("TIME    : %0t ns", $time);
        $display("PC      : %08h", pc);
        $display("INSTR   : %08h", instr);
        $display("ALU_OP  : %b", alu_op);

        ////////////////////////////////////////////////////
        // Instruction Decode
        ////////////////////////////////////////////////////

        case(opcode)

            7'b0110011: begin

                case({funct7, funct3})

                    10'b0000000_000:
                        $display("EXECUTE : ADD");

                    10'b0100000_000:
                        $display("EXECUTE : SUB");

                    10'b0000000_111:
                        $display("EXECUTE : AND");

                    10'b0000000_110:
                        $display("EXECUTE : OR");

                    default:
                        $display("EXECUTE : UNKNOWN R");

                endcase
            end

            7'b0010011: begin

                case(funct3)

                    3'b000:
                        $display("EXECUTE : ADDI");

                    default:
                        $display("EXECUTE : UNKNOWN I");

                endcase
            end

            7'b0000011:
                $display("EXECUTE : LOAD");

            7'b0100011:
                $display("EXECUTE : STORE");

            7'b1100011:
                $display("EXECUTE : BRANCH");

            7'b0110111:
                $display("EXECUTE : LUI");

            7'b1101111:
                $display("EXECUTE : JAL");

            default:
                $display("EXECUTE : UNKNOWN");

        endcase

        ////////////////////////////////////////////////////
        // REGISTER CHECK
        ////////////////////////////////////////////////////

        $display("x1  = %08h", dut.reg_file.regs[1]);
        $display("x2  = %08h", dut.reg_file.regs[2]);
        $display("x3  = %08h", dut.reg_file.regs[3]);
        $display("x4  = %08h", dut.reg_file.regs[4]);
        $display("x5  = %08h", dut.reg_file.regs[5]);
        $display("x6  = %08h", dut.reg_file.regs[6]);
        $display("x7  = %08h", dut.reg_file.regs[7]);
        $display("x10 = %08h", dut.reg_file.regs[10]);

        ////////////////////////////////////////////////////
        // OUTPUT DEVICES
        ////////////////////////////////////////////////////

        $display("LEDR = %08h", ledr);
        $display("LEDG = %08h", ledg);

        $display("LCD  = %c%c%c%c",
            lcd[31:24],
            lcd[23:16],
            lcd[15:8],
            lcd[7:0]);

        $display("STORE ADDR = %08h", dut.alu_data);
        $display("STORE DATA = %08h", dut.rs2_data);        

    end
end

////////////////////////////////////////////////////////////
// TIMEOUT
////////////////////////////////////////////////////////////

initial begin

    #2500;

    $display("\n####################################");
    $display("############# TIMEOUT ##############");
    $display("####################################");

    $finish;
end

endmodule