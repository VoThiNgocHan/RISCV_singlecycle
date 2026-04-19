library verilog;
use verilog.vl_types.all;
entity ALU_decoder is
    port(
        opcode          : in     vl_logic_vector(6 downto 0);
        funct3          : in     vl_logic_vector(2 downto 0);
        funct7          : in     vl_logic_vector(6 downto 0);
        ALUop           : in     vl_logic_vector(1 downto 0);
        ALU_control     : out    vl_logic_vector(3 downto 0)
    );
end ALU_decoder;
