library verilog;
use verilog.vl_types.all;
entity pc_4 is
    port(
        i_pc            : in     vl_logic_vector(31 downto 0);
        o_pc_four       : out    vl_logic_vector(31 downto 0)
    );
end pc_4;
