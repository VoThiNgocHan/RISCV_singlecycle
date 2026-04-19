library verilog;
use verilog.vl_types.all;
entity opb_mux is
    port(
        rs2_data        : in     vl_logic_vector(31 downto 0);
        imm             : in     vl_logic_vector(31 downto 0);
        opb_sel         : in     vl_logic;
        operand_b       : out    vl_logic_vector(31 downto 0)
    );
end opb_mux;
