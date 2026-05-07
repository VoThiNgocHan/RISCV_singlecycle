library verilog;
use verilog.vl_types.all;
entity pc_hold is
    port(
        i_pc_next       : in     vl_logic_vector(31 downto 0);
        i_clk           : in     vl_logic;
        i_rst           : in     vl_logic;
        o_pc            : out    vl_logic_vector(31 downto 0)
    );
end pc_hold;
