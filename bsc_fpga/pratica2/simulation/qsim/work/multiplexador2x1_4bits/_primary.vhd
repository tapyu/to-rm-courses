library verilog;
use verilog.vl_types.all;
entity multiplexador2x1_4bits is
    port(
        a               : in     vl_logic_vector(3 downto 0);
        b               : in     vl_logic_vector(3 downto 0);
        s               : in     vl_logic;
        y               : out    vl_logic_vector(3 downto 0)
    );
end multiplexador2x1_4bits;
