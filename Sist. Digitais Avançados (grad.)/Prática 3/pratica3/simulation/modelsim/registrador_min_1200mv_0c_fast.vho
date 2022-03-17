-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"

-- DATE "03/16/2018 12:08:52"

-- 
-- Device: Altera EP3C16F484C6 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY CYCLONEIII;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIII.CYCLONEIII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	registrador IS
    PORT (
	i : IN STD.STANDARD.bit_vector(3 DOWNTO 0);
	shlin : IN std_logic;
	shrin : IN std_logic;
	clk : IN std_logic;
	s : IN STD.STANDARD.bit_vector(1 DOWNTO 0);
	q : BUFFER STD.STANDARD.bit_vector(3 DOWNTO 0)
	);
END registrador;

-- Design Ports Information
-- q[0]	=>  Location: PIN_G3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q[1]	=>  Location: PIN_H1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q[2]	=>  Location: PIN_L8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q[3]	=>  Location: PIN_F1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_G2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- shlin	=>  Location: PIN_G4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- s[0]	=>  Location: PIN_J6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- i[0]	=>  Location: PIN_K7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- s[1]	=>  Location: PIN_J7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- i[1]	=>  Location: PIN_H2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- i[2]	=>  Location: PIN_J4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- shrin	=>  Location: PIN_K8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- i[3]	=>  Location: PIN_J3,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF registrador IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_i : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_shlin : std_logic;
SIGNAL ww_shrin : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_s : std_logic_vector(1 DOWNTO 0);
SIGNAL ww_q : std_logic_vector(3 DOWNTO 0);
SIGNAL \clk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \q[0]~output_o\ : std_logic;
SIGNAL \q[1]~output_o\ : std_logic;
SIGNAL \q[2]~output_o\ : std_logic;
SIGNAL \q[3]~output_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputclkctrl_outclk\ : std_logic;
SIGNAL \s[0]~input_o\ : std_logic;
SIGNAL \shlin~input_o\ : std_logic;
SIGNAL \shrin~input_o\ : std_logic;
SIGNAL \q3|q~0_combout\ : std_logic;
SIGNAL \i[3]~input_o\ : std_logic;
SIGNAL \s[1]~input_o\ : std_logic;
SIGNAL \q0|q~1_combout\ : std_logic;
SIGNAL \q3|q~q\ : std_logic;
SIGNAL \q2|q~0_combout\ : std_logic;
SIGNAL \i[2]~input_o\ : std_logic;
SIGNAL \q2|q~q\ : std_logic;
SIGNAL \q1|q~0_combout\ : std_logic;
SIGNAL \i[1]~input_o\ : std_logic;
SIGNAL \q1|q~q\ : std_logic;
SIGNAL \q0|q~0_combout\ : std_logic;
SIGNAL \i[0]~input_o\ : std_logic;
SIGNAL \q0|q~q\ : std_logic;
SIGNAL \ALT_INV_s[1]~input_o\ : std_logic;

BEGIN

ww_i <= IEEE.STD_LOGIC_1164.TO_STDLOGICVECTOR(i);
ww_shlin <= shlin;
ww_shrin <= shrin;
ww_clk <= clk;
ww_s <= IEEE.STD_LOGIC_1164.TO_STDLOGICVECTOR(s);
q <= IEEE.STD_LOGIC_1164.TO_BITVECTOR(ww_q);
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\clk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \clk~input_o\);
\ALT_INV_s[1]~input_o\ <= NOT \s[1]~input_o\;

-- Location: IOOBUF_X0_Y23_N16
\q[0]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \q0|q~q\,
	devoe => ww_devoe,
	o => \q[0]~output_o\);

-- Location: IOOBUF_X0_Y21_N16
\q[1]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \q1|q~q\,
	devoe => ww_devoe,
	o => \q[1]~output_o\);

-- Location: IOOBUF_X0_Y22_N2
\q[2]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \q2|q~q\,
	devoe => ww_devoe,
	o => \q[2]~output_o\);

-- Location: IOOBUF_X0_Y23_N2
\q[3]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \q3|q~q\,
	devoe => ww_devoe,
	o => \q[3]~output_o\);

-- Location: IOIBUF_X0_Y14_N1
\clk~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: CLKCTRL_G4
\clk~inputclkctrl\ : cycloneiii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk~inputclkctrl_outclk\);

-- Location: IOIBUF_X0_Y24_N1
\s[0]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_s(0),
	o => \s[0]~input_o\);

-- Location: IOIBUF_X0_Y23_N8
\shlin~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_shlin,
	o => \shlin~input_o\);

-- Location: IOIBUF_X0_Y22_N8
\shrin~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_shrin,
	o => \shrin~input_o\);

-- Location: LCCOMB_X1_Y22_N10
\q3|q~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \q3|q~0_combout\ = (\s[0]~input_o\ & ((\q2|q~q\))) # (!\s[0]~input_o\ & (\shrin~input_o\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \s[0]~input_o\,
	datab => \shrin~input_o\,
	datad => \q2|q~q\,
	combout => \q3|q~0_combout\);

-- Location: IOIBUF_X0_Y21_N22
\i[3]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_i(3),
	o => \i[3]~input_o\);

-- Location: IOIBUF_X0_Y22_N15
\s[1]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_s(1),
	o => \s[1]~input_o\);

-- Location: LCCOMB_X1_Y22_N28
\q0|q~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \q0|q~1_combout\ = (\s[1]~input_o\) # (\s[0]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \s[1]~input_o\,
	datac => \s[0]~input_o\,
	combout => \q0|q~1_combout\);

-- Location: FF_X1_Y22_N11
\q3|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \q3|q~0_combout\,
	asdata => \i[3]~input_o\,
	sload => \ALT_INV_s[1]~input_o\,
	ena => \q0|q~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \q3|q~q\);

-- Location: LCCOMB_X1_Y22_N0
\q2|q~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \q2|q~0_combout\ = (\s[0]~input_o\ & (\q1|q~q\)) # (!\s[0]~input_o\ & ((\q3|q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \q1|q~q\,
	datab => \s[0]~input_o\,
	datad => \q3|q~q\,
	combout => \q2|q~0_combout\);

-- Location: IOIBUF_X0_Y21_N1
\i[2]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_i(2),
	o => \i[2]~input_o\);

-- Location: FF_X1_Y22_N1
\q2|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \q2|q~0_combout\,
	asdata => \i[2]~input_o\,
	sload => \ALT_INV_s[1]~input_o\,
	ena => \q0|q~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \q2|q~q\);

-- Location: LCCOMB_X1_Y22_N6
\q1|q~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \q1|q~0_combout\ = (\s[0]~input_o\ & (\q0|q~q\)) # (!\s[0]~input_o\ & ((\q2|q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \s[0]~input_o\,
	datab => \q0|q~q\,
	datad => \q2|q~q\,
	combout => \q1|q~0_combout\);

-- Location: IOIBUF_X0_Y21_N8
\i[1]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_i(1),
	o => \i[1]~input_o\);

-- Location: FF_X1_Y22_N7
\q1|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \q1|q~0_combout\,
	asdata => \i[1]~input_o\,
	sload => \ALT_INV_s[1]~input_o\,
	ena => \q0|q~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \q1|q~q\);

-- Location: LCCOMB_X1_Y22_N8
\q0|q~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \q0|q~0_combout\ = (\s[0]~input_o\ & (\shlin~input_o\)) # (!\s[0]~input_o\ & ((\q1|q~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \s[0]~input_o\,
	datab => \shlin~input_o\,
	datad => \q1|q~q\,
	combout => \q0|q~0_combout\);

-- Location: IOIBUF_X0_Y22_N22
\i[0]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_i(0),
	o => \i[0]~input_o\);

-- Location: FF_X1_Y22_N9
\q0|q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \q0|q~0_combout\,
	asdata => \i[0]~input_o\,
	sload => \ALT_INV_s[1]~input_o\,
	ena => \q0|q~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \q0|q~q\);

ww_q(0) <= \q[0]~output_o\;

ww_q(1) <= \q[1]~output_o\;

ww_q(2) <= \q[2]~output_o\;

ww_q(3) <= \q[3]~output_o\;
END structure;


