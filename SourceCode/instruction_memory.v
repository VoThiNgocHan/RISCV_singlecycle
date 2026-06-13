module instruction_memory(
  input   [10:0] i_addr,
  output  [31:0] o_instr
);

   parameter MEM_SIZE = 2048;
   wire [31:0] mem [MEM_SIZE-1:0];
   assign o_instr = mem[i_addr];
   initial begin
	 $readmemh("D:\NLS_Intern\risc_v\mem.dump",mem);
   end

endmodule 
