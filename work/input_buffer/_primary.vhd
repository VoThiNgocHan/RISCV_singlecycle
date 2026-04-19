library verilog;
use verilog.vl_types.all;
entity input_buffer is
    port(
        i_control       : in     vl_logic_vector(2 downto 0);
        i_in_buf_addr   : in     vl_logic_vector(31 downto 0);
        i_io_sw         : in     vl_logic_vector(31 downto 0);
        o_in_buf_data   : out    vl_logic_vector(31 downto 0)
    );
end input_buffer;
