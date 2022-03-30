library verilog;
use verilog.vl_types.all;
entity registrador is
    port(
        i               : in     vl_logic_vector(3 downto 0);
        shlin           : in     vl_logic;
        shrin           : in     vl_logic;
        clk             : in     vl_logic;
        s               : in     vl_logic_vector(1 downto 0);
        q               : out    vl_logic_vector(3 downto 0)
    );
end registrador;
