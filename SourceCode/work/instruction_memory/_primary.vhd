library verilog;
use verilog.vl_types.all;
entity instruction_memory is
    generic(
        MEM_SIZE        : integer := 2048
    );
    port(
        i_addr          : in     vl_logic_vector(10 downto 0);
        o_instr         : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEM_SIZE : constant is 1;
end instruction_memory;
