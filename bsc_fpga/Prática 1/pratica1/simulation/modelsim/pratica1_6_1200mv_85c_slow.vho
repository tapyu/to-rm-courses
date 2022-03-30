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

-- DATE "02/27/2018 16:07:39"

-- 
-- Device: Altera EP3C16F484C6 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIII;
LIBRARY IEEE;
USE CYCLONEIII.CYCLONEIII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	pratica1 IS
    PORT (
	p : IN std_logic;
	c : IN std_logic;
	h : IN std_logic;
	f : BUFFER std_logic
	);
END pratica1;

-- Design Ports Information
-- f	=>  Location: PIN_H11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p	=>  Location: PIN_W13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- h	=>  Location: PIN_G4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- c	=>  Location: PIN_B1,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF pratica1 IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_p : std_logic;
SIGNAL ww_c : std_logic;
SIGNAL ww_h : std_logic;
SIGNAL ww_f : std_logic;
SIGNAL \f~output_o\ : std_logic;
SIGNAL \c~input_o\ : std_logic;
SIGNAL \p~input_o\ : std_logic;
SIGNAL \h~input_o\ : std_logic;
SIGNAL \f~0_combout\ : std_logic;

BEGIN

ww_p <= p;
ww_c <= c;
ww_h <= h;
f <= ww_f;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

-- Location: IOOBUF_X19_Y29_N30
\f~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \f~0_combout\,
	devoe => ww_devoe,
	o => \f~output_o\);

-- Location: IOIBUF_X0_Y27_N15
\c~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_c,
	o => \c~input_o\);

-- Location: IOIBUF_X26_Y0_N29
\p~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_p,
	o => \p~input_o\);

-- Location: IOIBUF_X0_Y23_N8
\h~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_h,
	o => \h~input_o\);

-- Location: LCCOMB_X24_Y15_N24
\f~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \f~0_combout\ = (!\c~input_o\ & ((\p~input_o\) # (\h~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \c~input_o\,
	datac => \p~input_o\,
	datad => \h~input_o\,
	combout => \f~0_combout\);

ww_f <= \f~output_o\;
END structure;


