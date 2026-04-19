library verilog;
use verilog.vl_types.all;
entity opa_mux is
    port(
        pc              : in     vl_logic_vector(31 downto 0);
        rs1_data        : in     vl_logic_vector(31 downto 0);
        opa_sel         : in     vl_logic;
        operand_a       : out    vl_logic_vector(31 downto 0)
    );
end opa_mux;
