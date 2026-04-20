module instr_mem(
    input  [31:0] i_pc_addr,
    output [31:0] o_instr
);

reg [31:0] imem [0:2047];

initial begin
    $readmemh("D:/NLS_Intern/risc_v/mem.dump", imem);
end

assign o_instr = imem[i_pc_addr[31:2]];

endmodule