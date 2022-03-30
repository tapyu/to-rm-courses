library verilog;
use verilog.vl_types.all;
entity registrador_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        i               : in     vl_logic_vector(3 downto 0);
        s               : in     vl_logic_vector(1 downto 0);
        shlin           : in     vl_logic;
        shrin           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end registrador_vlg_sample_tst;
