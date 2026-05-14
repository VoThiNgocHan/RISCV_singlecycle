module instr_mem(
    input logic [31:0] i_pc_addr,
    output logic [31:0] o_instr
);
logic [31:0] imem [2047:0];
initial begin
//$readmemh ("/home/cpa/ca101/Desktop/milestone2/02_test/isa.mem",imem);
    $readmemh("D:/NLS_Intern/risc_v/mem.dump", dut.imem.imem);

end
assign o_instr = imem[i_pc_addr[31:2]];
endmodule
