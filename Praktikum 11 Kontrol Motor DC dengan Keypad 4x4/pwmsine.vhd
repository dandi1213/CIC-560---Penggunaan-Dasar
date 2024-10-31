-- megafunction wizard: %ROM: 1-PORT%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: altsyncram 

-- ============================================================
-- File Name: pwmsine.vhd
-- Megafunction Name(s):
-- 			altsyncram
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 5.0 Build 148 04/26/2005 SJ Full Version
-- ************************************************************


--Copyright (C) 1991-2005 Altera Corporation
--Your use of Altera Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic       
--functions, and any output files any of the foregoing           
--(including device programming or simulation files), and any    
--associated documentation or information are expressly subject  
--to the terms and conditions of the Altera Program License      
--Subscription Agreement, Altera MegaCore Function License       
--Agreement, or other applicable license agreement, including,   
--without limitation, that your use is for the sole purpose of   
--programming logic devices manufactured by Altera and sold by   
--Altera or its authorized distributors.  Please refer to the    
--applicable agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY pwmsine IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
END pwmsine;


ARCHITECTURE SYN OF pwmsine IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (9 DOWNTO 0);



	COMPONENT altsyncram
	GENERIC (
		intended_device_family		: STRING;
		width_a		: NATURAL;
		widthad_a		: NATURAL;
		numwords_a		: NATURAL;
		operation_mode		: STRING;
		outdata_reg_a		: STRING;
		address_aclr_a		: STRING;
		outdata_aclr_a		: STRING;
		width_byteena_a		: NATURAL;
		init_file		: STRING;
		lpm_hint		: STRING;
		lpm_type		: STRING
	);
	PORT (
			clock0	: IN STD_LOGIC ;
			address_a	: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			q_a	: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	q    <= sub_wire0(9 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		intended_device_family => "Stratix",
		width_a => 10,
		widthad_a => 7,
		numwords_a => 128,
		operation_mode => "ROM",
		outdata_reg_a => "CLOCK0",
		address_aclr_a => "NONE",
		outdata_aclr_a => "NONE",
		width_byteena_a => 1,
		init_file => "E:/max2work/vhdl/sine10f.mif",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram"
	)
	PORT MAP (
		clock0 => clock,
		address_a => address,
		q_a => sub_wire0
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: WidthData NUMERIC "10"
-- Retrieval info: PRIVATE: WidthAddr NUMERIC "7"
-- Retrieval info: PRIVATE: NUMWORDS_A NUMERIC "128"
-- Retrieval info: PRIVATE: SingleClock NUMERIC "1"
-- Retrieval info: PRIVATE: UseDQRAM NUMERIC "0"
-- Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
-- Retrieval info: PRIVATE: MAXIMUM_DEPTH NUMERIC "0"
-- Retrieval info: PRIVATE: IMPLEMENT_IN_LES NUMERIC "0"
-- Retrieval info: PRIVATE: RegAddr NUMERIC "1"
-- Retrieval info: PRIVATE: RegOutput NUMERIC "1"
-- Retrieval info: PRIVATE: BYTE_ENABLE NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_SIZE NUMERIC "8"
-- Retrieval info: PRIVATE: AclrByte NUMERIC "0"
-- Retrieval info: PRIVATE: AclrAddr NUMERIC "0"
-- Retrieval info: PRIVATE: AclrOutput NUMERIC "0"
-- Retrieval info: PRIVATE: Clken NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: ADDRESSSTALL_A NUMERIC "0"
-- Retrieval info: PRIVATE: INIT_TO_SIM_X NUMERIC "0"
-- Retrieval info: PRIVATE: BlankMemory NUMERIC "0"
-- Retrieval info: PRIVATE: MIFfilename STRING "E:/max2work/vhdl/sine10f.mif"
-- Retrieval info: PRIVATE: INIT_FILE_LAYOUT STRING "PORT_A"
-- Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "0"
-- Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Stratix"
-- Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Stratix"
-- Retrieval info: CONSTANT: WIDTH_A NUMERIC "10"
-- Retrieval info: CONSTANT: WIDTHAD_A NUMERIC "7"
-- Retrieval info: CONSTANT: NUMWORDS_A NUMERIC "128"
-- Retrieval info: CONSTANT: OPERATION_MODE STRING "ROM"
-- Retrieval info: CONSTANT: OUTDATA_REG_A STRING "CLOCK0"
-- Retrieval info: CONSTANT: ADDRESS_ACLR_A STRING "NONE"
-- Retrieval info: CONSTANT: OUTDATA_ACLR_A STRING "NONE"
-- Retrieval info: CONSTANT: WIDTH_BYTEENA_A NUMERIC "1"
-- Retrieval info: CONSTANT: INIT_FILE STRING "E:/max2work/vhdl/sine10f.mif"
-- Retrieval info: CONSTANT: LPM_HINT STRING "ENABLE_RUNTIME_MOD=NO"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "altsyncram"
-- Retrieval info: USED_PORT: address 0 0 7 0 INPUT NODEFVAL address[6..0]
-- Retrieval info: USED_PORT: q 0 0 10 0 OUTPUT NODEFVAL q[9..0]
-- Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL clock
-- Retrieval info: CONNECT: @address_a 0 0 7 0 address 0 0 7 0
-- Retrieval info: CONNECT: q 0 0 10 0 @q_a 0 0 10 0
-- Retrieval info: CONNECT: @clock0 0 0 0 0 clock 0 0 0 0
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: GEN_FILE: TYPE_NORMAL pwmsine.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL pwmsine.inc TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL pwmsine.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL pwmsine.bsf TRUE FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL pwmsine_inst.vhd TRUE
