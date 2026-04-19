library verilog;
use verilog.vl_types.all;
entity data_mem is
    generic(
        LB              : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        LH              : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        LW              : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        LBU             : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        LHU             : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1)
    );
    port(
        i_clk           : in     vl_logic;
        i_reset         : in     vl_logic;
        i_addr          : in     vl_logic_vector(31 downto 0);
        i_wdata         : in     vl_logic_vector(31 downto 0);
        i_bmask         : in     vl_logic_vector(3 downto 0);
        i_wren          : in     vl_logic;
        i_control       : in     vl_logic_vector(2 downto 0);
        o_rdata         : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LB : constant is 1;
    attribute mti_svvh_generic_type of LH : constant is 1;
    attribute mti_svvh_generic_type of LW : constant is 1;
    attribute mti_svvh_generic_type of LBU : constant is 1;
    attribute mti_svvh_generic_type of LHU : constant is 1;
end data_mem;
