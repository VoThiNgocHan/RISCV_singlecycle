module instruction_memory(
  input  logic [10:0] i_addr,
  output logic [31:0] o_instr
);

   parameter MEM_SIZE = 2048;
  logic [31:0] mem [MEM_SIZE-1:0];
  assign o_instr = mem[i_addr];
  initial begin
   /* integer i;
	 for (i=0; i < MEM_SIZE; i++) begin
	   mem[i] = 32'b0;
	 end*/
	 //$readmemh("./../02_test/isa_4b.hex",mem);
	 $readmemh("D:\NLS_Intern\risc_v\mem.dump",mem);
  end

endmodule 