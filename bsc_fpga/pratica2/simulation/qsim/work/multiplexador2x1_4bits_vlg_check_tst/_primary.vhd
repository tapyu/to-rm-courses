library verilog;
use verilog.vl_types.all;
entity multiplexador2x1_4bits_vlg_check_tst is
    port(
        y               : in     vl_logic_vector(3 downto 0);
        sampler_rx      : in     vl_logic
    );
end multiplexador2x1_4bits_vlg_check_tst;
