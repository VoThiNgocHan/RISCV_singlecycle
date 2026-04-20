library verilog;
use verilog.vl_types.all;
entity ALU_control is
    port(
        opcode          : in     vl_logic_vector(6 downto 0);
        ALUop           : out    vl_logic_vector(1 downto 0)
    );
end ALU_control;
