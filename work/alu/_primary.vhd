library verilog;
use verilog.vl_types.all;
entity alu is
    generic(
        add             : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        sub             : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        slt             : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        sltu            : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        xxor            : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        oor             : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        aand            : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        \sll\           : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi1);
        \srl\           : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi0);
        \sra\           : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi1)
    );
    port(
        i_op_a          : in     vl_logic_vector(31 downto 0);
        i_op_b          : in     vl_logic_vector(31 downto 0);
        i_alu_op        : in     vl_logic_vector(3 downto 0);
        o_alu_data      : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of add : constant is 1;
    attribute mti_svvh_generic_type of sub : constant is 1;
    attribute mti_svvh_generic_type of slt : constant is 1;
    attribute mti_svvh_generic_type of sltu : constant is 1;
    attribute mti_svvh_generic_type of xxor : constant is 1;
    attribute mti_svvh_generic_type of oor : constant is 1;
    attribute mti_svvh_generic_type of aand : constant is 1;
    attribute mti_svvh_generic_type of \sll\ : constant is 1;
    attribute mti_svvh_generic_type of \srl\ : constant is 1;
    attribute mti_svvh_generic_type of \sra\ : constant is 1;
end alu;
