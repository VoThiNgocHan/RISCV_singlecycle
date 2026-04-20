library verilog;
use verilog.vl_types.all;
entity mux_2in1 is
    generic(
        WIDTH           : integer := 32
    );
    port(
        i_sel           : in     vl_logic;
        i_in0           : in     vl_logic_vector;
        i_in1           : in     vl_logic_vector;
        o_out           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end mux_2in1;
