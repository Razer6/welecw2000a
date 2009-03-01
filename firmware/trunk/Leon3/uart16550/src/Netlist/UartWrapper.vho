-- Copyright (C) 1991-2008 Altera Corporation
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
-- PROGRAM "Quartus II"
-- VERSION "Version 8.0 Build 231 07/10/2008 Service Pack 1 SJ Web Edition"

-- DATE "10/28/2008 19:22:59"

-- 
-- Device: Altera EP2C35U484C8 Package UFBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY IEEE, cycloneii;
USE IEEE.std_logic_1164.all;
USE cycloneii.cycloneii_components.all;

ENTITY 	uart_top IS
    PORT (
	wb_clk_i : IN std_logic;
	wb_rst_i : IN std_logic;
	wb_adr_i : IN std_logic_vector(4 DOWNTO 0);
	wb_dat_i : IN std_logic_vector(31 DOWNTO 0);
	wb_dat_o : OUT std_logic_vector(31 DOWNTO 0);
	wb_we_i : IN std_logic;
	wb_stb_i : IN std_logic;
	wb_cyc_i : IN std_logic;
	wb_ack_o : OUT std_logic;
	wb_sel_i : IN std_logic_vector(3 DOWNTO 0);
	int_o : OUT std_logic;
	stx_pad_o : OUT std_logic;
	srx_pad_i : IN std_logic;
	rts_pad_o : OUT std_logic;
	cts_pad_i : IN std_logic;
	dtr_pad_o : OUT std_logic;
	dsr_pad_i : IN std_logic;
	ri_pad_i : IN std_logic;
	dcd_pad_i : IN std_logic
	);
END uart_top;

ARCHITECTURE structure OF uart_top IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_wb_clk_i : std_logic;
SIGNAL ww_wb_rst_i : std_logic;
SIGNAL ww_wb_adr_i : std_logic_vector(4 DOWNTO 0);
SIGNAL ww_wb_dat_i : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_wb_dat_o : std_logic_vector(31 DOWNTO 0);
SIGNAL ww_wb_we_i : std_logic;
SIGNAL ww_wb_stb_i : std_logic;
SIGNAL ww_wb_cyc_i : std_logic;
SIGNAL ww_wb_ack_o : std_logic;
SIGNAL ww_wb_sel_i : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_int_o : std_logic;
SIGNAL ww_stx_pad_o : std_logic;
SIGNAL ww_srx_pad_i : std_logic;
SIGNAL ww_rts_pad_o : std_logic;
SIGNAL ww_cts_pad_i : std_logic;
SIGNAL ww_dtr_pad_o : std_logic;
SIGNAL ww_dsr_pad_i : std_logic;
SIGNAL ww_ri_pad_i : std_logic;
SIGNAL ww_dcd_pad_i : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAIN_bus\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTAADDR_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBADDR_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTADATAIN_bus\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTAADDR_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBADDR_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBDATAOUT_bus\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \wb_clk_i~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \wb_rst_i~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|transmitter|Add1~67_combout\ : std_logic;
SIGNAL \regs|transmitter|Add1~70\ : std_logic;
SIGNAL \regs|transmitter|Add1~71_combout\ : std_logic;
SIGNAL \regs|transmitter|Add1~72\ : std_logic;
SIGNAL \regs|transmitter|Add1~73_combout\ : std_logic;
SIGNAL \regs|receiver|counter_b[1]~227_combout\ : std_logic;
SIGNAL \regs|receiver|counter_b[6]~238\ : std_logic;
SIGNAL \regs|receiver|counter_b[7]~239_combout\ : std_logic;
SIGNAL \regs|receiver|counter_t[3]~278_combout\ : std_logic;
SIGNAL \regs|transmitter|shift_out[0]~81_combout\ : std_logic;
SIGNAL \regs|transmitter|shift_out[4]~85_combout\ : std_logic;
SIGNAL \regs|transmitter|shift_out[3]~84_combout\ : std_logic;
SIGNAL \regs|transmitter|shift_out[1]~82_combout\ : std_logic;
SIGNAL \regs|transmitter|shift_out[2]~83_combout\ : std_logic;
SIGNAL \regs|transmitter|shift_out[5]~86_combout\ : std_logic;
SIGNAL \regs|dlc[1]~258_combout\ : std_logic;
SIGNAL \regs|dlc[5]~266_combout\ : std_logic;
SIGNAL \regs|dlc[11]~278_combout\ : std_logic;
SIGNAL \regs|dlc[14]~285\ : std_logic;
SIGNAL \regs|dlc[15]~286_combout\ : std_logic;
SIGNAL \regs|Mux7~333_combout\ : std_logic;
SIGNAL \regs|lsr0r~regout\ : std_logic;
SIGNAL \regs|Mux7~342_combout\ : std_logic;
SIGNAL \regs|Mux7~343_combout\ : std_logic;
SIGNAL \regs|Mux6~100_combout\ : std_logic;
SIGNAL \regs|lsr4r~regout\ : std_logic;
SIGNAL \regs|Mux3~107_combout\ : std_logic;
SIGNAL \regs|Mux3~108_combout\ : std_logic;
SIGNAL \regs|lsr6r~regout\ : std_logic;
SIGNAL \wb_interface|Mux25~211_combout\ : std_logic;
SIGNAL \dbg|Equal0~39_combout\ : std_logic;
SIGNAL \regs|lsr_mask_d~regout\ : std_logic;
SIGNAL \regs|rda_int_pnd~regout\ : std_logic;
SIGNAL \regs|lsr0r~132_combout\ : std_logic;
SIGNAL \regs|lsr0r~134_combout\ : std_logic;
SIGNAL \regs|lsr0~combout\ : std_logic;
SIGNAL \regs|lsr0_d~regout\ : std_logic;
SIGNAL \regs|lsr0r~135_combout\ : std_logic;
SIGNAL \regs|lsr5~73_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_out~1052_combout\ : std_logic;
SIGNAL \regs|iir~318_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux2~358_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[1][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux62~61_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[13][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux62~62_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[0][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux62~65_combout\ : std_logic;
SIGNAL \regs|lsr2_d~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[11][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[6][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[3][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux61~101_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[14][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux61~102_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux61~103_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[13][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux61~104_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[4][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[8][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[0][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux61~105_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[12][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux61~106_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux61~107_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux61~108_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux61~109_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux61~110_combout\ : std_logic;
SIGNAL \regs|lsr4_d~regout\ : std_logic;
SIGNAL \regs|lsr4r~36_combout\ : std_logic;
SIGNAL \regs|lsr5_d~regout\ : std_logic;
SIGNAL \regs|lsr6_d~regout\ : std_logic;
SIGNAL \regs|lsr6r~68_combout\ : std_logic;
SIGNAL \regs|lsr7~553_combout\ : std_logic;
SIGNAL \regs|lsr7~557_combout\ : std_logic;
SIGNAL \regs|lsr7~558_combout\ : std_logic;
SIGNAL \regs|lsr7~559_combout\ : std_logic;
SIGNAL \regs|lsr7~560_combout\ : std_logic;
SIGNAL \regs|lsr7~561_combout\ : std_logic;
SIGNAL \regs|lsr7~564_combout\ : std_logic;
SIGNAL \regs|receiver|Mux6~736_combout\ : std_logic;
SIGNAL \regs|receiver|Mux6~738_combout\ : std_logic;
SIGNAL \regs|receiver|Mux6~739_combout\ : std_logic;
SIGNAL \regs|receiver|Mux5~711_combout\ : std_logic;
SIGNAL \regs|receiver|Mux5~712_combout\ : std_logic;
SIGNAL \regs|receiver|Mux5~713_combout\ : std_logic;
SIGNAL \regs|receiver|Mux4~1013_combout\ : std_logic;
SIGNAL \regs|receiver|Mux3~359_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|overrun~58_combout\ : std_logic;
SIGNAL \regs|lsr_mask_condition~combout\ : std_logic;
SIGNAL \regs|rda_int_d~regout\ : std_logic;
SIGNAL \regs|rda_int_pnd~311_combout\ : std_logic;
SIGNAL \regs|rda_int_pnd~312_combout\ : std_logic;
SIGNAL \regs|LessThan0~104_combout\ : std_logic;
SIGNAL \regs|rda_int_pnd~313_combout\ : std_logic;
SIGNAL \regs|rda_int_pnd~314_combout\ : std_logic;
SIGNAL \regs|thre_int_pnd~118_combout\ : std_logic;
SIGNAL \regs|thre_int_pnd~119_combout\ : std_logic;
SIGNAL \regs|ti_int~99_combout\ : std_logic;
SIGNAL \regs|ti_int_d~regout\ : std_logic;
SIGNAL \regs|rls_int~40_combout\ : std_logic;
SIGNAL \regs|transmitter|parity_xor~regout\ : std_logic;
SIGNAL \regs|transmitter|bit_out~1055_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_out~1056_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_out~1057_combout\ : std_logic;
SIGNAL \regs|WideOr1~105_combout\ : std_logic;
SIGNAL \regs|WideOr1~108_combout\ : std_logic;
SIGNAL \regs|WideOr0~112_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux17~147_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_counter[2]~660_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_counter[0]~663_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|overrun~59_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~272_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[9][2]~6640_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~273_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~273_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[5][0]~6644_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~274_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~274_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[1][1]~6647_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~275_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~278_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~278_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[2][2]~6659_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~279_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~280_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~280_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~281_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[4][2]~6667_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~282_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~282_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~283_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[12][0]~6674_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~285_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[11][0]~6680_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~286_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~287_combout\ : std_logic;
SIGNAL \regs|receiver|rframing_error~195_combout\ : std_logic;
SIGNAL \regs|receiver|rframing_error~196_combout\ : std_logic;
SIGNAL \regs|receiver|Equal2~32_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~18_regout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~824_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~26_regout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~825_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~24_regout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~826_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~20_regout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~827_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~22_regout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~828_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux0~38_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux0~39_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~28_regout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~829_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~30_regout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~830_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~831_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux0~40_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux0~41_combout\ : std_logic;
SIGNAL \regs|Add0~930_combout\ : std_logic;
SIGNAL \regs|Add0~936_combout\ : std_logic;
SIGNAL \regs|Add0~938_combout\ : std_logic;
SIGNAL \regs|Add0~940_combout\ : std_logic;
SIGNAL \regs|Add0~942_combout\ : std_logic;
SIGNAL \regs|Add0~944_combout\ : std_logic;
SIGNAL \regs|receiver|Selector23~15_combout\ : std_logic;
SIGNAL \regs|receiver|rparity_error~regout\ : std_logic;
SIGNAL \regs|receiver|rf_data_in[0]~632_combout\ : std_logic;
SIGNAL \regs|receiver|Selector10~14_combout\ : std_logic;
SIGNAL \regs|receiver|rf_data_in[2]~635_combout\ : std_logic;
SIGNAL \regs|receiver|rshift[6]~1509_combout\ : std_logic;
SIGNAL \regs|receiver|rparity~regout\ : std_logic;
SIGNAL \regs|receiver|rparity_xor~regout\ : std_logic;
SIGNAL \regs|receiver|Selector12~416_combout\ : std_logic;
SIGNAL \regs|receiver|Selector12~417_combout\ : std_logic;
SIGNAL \regs|receiver|rparity_error~399_combout\ : std_logic;
SIGNAL \regs|receiver|rparity_error~400_combout\ : std_logic;
SIGNAL \regs|receiver|rparity~156_combout\ : std_logic;
SIGNAL \regs|receiver|WideXor0~53_combout\ : std_logic;
SIGNAL \regs|receiver|WideXor0~54_combout\ : std_logic;
SIGNAL \regs|receiver|WideXor0~55_combout\ : std_logic;
SIGNAL \regs|receiver|rparity_xor~29_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|bottom~850_combout\ : std_logic;
SIGNAL \regs|lsr6~combout\ : std_logic;
SIGNAL \regs|receiver|rparity~157_combout\ : std_logic;
SIGNAL \regs|receiver|rcounter16[3]~434_combout\ : std_logic;
SIGNAL \regs|fcr[0]~37_combout\ : std_logic;
SIGNAL \regs|delayed_modem_signals[0]~8_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram_0_bypass[7]~feeder_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[13]~feeder_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[15]~feeder_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[1][1]~feeder_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[0][1]~feeder_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[3]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[6]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[9]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[7]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[26]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[3]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[13]~feeder_combout\ : std_logic;
SIGNAL \wb_clk_i~combout\ : std_logic;
SIGNAL \wb_clk_i~clkctrl_outclk\ : std_logic;
SIGNAL \regs|transmitter|Add1~65_combout\ : std_logic;
SIGNAL \wb_rst_i~combout\ : std_logic;
SIGNAL \wb_rst_i~clkctrl_outclk\ : std_logic;
SIGNAL \wb_interface|Mux32~225_combout\ : std_logic;
SIGNAL \wb_interface|Mux32~226_combout\ : std_logic;
SIGNAL \wb_interface|Mux37~25_combout\ : std_logic;
SIGNAL \wb_interface|Mux37~26_combout\ : std_logic;
SIGNAL \wb_interface|wb_adr_int[0]~64_combout\ : std_logic;
SIGNAL \wb_interface|wb_adr_int[1]~63_combout\ : std_logic;
SIGNAL \regs|always4~0_combout\ : std_logic;
SIGNAL \regs|transmitter|WideNor1~combout\ : std_logic;
SIGNAL \regs|transmitter|Mux3~230_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[30]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|Mux33~25_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[14]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|Mux33~26_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[23]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[31]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|Mux32~227_combout\ : std_logic;
SIGNAL \wb_interface|Mux32~228_combout\ : std_logic;
SIGNAL \wb_stb_i~combout\ : std_logic;
SIGNAL \wb_interface|wb_stb_is~regout\ : std_logic;
SIGNAL \wb_cyc_i~combout\ : std_logic;
SIGNAL \wb_interface|wb_cyc_is~regout\ : std_logic;
SIGNAL \wb_interface|we_o~11_combout\ : std_logic;
SIGNAL \wb_we_i~combout\ : std_logic;
SIGNAL \wb_interface|wb_we_is~regout\ : std_logic;
SIGNAL \regs|always7~19_combout\ : std_logic;
SIGNAL \regs|always4~28_combout\ : std_logic;
SIGNAL \regs|always4~29_combout\ : std_logic;
SIGNAL \regs|dl[0]~298_combout\ : std_logic;
SIGNAL \regs|dl[8]~299_combout\ : std_logic;
SIGNAL \regs|WideOr1~109_combout\ : std_logic;
SIGNAL \regs|start_dlc~regout\ : std_logic;
SIGNAL \wb_interface|Mux35~25_combout\ : std_logic;
SIGNAL \wb_interface|Mux35~26_combout\ : std_logic;
SIGNAL \regs|Add0~941_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[5]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|Mux34~25_combout\ : std_logic;
SIGNAL \wb_interface|Mux34~26_combout\ : std_logic;
SIGNAL \regs|Add0~934_combout\ : std_logic;
SIGNAL \regs|Add0~933_combout\ : std_logic;
SIGNAL \regs|dlc[0]~256_combout\ : std_logic;
SIGNAL \regs|Add0~929_combout\ : std_logic;
SIGNAL \regs|dlc[0]~257\ : std_logic;
SIGNAL \regs|dlc[1]~259\ : std_logic;
SIGNAL \regs|dlc[2]~260_combout\ : std_logic;
SIGNAL \regs|Add0~931_combout\ : std_logic;
SIGNAL \regs|dlc[2]~261\ : std_logic;
SIGNAL \regs|dlc[3]~262_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[19]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|Mux36~25_combout\ : std_logic;
SIGNAL \wb_interface|Mux36~26_combout\ : std_logic;
SIGNAL \regs|Add0~932_combout\ : std_logic;
SIGNAL \regs|dlc[3]~263\ : std_logic;
SIGNAL \regs|dlc[4]~265\ : std_logic;
SIGNAL \regs|dlc[5]~267\ : std_logic;
SIGNAL \regs|dlc[6]~268_combout\ : std_logic;
SIGNAL \regs|Add0~935_combout\ : std_logic;
SIGNAL \regs|dlc[6]~269\ : std_logic;
SIGNAL \regs|dlc[7]~271\ : std_logic;
SIGNAL \regs|dlc[8]~272_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[8]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[16]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|Mux39~25_combout\ : std_logic;
SIGNAL \wb_interface|Mux39~26_combout\ : std_logic;
SIGNAL \regs|Add0~937_combout\ : std_logic;
SIGNAL \regs|dlc[8]~273\ : std_logic;
SIGNAL \regs|dlc[9]~275\ : std_logic;
SIGNAL \regs|dlc[10]~276_combout\ : std_logic;
SIGNAL \regs|Add0~939_combout\ : std_logic;
SIGNAL \regs|dlc[10]~277\ : std_logic;
SIGNAL \regs|dlc[11]~279\ : std_logic;
SIGNAL \regs|dlc[12]~281\ : std_logic;
SIGNAL \regs|dlc[13]~282_combout\ : std_logic;
SIGNAL \regs|Add0~943_combout\ : std_logic;
SIGNAL \regs|dlc[13]~283\ : std_logic;
SIGNAL \regs|dlc[14]~284_combout\ : std_logic;
SIGNAL \regs|dlc[12]~280_combout\ : std_logic;
SIGNAL \regs|WideOr0~115_combout\ : std_logic;
SIGNAL \regs|dlc[7]~270_combout\ : std_logic;
SIGNAL \regs|dlc[4]~264_combout\ : std_logic;
SIGNAL \regs|WideOr0~113_combout\ : std_logic;
SIGNAL \regs|dlc[9]~274_combout\ : std_logic;
SIGNAL \regs|WideOr0~114_combout\ : std_logic;
SIGNAL \regs|WideOr0~116_combout\ : std_logic;
SIGNAL \regs|WideOr1~106_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[1]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_is[17]~feeder_combout\ : std_logic;
SIGNAL \wb_interface|Mux38~25_combout\ : std_logic;
SIGNAL \wb_interface|Mux38~26_combout\ : std_logic;
SIGNAL \regs|WideOr1~107_combout\ : std_logic;
SIGNAL \regs|always29~0_combout\ : std_logic;
SIGNAL \regs|enable~regout\ : std_logic;
SIGNAL \regs|transmitter|Mux5~207_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux5~208_combout\ : std_logic;
SIGNAL \regs|transmitter|tf_pop~regout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|Add1~111_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|count[0]~331\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|count[1]~334\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|count[2]~336\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|count[3]~338\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|count[4]~339_combout\ : std_logic;
SIGNAL \regs|always6~11_combout\ : std_logic;
SIGNAL \regs|tx_reset~32_combout\ : std_logic;
SIGNAL \regs|tx_reset~regout\ : std_logic;
SIGNAL \regs|fifo_write~23_combout\ : std_logic;
SIGNAL \regs|tf_push~regout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|count[3]~332_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|count[3]~337_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|count[2]~335_combout\ : std_logic;
SIGNAL \regs|lsr5~74_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux2~359_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux2~360_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux16~69_combout\ : std_logic;
SIGNAL \regs|transmitter|counter[2]~594_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux16~70_combout\ : std_logic;
SIGNAL \regs|transmitter|counter[1]~595_combout\ : std_logic;
SIGNAL \regs|transmitter|Add1~66\ : std_logic;
SIGNAL \regs|transmitter|Add1~68\ : std_logic;
SIGNAL \regs|transmitter|Add1~69_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux18~81_combout\ : std_logic;
SIGNAL \regs|transmitter|WideNor1~23_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux20~65_combout\ : std_logic;
SIGNAL \regs|transmitter|Equal1~36_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_counter[0]~661_combout\ : std_logic;
SIGNAL \regs|transmitter|parity_xor~22_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_counter[2]~662_combout\ : std_logic;
SIGNAL \regs|transmitter|LessThan0~50_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_counter[0]~664_combout\ : std_logic;
SIGNAL \regs|lcr[0]~167_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_counter[0]~665_combout\ : std_logic;
SIGNAL \regs|transmitter|Add0~49_combout\ : std_logic;
SIGNAL \regs|lcr[1]~168_combout\ : std_logic;
SIGNAL \regs|lcr[1]~_wirecell_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux4~494_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux4~495_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux4~493_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux4~496_combout\ : std_logic;
SIGNAL \dbg|Equal0~38_combout\ : std_logic;
SIGNAL \wb_interface|Mux31~215_combout\ : std_logic;
SIGNAL \regs|always8~0_combout\ : std_logic;
SIGNAL \regs|msi_reset~17_combout\ : std_logic;
SIGNAL \regs|msi_reset~regout\ : std_logic;
SIGNAL \cts_pad_i~combout\ : std_logic;
SIGNAL \regs|msr~172_combout\ : std_logic;
SIGNAL \regs|msr_read~19_combout\ : std_logic;
SIGNAL \regs|Mux7~344_combout\ : std_logic;
SIGNAL \regs|Mux7~345_combout\ : std_logic;
SIGNAL \regs|receiver|counter_b[0]~224_combout\ : std_logic;
SIGNAL \~GND~combout\ : std_logic;
SIGNAL \srx_pad_i~combout\ : std_logic;
SIGNAL \regs|i_uart_sync_flops|flop_0[0]~2_combout\ : std_logic;
SIGNAL \regs|always7~0_combout\ : std_logic;
SIGNAL \regs|serial_in~34_combout\ : std_logic;
SIGNAL \regs|receiver|counter_b[3]~231_combout\ : std_logic;
SIGNAL \regs|receiver|Decoder4~13_combout\ : std_logic;
SIGNAL \regs|receiver|Equal0~133_combout\ : std_logic;
SIGNAL \regs|receiver|counter_b[4]~226_combout\ : std_logic;
SIGNAL \regs|receiver|counter_b[0]~225\ : std_logic;
SIGNAL \regs|receiver|counter_b[1]~228\ : std_logic;
SIGNAL \regs|receiver|counter_b[2]~229_combout\ : std_logic;
SIGNAL \regs|receiver|counter_b[2]~230\ : std_logic;
SIGNAL \regs|receiver|counter_b[3]~232\ : std_logic;
SIGNAL \regs|receiver|counter_b[4]~234\ : std_logic;
SIGNAL \regs|receiver|counter_b[5]~235_combout\ : std_logic;
SIGNAL \regs|receiver|WideOr6~23_combout\ : std_logic;
SIGNAL \regs|receiver|counter_b[5]~236\ : std_logic;
SIGNAL \regs|receiver|counter_b[6]~237_combout\ : std_logic;
SIGNAL \regs|receiver|WideOr5~15_combout\ : std_logic;
SIGNAL \regs|receiver|counter_b[4]~233_combout\ : std_logic;
SIGNAL \regs|receiver|WideOr7~30_combout\ : std_logic;
SIGNAL \regs|receiver|Equal0~134_combout\ : std_logic;
SIGNAL \regs|receiver|rparity~155_combout\ : std_logic;
SIGNAL \regs|receiver|rbit_counter[2]~375_combout\ : std_logic;
SIGNAL \regs|receiver|rbit_counter[2]~376_combout\ : std_logic;
SIGNAL \regs|receiver|Equal3~33_combout\ : std_logic;
SIGNAL \regs|receiver|rbit_counter[0]~377_combout\ : std_logic;
SIGNAL \regs|receiver|rbit_counter[0]~378_combout\ : std_logic;
SIGNAL \regs|receiver|Add1~49_combout\ : std_logic;
SIGNAL \regs|receiver|Mux4~1009_combout\ : std_logic;
SIGNAL \regs|receiver|Mux4~1014_combout\ : std_logic;
SIGNAL \regs|receiver|rcounter16[3]~435_combout\ : std_logic;
SIGNAL \regs|receiver|Mux10~46_combout\ : std_logic;
SIGNAL \regs|receiver|Mux3~358_combout\ : std_logic;
SIGNAL \regs|receiver|Mux3~357_combout\ : std_logic;
SIGNAL \regs|receiver|Mux3~360_combout\ : std_logic;
SIGNAL \regs|receiver|Mux9~40_combout\ : std_logic;
SIGNAL \regs|receiver|Equal1~59_combout\ : std_logic;
SIGNAL \regs|receiver|rframing_error~197_combout\ : std_logic;
SIGNAL \regs|receiver|rframing_error~regout\ : std_logic;
SIGNAL \regs|receiver|Mux6~737_combout\ : std_logic;
SIGNAL \regs|receiver|rcounter16[3]~432_combout\ : std_logic;
SIGNAL \regs|receiver|rcounter16[3]~433_combout\ : std_logic;
SIGNAL \regs|receiver|Mux8~52_combout\ : std_logic;
SIGNAL \regs|receiver|Mux7~52_combout\ : std_logic;
SIGNAL \regs|receiver|Equal2~31_combout\ : std_logic;
SIGNAL \regs|receiver|Decoder1~146_combout\ : std_logic;
SIGNAL \regs|receiver|Mux4~1010_combout\ : std_logic;
SIGNAL \regs|receiver|Mux4~1011_combout\ : std_logic;
SIGNAL \regs|receiver|Mux4~1012_combout\ : std_logic;
SIGNAL \regs|receiver|Mux4~1015_combout\ : std_logic;
SIGNAL \regs|receiver|Mux6~741_combout\ : std_logic;
SIGNAL \regs|receiver|Mux6~734_combout\ : std_logic;
SIGNAL \regs|receiver|Mux6~735_combout\ : std_logic;
SIGNAL \regs|receiver|Mux6~740_combout\ : std_logic;
SIGNAL \regs|receiver|Mux5~714_combout\ : std_logic;
SIGNAL \regs|receiver|rshift[7]~1505_combout\ : std_logic;
SIGNAL \regs|receiver|Mux5~715_combout\ : std_logic;
SIGNAL \regs|receiver|Selector7~42_combout\ : std_logic;
SIGNAL \regs|receiver|Decoder1~147_combout\ : std_logic;
SIGNAL \regs|receiver|rf_data_in[3]~631_combout\ : std_logic;
SIGNAL \regs|rx_reset~30_combout\ : std_logic;
SIGNAL \regs|rx_reset~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|top~115_combout\ : std_logic;
SIGNAL \regs|receiver|rf_push~197_combout\ : std_logic;
SIGNAL \regs|receiver|Selector11~34_combout\ : std_logic;
SIGNAL \regs|receiver|rf_push~198_combout\ : std_logic;
SIGNAL \regs|receiver|rf_push~199_combout\ : std_logic;
SIGNAL \regs|receiver|rf_push~regout\ : std_logic;
SIGNAL \regs|receiver|rf_push_q~regout\ : std_logic;
SIGNAL \regs|receiver|rf_push_pulse~combout\ : std_logic;
SIGNAL \wb_interface|wb_ack_o~4_combout\ : std_logic;
SIGNAL \wb_interface|wb_ack_o~regout\ : std_logic;
SIGNAL \wb_interface|wbstate.10~feeder_combout\ : std_logic;
SIGNAL \wb_interface|wbstate.10~regout\ : std_logic;
SIGNAL \wb_interface|Selector0~32_combout\ : std_logic;
SIGNAL \wb_interface|wbstate.00~regout\ : std_logic;
SIGNAL \wb_interface|wre~25_combout\ : std_logic;
SIGNAL \wb_interface|wre~regout\ : std_logic;
SIGNAL \wb_interface|re_o~combout\ : std_logic;
SIGNAL \regs|lsr_mask_condition~36_combout\ : std_logic;
SIGNAL \regs|fifo_read~combout\ : std_logic;
SIGNAL \regs|rf_pop~49_combout\ : std_logic;
SIGNAL \regs|rf_pop~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|count[0]~310_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|count[2]~315_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|count[1]~313_combout\ : std_logic;
SIGNAL \regs|lsr0r~131_combout\ : std_logic;
SIGNAL \regs|lsr0~14_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|count[3]~312_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|count[0]~311\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|count[1]~314\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|count[2]~316\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|count[3]~317_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|count[3]~318\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|count[4]~319_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|top[3]~116_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Add0~104_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Add0~103_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~144_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Add0~105_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~145_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~16_regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~15feeder_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~15_regout\ : std_logic;
SIGNAL \regs|Mux7~337_combout\ : std_logic;
SIGNAL \regs|Mux7~338_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|bottom~848_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|bottom~847_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Add3~104_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|bottom~849_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Add3~103_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|bottom~846_combout\ : std_logic;
SIGNAL \regs|receiver|rshift[6]~1506_combout\ : std_logic;
SIGNAL \regs|receiver|rshift~1514_combout\ : std_logic;
SIGNAL \regs|receiver|rshift[7]~1515_combout\ : std_logic;
SIGNAL \regs|receiver|rshift[7]~1516_combout\ : std_logic;
SIGNAL \regs|receiver|rshift[7]~1517_combout\ : std_logic;
SIGNAL \regs|receiver|rshift[6]~1510_combout\ : std_logic;
SIGNAL \regs|receiver|rshift[6]~1511_combout\ : std_logic;
SIGNAL \regs|receiver|rshift[6]~1512_combout\ : std_logic;
SIGNAL \regs|receiver|rshift[6]~1513_combout\ : std_logic;
SIGNAL \regs|receiver|Mux1~213_combout\ : std_logic;
SIGNAL \regs|receiver|Mux1~214_combout\ : std_logic;
SIGNAL \regs|receiver|rshift[0]~1507_combout\ : std_logic;
SIGNAL \regs|receiver|rshift~1508_combout\ : std_logic;
SIGNAL \regs|receiver|Selector20~15_combout\ : std_logic;
SIGNAL \regs|receiver|Selector21~15_combout\ : std_logic;
SIGNAL \regs|receiver|Selector22~15_combout\ : std_logic;
SIGNAL \regs|receiver|Selector6~42_combout\ : std_logic;
SIGNAL \regs|receiver|Selector5~42_combout\ : std_logic;
SIGNAL \regs|receiver|Selector4~42_combout\ : std_logic;
SIGNAL \regs|receiver|Selector3~42_combout\ : std_logic;
SIGNAL \regs|receiver|Selector2~42_combout\ : std_logic;
SIGNAL \regs|receiver|Selector1~42_combout\ : std_logic;
SIGNAL \regs|receiver|Selector0~42_combout\ : std_logic;
SIGNAL \regs|Mux7~339_combout\ : std_logic;
SIGNAL \regs|Mux7~346_combout\ : std_logic;
SIGNAL \regs|Mux7~347_combout\ : std_logic;
SIGNAL \regs|Mux7~348_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_o[2]~538_combout\ : std_logic;
SIGNAL \wb_interface|Mux31~219_combout\ : std_logic;
SIGNAL \wb_interface|Mux31~217_combout\ : std_logic;
SIGNAL \regs|lsr_mask_condition~35_combout\ : std_logic;
SIGNAL \regs|lsr_mask~combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|overrun~60_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|overrun~regout\ : std_logic;
SIGNAL \regs|lsr1_d~feeder_combout\ : std_logic;
SIGNAL \regs|lsr1_d~regout\ : std_logic;
SIGNAL \regs|lsr1r~34_combout\ : std_logic;
SIGNAL \regs|lsr1r~regout\ : std_logic;
SIGNAL \wb_interface|Mux30~199_combout\ : std_logic;
SIGNAL \dsr_pad_i~combout\ : std_logic;
SIGNAL \regs|delayed_modem_signals[1]~9_combout\ : std_logic;
SIGNAL \regs|msr~173_combout\ : std_logic;
SIGNAL \regs|Mux7~341_combout\ : std_logic;
SIGNAL \regs|Mux6~101_combout\ : std_logic;
SIGNAL \regs|Mux7~334_combout\ : std_logic;
SIGNAL \regs|Mux7~335_combout\ : std_logic;
SIGNAL \regs|Mux6~97_combout\ : std_logic;
SIGNAL \regs|Mux6~98_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~18_regout\ : std_logic;
SIGNAL \regs|Mux6~99_combout\ : std_logic;
SIGNAL \regs|Mux6~102_combout\ : std_logic;
SIGNAL \regs|Mux6~103_combout\ : std_logic;
SIGNAL \regs|Mux6~104_combout\ : std_logic;
SIGNAL \wb_interface|Mux30~200_combout\ : std_logic;
SIGNAL \wb_interface|Mux29~199_combout\ : std_logic;
SIGNAL \regs|ier[0]~62_combout\ : std_logic;
SIGNAL \regs|receiver|counter_t[0]~271_combout\ : std_logic;
SIGNAL \regs|receiver|always4~1_combout\ : std_logic;
SIGNAL \regs|receiver|counter_t[1]~273_combout\ : std_logic;
SIGNAL \regs|receiver|counter_t[0]~272\ : std_logic;
SIGNAL \regs|receiver|counter_t[1]~274_combout\ : std_logic;
SIGNAL \regs|receiver|counter_t[1]~275\ : std_logic;
SIGNAL \regs|receiver|counter_t[2]~276_combout\ : std_logic;
SIGNAL \regs|receiver|counter_t[2]~277\ : std_logic;
SIGNAL \regs|receiver|counter_t[3]~279\ : std_logic;
SIGNAL \regs|receiver|counter_t[4]~280_combout\ : std_logic;
SIGNAL \regs|receiver|counter_t[4]~281\ : std_logic;
SIGNAL \regs|receiver|counter_t[5]~283\ : std_logic;
SIGNAL \regs|receiver|counter_t[6]~285\ : std_logic;
SIGNAL \regs|receiver|counter_t[7]~286_combout\ : std_logic;
SIGNAL \regs|receiver|counter_t[7]~287\ : std_logic;
SIGNAL \regs|receiver|counter_t[8]~289\ : std_logic;
SIGNAL \regs|receiver|counter_t[9]~290_combout\ : std_logic;
SIGNAL \regs|receiver|counter_t[5]~282_combout\ : std_logic;
SIGNAL \regs|receiver|counter_t[6]~284_combout\ : std_logic;
SIGNAL \regs|ti_int~100_combout\ : std_logic;
SIGNAL \regs|receiver|counter_t[8]~288_combout\ : std_logic;
SIGNAL \regs|ti_int~101_combout\ : std_logic;
SIGNAL \regs|ti_int~combout\ : std_logic;
SIGNAL \regs|ti_int_pnd~87_combout\ : std_logic;
SIGNAL \regs|ti_int_pnd~88_combout\ : std_logic;
SIGNAL \regs|ti_int_pnd~regout\ : std_logic;
SIGNAL \regs|rls_int_pnd~90_combout\ : std_logic;
SIGNAL \regs|rls_int~41_combout\ : std_logic;
SIGNAL \regs|rls_int_d~regout\ : std_logic;
SIGNAL \regs|rls_int_pnd~91_combout\ : std_logic;
SIGNAL \regs|rls_int_pnd~regout\ : std_logic;
SIGNAL \regs|fcr[1]~38_combout\ : std_logic;
SIGNAL \regs|rda_int~269_combout\ : std_logic;
SIGNAL \regs|rda_int~270_combout\ : std_logic;
SIGNAL \regs|rda_int~271_combout\ : std_logic;
SIGNAL \regs|rda_int~272_combout\ : std_logic;
SIGNAL \regs|iir~316_combout\ : std_logic;
SIGNAL \regs|receiver|Selector9~42_combout\ : std_logic;
SIGNAL \regs|lsr0r~133_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo~6639_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[15][0]~6686_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~287_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[15][0]~6685_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[15][0]~6687_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[15][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~285_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[11][0]~6679_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[11][0]~6681_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[11][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~286_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[3][2]~6683_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[3][2]~6682_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[3][2]~6684_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[3][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux62~68_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux62~69_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~277_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[10][2]~6656_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~277_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[10][2]~6655_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[10][2]~6657_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[10][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[2][2]~6658_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[2][2]~6660_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[2][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux62~63_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~276_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[6][1]~6652_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~276_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[6][1]~6653_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[6][1]~6654_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[6][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[14][2]~6662_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~279_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[14][2]~6661_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[14][2]~6663_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[14][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux62~64_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[8][0]~6665_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[8][0]~6664_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[8][0]~6666_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[8][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~283_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[12][0]~6673_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[12][0]~6675_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[12][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux62~66_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux62~67_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux62~70_combout\ : std_logic;
SIGNAL \regs|lsr2r~34_combout\ : std_logic;
SIGNAL \regs|lsr2r~regout\ : std_logic;
SIGNAL \regs|Mux7~340_combout\ : std_logic;
SIGNAL \regs|Mux5~88_combout\ : std_logic;
SIGNAL \regs|Mux5~89_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~20_regout\ : std_logic;
SIGNAL \regs|Mux5~85_combout\ : std_logic;
SIGNAL \regs|Mux5~86_combout\ : std_logic;
SIGNAL \regs|Mux5~87_combout\ : std_logic;
SIGNAL \regs|Mux5~90_combout\ : std_logic;
SIGNAL \regs|Mux5~91_combout\ : std_logic;
SIGNAL \regs|always4~27_combout\ : std_logic;
SIGNAL \regs|Mux5~92_combout\ : std_logic;
SIGNAL \wb_interface|Mux29~200_combout\ : std_logic;
SIGNAL \regs|receiver|rf_data_in[0]~633_combout\ : std_logic;
SIGNAL \regs|receiver|rf_data_in[0]~634_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo~6688_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[14][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[12][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux63~68_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[13][2]~6650_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~275_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[13][2]~6649_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[13][2]~6651_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[13][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[15][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux63~69_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder1~284_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[7][0]~6676_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~284_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[7][0]~6677_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[7][0]~6678_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[7][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~281_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[4][2]~6668_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[4][2]~6669_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[4][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[5][0]~6643_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[5][0]~6645_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[5][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux63~63_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux63~64_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[0][1]~6670_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[0][1]~6671_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[0][1]~6672_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[0][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[1][1]~6646_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[1][1]~6648_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[1][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux63~65_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[2][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux63~66_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux63~67_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Decoder0~272_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[9][2]~6641_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[9][2]~6642_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[9][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[8][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[10][0]~feeder_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[10][0]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux63~61_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux63~62_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|Mux63~70_combout\ : std_logic;
SIGNAL \regs|lsr3_d~regout\ : std_logic;
SIGNAL \regs|lsr3r~34_combout\ : std_logic;
SIGNAL \regs|lsr3r~regout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|count[0]~330_combout\ : std_logic;
SIGNAL \wb_interface|Mux28~199_combout\ : std_logic;
SIGNAL \regs|iir~319_combout\ : std_logic;
SIGNAL \regs|Mux4~91_combout\ : std_logic;
SIGNAL \regs|Mux4~92_combout\ : std_logic;
SIGNAL \regs|Mux4~88_combout\ : std_logic;
SIGNAL \regs|Mux4~89_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~22_regout\ : std_logic;
SIGNAL \regs|Mux4~90_combout\ : std_logic;
SIGNAL \regs|Mux4~93_combout\ : std_logic;
SIGNAL \regs|Mux4~94_combout\ : std_logic;
SIGNAL \regs|Mux4~95_combout\ : std_logic;
SIGNAL \wb_interface|Mux28~200_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|count[1]~333_combout\ : std_logic;
SIGNAL \wb_interface|Mux27~250_combout\ : std_logic;
SIGNAL \regs|Mux3~112_combout\ : std_logic;
SIGNAL \regs|cts_c~9_combout\ : std_logic;
SIGNAL \regs|Mux3~106_combout\ : std_logic;
SIGNAL \regs|Mux3~109_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~24_regout\ : std_logic;
SIGNAL \regs|Mux7~336_combout\ : std_logic;
SIGNAL \regs|Mux3~110_combout\ : std_logic;
SIGNAL \regs|Mux3~111_combout\ : std_logic;
SIGNAL \regs|Mux3~113_combout\ : std_logic;
SIGNAL \wb_interface|Mux27~251_combout\ : std_logic;
SIGNAL \wb_interface|Mux27~252_combout\ : std_logic;
SIGNAL \wb_interface|Mux26~251_combout\ : std_logic;
SIGNAL \regs|dsr_c~9_combout\ : std_logic;
SIGNAL \regs|Mux0~211_combout\ : std_logic;
SIGNAL \regs|Mux2~100_combout\ : std_logic;
SIGNAL \regs|Mux2~101_combout\ : std_logic;
SIGNAL \regs|Mux2~102_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~26_regout\ : std_logic;
SIGNAL \regs|Mux2~103_combout\ : std_logic;
SIGNAL \regs|Mux2~104_combout\ : std_logic;
SIGNAL \regs|Mux2~105_combout\ : std_logic;
SIGNAL \wb_interface|Mux26~253_combout\ : std_logic;
SIGNAL \wb_interface|Mux26~252_combout\ : std_logic;
SIGNAL \wb_interface|Mux31~216_combout\ : std_logic;
SIGNAL \regs|Mux1~160_combout\ : std_logic;
SIGNAL \regs|Mux1~161_combout\ : std_logic;
SIGNAL \ri_pad_i~combout\ : std_logic;
SIGNAL \regs|ri_c~9_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~28feeder_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~28_regout\ : std_logic;
SIGNAL \regs|Mux1~162_combout\ : std_logic;
SIGNAL \regs|Mux1~163_combout\ : std_logic;
SIGNAL \regs|Mux1~164_combout\ : std_logic;
SIGNAL \regs|Mux1~165_combout\ : std_logic;
SIGNAL \wb_interface|Mux25~212_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[9][1]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[5][1]~regout\ : std_logic;
SIGNAL \regs|lsr7~552_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[7][1]~regout\ : std_logic;
SIGNAL \regs|lsr7~555_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[4][1]~regout\ : std_logic;
SIGNAL \regs|lsr7~554_combout\ : std_logic;
SIGNAL \regs|lsr7~556_combout\ : std_logic;
SIGNAL \regs|receiver|Selector11~33_combout\ : std_logic;
SIGNAL \regs|receiver|rf_data_in[2]~636_combout\ : std_logic;
SIGNAL \regs|receiver|rf_data_in[2]~637_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo~6689_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[15][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[1][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[5][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[9][2]~regout\ : std_logic;
SIGNAL \regs|lsr7~563_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[6][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[2][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[10][2]~regout\ : std_logic;
SIGNAL \regs|lsr7~562_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[7][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[11][2]~regout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|fifo[3][2]~regout\ : std_logic;
SIGNAL \regs|lsr7~565_combout\ : std_logic;
SIGNAL \regs|lsr7~566_combout\ : std_logic;
SIGNAL \regs|lsr7~567_combout\ : std_logic;
SIGNAL \regs|lsr7_d~regout\ : std_logic;
SIGNAL \regs|lsr7r~29_combout\ : std_logic;
SIGNAL \regs|lsr7r~regout\ : std_logic;
SIGNAL \wb_interface|Mux24~211_combout\ : std_logic;
SIGNAL \regs|Mux0~212_combout\ : std_logic;
SIGNAL \regs|Mux0~213_combout\ : std_logic;
SIGNAL \dcd_pad_i~combout\ : std_logic;
SIGNAL \regs|dcd_c~9_combout\ : std_logic;
SIGNAL \regs|receiver|fifo_rx|rfifo|ram~30_regout\ : std_logic;
SIGNAL \regs|Mux0~214_combout\ : std_logic;
SIGNAL \regs|Mux0~215_combout\ : std_logic;
SIGNAL \regs|Mux0~216_combout\ : std_logic;
SIGNAL \regs|Mux0~217_combout\ : std_logic;
SIGNAL \wb_interface|Mux24~212_combout\ : std_logic;
SIGNAL \wb_interface|Mux31~218_combout\ : std_logic;
SIGNAL \wb_interface|Mux23~214_combout\ : std_logic;
SIGNAL \wb_interface|Mux23~213_combout\ : std_logic;
SIGNAL \wb_interface|Mux23~215_combout\ : std_logic;
SIGNAL \wb_interface|Mux22~209_combout\ : std_logic;
SIGNAL \wb_interface|Mux22~210_combout\ : std_logic;
SIGNAL \wb_interface|Mux21~209_combout\ : std_logic;
SIGNAL \wb_interface|Mux21~210_combout\ : std_logic;
SIGNAL \wb_interface|Mux20~209_combout\ : std_logic;
SIGNAL \wb_interface|Mux20~210_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_o[10]~539_combout\ : std_logic;
SIGNAL \regs|delayed_modem_signals[2]~10_combout\ : std_logic;
SIGNAL \regs|msr~174_combout\ : std_logic;
SIGNAL \regs|delayed_modem_signals[3]~11_combout\ : std_logic;
SIGNAL \regs|msr~175_combout\ : std_logic;
SIGNAL \regs|ms_int~35_combout\ : std_logic;
SIGNAL \regs|ms_int~36_combout\ : std_logic;
SIGNAL \regs|ms_int_d~regout\ : std_logic;
SIGNAL \regs|ms_int_pnd~82_combout\ : std_logic;
SIGNAL \regs|ms_int_pnd~83_combout\ : std_logic;
SIGNAL \regs|ms_int_pnd~regout\ : std_logic;
SIGNAL \regs|iir~317_combout\ : std_logic;
SIGNAL \wb_interface|Mux19~256_combout\ : std_logic;
SIGNAL \wb_interface|Mux19~257_combout\ : std_logic;
SIGNAL \wb_interface|Mux19~258_combout\ : std_logic;
SIGNAL \wb_interface|Mux18~255_combout\ : std_logic;
SIGNAL \wb_interface|Mux18~256_combout\ : std_logic;
SIGNAL \wb_interface|Mux18~257_combout\ : std_logic;
SIGNAL \wb_interface|Mux17~217_combout\ : std_logic;
SIGNAL \wb_interface|Mux17~218_combout\ : std_logic;
SIGNAL \wb_interface|Mux16~217_combout\ : std_logic;
SIGNAL \wb_interface|Mux16~218_combout\ : std_logic;
SIGNAL \wb_interface|Mux23~216_combout\ : std_logic;
SIGNAL \wb_interface|Mux15~193_combout\ : std_logic;
SIGNAL \wb_interface|Mux15~192_combout\ : std_logic;
SIGNAL \wb_interface|Mux15~194_combout\ : std_logic;
SIGNAL \regs|dtr_pad_o~regout\ : std_logic;
SIGNAL \wb_interface|Mux14~194_combout\ : std_logic;
SIGNAL \wb_interface|Mux14~195_combout\ : std_logic;
SIGNAL \wb_interface|Mux13~190_combout\ : std_logic;
SIGNAL \wb_interface|Mux13~191_combout\ : std_logic;
SIGNAL \wb_interface|Mux12~194_combout\ : std_logic;
SIGNAL \wb_interface|Mux12~195_combout\ : std_logic;
SIGNAL \wb_interface|Mux11~241_combout\ : std_logic;
SIGNAL \wb_interface|Mux11~242_combout\ : std_logic;
SIGNAL \wb_interface|Mux11~243_combout\ : std_logic;
SIGNAL \wb_interface|Mux10~240_combout\ : std_logic;
SIGNAL \wb_interface|Mux10~241_combout\ : std_logic;
SIGNAL \wb_interface|Mux10~242_combout\ : std_logic;
SIGNAL \wb_interface|Mux9~202_combout\ : std_logic;
SIGNAL \wb_interface|Mux9~203_combout\ : std_logic;
SIGNAL \wb_interface|Mux8~202_combout\ : std_logic;
SIGNAL \wb_interface|Mux8~203_combout\ : std_logic;
SIGNAL \wb_interface|wb_dat_o[18]~540_combout\ : std_logic;
SIGNAL \wb_interface|Mux7~107_combout\ : std_logic;
SIGNAL \wb_interface|Mux7~108_combout\ : std_logic;
SIGNAL \wb_interface|Mux6~92_combout\ : std_logic;
SIGNAL \wb_interface|Mux7~109_combout\ : std_logic;
SIGNAL \wb_interface|Mux5~92_combout\ : std_logic;
SIGNAL \wb_interface|Mux4~92_combout\ : std_logic;
SIGNAL \wb_interface|Mux3~84_combout\ : std_logic;
SIGNAL \wb_interface|Mux2~84_combout\ : std_logic;
SIGNAL \wb_interface|Mux1~100_combout\ : std_logic;
SIGNAL \wb_interface|Mux0~96_combout\ : std_logic;
SIGNAL \regs|block_cnt[0]~188_combout\ : std_logic;
SIGNAL \regs|always31~0_combout\ : std_logic;
SIGNAL \regs|block_cnt[0]~189\ : std_logic;
SIGNAL \regs|block_cnt[1]~192\ : std_logic;
SIGNAL \regs|block_cnt[2]~193_combout\ : std_logic;
SIGNAL \regs|block_cnt[2]~194\ : std_logic;
SIGNAL \regs|block_cnt[3]~196\ : std_logic;
SIGNAL \regs|block_cnt[4]~197_combout\ : std_logic;
SIGNAL \regs|block_cnt[4]~198\ : std_logic;
SIGNAL \regs|block_cnt[5]~200\ : std_logic;
SIGNAL \regs|block_cnt[6]~201_combout\ : std_logic;
SIGNAL \regs|WideOr2~23_combout\ : std_logic;
SIGNAL \regs|WideOr2~23_wirecell_combout\ : std_logic;
SIGNAL \regs|block_cnt[6]~202\ : std_logic;
SIGNAL \regs|block_cnt[7]~203_combout\ : std_logic;
SIGNAL \regs|block_cnt[5]~199_combout\ : std_logic;
SIGNAL \regs|WideOr3~23_combout\ : std_logic;
SIGNAL \regs|lsr5~76_combout\ : std_logic;
SIGNAL \regs|block_cnt[7]~190_combout\ : std_logic;
SIGNAL \regs|block_cnt[3]~195_combout\ : std_logic;
SIGNAL \regs|receiver|Decoder4~13_wirecell_combout\ : std_logic;
SIGNAL \regs|block_cnt[1]~191_combout\ : std_logic;
SIGNAL \regs|lsr5~75_combout\ : std_logic;
SIGNAL \regs|lsr5~combout\ : std_logic;
SIGNAL \regs|lsr5r~66_combout\ : std_logic;
SIGNAL \regs|lsr5r~regout\ : std_logic;
SIGNAL \regs|thre_int~combout\ : std_logic;
SIGNAL \regs|thre_int_d~regout\ : std_logic;
SIGNAL \regs|thre_int_pnd~117_combout\ : std_logic;
SIGNAL \regs|thre_int_pnd~120_combout\ : std_logic;
SIGNAL \regs|thre_int_pnd~regout\ : std_logic;
SIGNAL \regs|int_o~460_combout\ : std_logic;
SIGNAL \regs|int_o~461_combout\ : std_logic;
SIGNAL \regs|int_o~462_combout\ : std_logic;
SIGNAL \regs|int_o~regout\ : std_logic;
SIGNAL \regs|transmitter|bit_out~1053_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_out~1054_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|bottom~745_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|bottom~746_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|bottom~747_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|Add3~103_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|bottom~748_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|Add3~104_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|bottom~749_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|top~179_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|top[3]~180_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|top~181_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|top~182_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|Add0~103_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|top~183_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~818_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[5]~feeder_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~819_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~820_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~822_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~823_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~16_regout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~817_combout\ : std_logic;
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram~821_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_out~1058_combout\ : std_logic;
SIGNAL \regs|transmitter|bit_out~regout\ : std_logic;
SIGNAL \regs|transmitter|Mux21~148_combout\ : std_logic;
SIGNAL \regs|transmitter|Mux21~149_combout\ : std_logic;
SIGNAL \regs|transmitter|stx_o_tmp~regout\ : std_logic;
SIGNAL \regs|stx_pad_o~2_combout\ : std_logic;
SIGNAL \regs|receiver|counter_b\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \regs|receiver|counter_t\ : std_logic_vector(9 DOWNTO 0);
SIGNAL \regs|receiver|rbit_counter\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \regs|receiver|rcounter16\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|receiver|rf_data_in\ : std_logic_vector(10 DOWNTO 0);
SIGNAL \regs|receiver|rshift\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \regs|receiver|rstate\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|transmitter|fifo_tx|count\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \regs|transmitter|shift_out\ : std_logic_vector(6 DOWNTO 0);
SIGNAL \regs|delayed_modem_signals\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|ier\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|msr\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \wb_interface|wb_dat_o\ : std_logic_vector(31 DOWNTO 0);
SIGNAL \wb_adr_i~combout\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\ : std_logic_vector(0 TO 17);
SIGNAL \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \regs|i_uart_sync_flops|sync_dat_o\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \regs|transmitter|fifo_tx|bottom\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|transmitter|fifo_tx|top\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|transmitter|counter\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \regs|transmitter|tstate\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \regs|block_cnt\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \regs|dl\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \regs|fcr\ : std_logic_vector(1 DOWNTO 0);
SIGNAL \regs|iir\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|mcr\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \regs|scratch\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \wb_interface|wb_dat_is\ : std_logic_vector(31 DOWNTO 0);
SIGNAL \wb_interface|wb_sel_is\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \wb_dat_i~combout\ : std_logic_vector(31 DOWNTO 0);
SIGNAL \wb_sel_i~combout\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|receiver|fifo_rx|rfifo|ram_0_bypass\ : std_logic_vector(0 TO 17);
SIGNAL \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \regs|receiver|fifo_rx|bottom\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|receiver|fifo_rx|count\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \regs|receiver|fifo_rx|top\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \regs|i_uart_sync_flops|flop_0\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \regs|transmitter|bit_counter\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \regs|dlc\ : std_logic_vector(15 DOWNTO 0);
SIGNAL \regs|lcr\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \wb_interface|wb_adr_is\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \regs|transmitter|ALT_INV_tstate\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \regs|receiver|ALT_INV_rstate\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \regs|ALT_INV_enable~regout\ : std_logic;

BEGIN

ww_wb_clk_i <= wb_clk_i;
ww_wb_rst_i <= wb_rst_i;
ww_wb_adr_i <= wb_adr_i;
ww_wb_dat_i <= wb_dat_i;
wb_dat_o <= ww_wb_dat_o;
ww_wb_we_i <= wb_we_i;
ww_wb_stb_i <= wb_stb_i;
ww_wb_cyc_i <= wb_cyc_i;
wb_ack_o <= ww_wb_ack_o;
ww_wb_sel_i <= wb_sel_i;
int_o <= ww_int_o;
stx_pad_o <= ww_stx_pad_o;
ww_srx_pad_i <= srx_pad_i;
rts_pad_o <= ww_rts_pad_o;
ww_cts_pad_i <= cts_pad_i;
dtr_pad_o <= ww_dtr_pad_o;
ww_dsr_pad_i <= dsr_pad_i;
ww_ri_pad_i <= ri_pad_i;
ww_dcd_pad_i <= dcd_pad_i;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAIN_bus\ <= (\regs|receiver|rf_data_in\(10) & \regs|receiver|rf_data_in\(9) & \regs|receiver|rf_data_in\(8) & \regs|receiver|rf_data_in\(7) & \regs|receiver|rf_data_in\(6)
& \regs|receiver|rf_data_in\(5) & \regs|receiver|rf_data_in\(4) & \regs|receiver|rf_data_in\(3));

\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTAADDR_bus\ <= (\regs|receiver|fifo_rx|top\(3) & \regs|receiver|fifo_rx|top\(2) & \regs|receiver|fifo_rx|top\(1) & \regs|receiver|fifo_rx|top\(0));

\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBADDR_bus\ <= (\regs|receiver|fifo_rx|bottom~846_combout\ & \regs|receiver|fifo_rx|bottom~849_combout\ & \regs|receiver|fifo_rx|bottom~847_combout\ & 
\regs|receiver|fifo_rx|bottom~848_combout\);

\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(0) <= \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(0);
\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(1) <= \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(1);
\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(2) <= \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(2);
\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(3) <= \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(3);
\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(4) <= \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(4);
\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(5) <= \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(5);
\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(6) <= \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(6);
\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(7) <= \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(7);

\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTADATAIN_bus\ <= (\wb_interface|Mux32~228_combout\ & \wb_interface|Mux33~26_combout\ & \wb_interface|Mux34~26_combout\ & \wb_interface|Mux35~26_combout\ & 
\wb_interface|Mux36~26_combout\ & \wb_interface|Mux37~26_combout\ & \wb_interface|Mux38~26_combout\ & \wb_interface|Mux39~26_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTAADDR_bus\ <= (\regs|transmitter|fifo_tx|top\(3) & \regs|transmitter|fifo_tx|top\(2) & \regs|transmitter|fifo_tx|top\(1) & \regs|transmitter|fifo_tx|top\(0));

\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBADDR_bus\ <= (\regs|transmitter|fifo_tx|bottom~749_combout\ & \regs|transmitter|fifo_tx|bottom~748_combout\ & \regs|transmitter|fifo_tx|bottom~747_combout\ & 
\regs|transmitter|fifo_tx|bottom~746_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(0) <= \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(0);
\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(1) <= \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(1);
\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(2) <= \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(2);
\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(3) <= \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(3);
\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(4) <= \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(4);
\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(5) <= \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(5);
\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(6) <= \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(6);
\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(7) <= \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(7);

\wb_clk_i~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \wb_clk_i~combout\);

\wb_rst_i~clkctrl_INCLK_bus\ <= (gnd & gnd & gnd & \wb_rst_i~combout\);
\regs|transmitter|ALT_INV_tstate\(0) <= NOT \regs|transmitter|tstate\(0);
\regs|receiver|ALT_INV_rstate\(0) <= NOT \regs|receiver|rstate\(0);
\regs|ALT_INV_enable~regout\ <= NOT \regs|enable~regout\;

\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0\ : cycloneii_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "uart_regs:regs|uart_receiver:receiver|uart_rfifo:fifo_rx|raminfr:rfifo|altsyncram:ram_rtl_0|altsyncram_h6e1:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 4,
	port_a_byte_enable_clear => "none",
	port_a_byte_enable_clock => "none",
	port_a_data_in_clear => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 8,
	port_a_first_address => 0,
	port_a_first_bit_number => 0,
	port_a_last_address => 15,
	port_a_logical_ram_depth => 16,
	port_a_logical_ram_width => 8,
	port_a_write_enable_clear => "none",
	port_b_address_clear => "none",
	port_b_address_clock => "clock0",
	port_b_address_width => 4,
	port_b_byte_enable_clear => "none",
	port_b_data_in_clear => "none",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 8,
	port_b_first_address => 0,
	port_b_first_bit_number => 0,
	port_b_last_address => 15,
	port_b_logical_ram_depth => 16,
	port_b_logical_ram_width => 8,
	port_b_read_enable_write_enable_clear => "none",
	port_b_read_enable_write_enable_clock => "clock0",
	ram_block_type => "M4K",
	safe_write => "err_on_2clk")
-- pragma translate_on
PORT MAP (
	portawe => \regs|receiver|rf_push_pulse~combout\,
	portbrewe => VCC,
	clk0 => \wb_clk_i~clkctrl_outclk\,
	portadatain => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTADATAIN_bus\,
	portaaddr => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTAADDR_bus\,
	portbaddr => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portbdataout => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|ram_block1a0_PORTBDATAOUT_bus\);

\regs|receiver|counter_b[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_b[1]~227_combout\,
	sdata => \~GND~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|serial_in~34_combout\,
	ena => \regs|receiver|counter_b[4]~226_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_b\(1));

\regs|receiver|counter_b[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_b[7]~239_combout\,
	sdata => \regs|receiver|WideOr5~15_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|serial_in~34_combout\,
	ena => \regs|receiver|counter_b[4]~226_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_b\(7));

\regs|receiver|counter_t[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_t[3]~278_combout\,
	sdata => \~GND~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|receiver|always4~1_combout\,
	ena => \regs|receiver|counter_t[1]~273_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_t\(3));

\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0\ : cycloneii_ram_block
-- pragma translate_off
GENERIC MAP (
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "uart_regs:regs|uart_transmitter:transmitter|uart_tfifo:fifo_tx|raminfr:tfifo|altsyncram:ram_rtl_1|altsyncram_h6e1:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 4,
	port_a_byte_enable_clear => "none",
	port_a_byte_enable_clock => "none",
	port_a_data_in_clear => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 8,
	port_a_first_address => 0,
	port_a_first_bit_number => 0,
	port_a_last_address => 15,
	port_a_logical_ram_depth => 16,
	port_a_logical_ram_width => 8,
	port_a_write_enable_clear => "none",
	port_b_address_clear => "none",
	port_b_address_clock => "clock0",
	port_b_address_width => 4,
	port_b_byte_enable_clear => "none",
	port_b_data_in_clear => "none",
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "none",
	port_b_data_width => 8,
	port_b_first_address => 0,
	port_b_first_bit_number => 0,
	port_b_last_address => 15,
	port_b_logical_ram_depth => 16,
	port_b_logical_ram_width => 8,
	port_b_read_enable_write_enable_clear => "none",
	port_b_read_enable_write_enable_clock => "clock0",
	ram_block_type => "M4K",
	safe_write => "err_on_2clk")
-- pragma translate_on
PORT MAP (
	portawe => \regs|tf_push~regout\,
	portbrewe => VCC,
	clk0 => \wb_clk_i~clkctrl_outclk\,
	portadatain => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTADATAIN_bus\,
	portaaddr => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTAADDR_bus\,
	portbaddr => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portbdataout => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|ram_block1a0_PORTBDATAOUT_bus\);

\regs|transmitter|shift_out[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|shift_out[0]~81_combout\,
	sdata => \regs|transmitter|shift_out\(1),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|transmitter|ALT_INV_tstate\(0),
	ena => \regs|transmitter|bit_counter[0]~664_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|shift_out\(0));

\regs|dlc[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[1]~258_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(1));

\regs|dlc[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[5]~266_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(5));

\regs|dlc[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[11]~278_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(11));

\regs|dlc[15]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[15]~286_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(15));

\regs|transmitter|Add1~67\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Add1~67_combout\ = \regs|transmitter|counter\(1) & \regs|transmitter|Add1~66\ & VCC # !\regs|transmitter|counter\(1) & !\regs|transmitter|Add1~66\
-- \regs|transmitter|Add1~68\ = CARRY(!\regs|transmitter|counter\(1) & !\regs|transmitter|Add1~66\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|counter\(1),
	datad => VCC,
	cin => \regs|transmitter|Add1~66\,
	combout => \regs|transmitter|Add1~67_combout\,
	cout => \regs|transmitter|Add1~68\);

\regs|transmitter|Add1~69\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Add1~69_combout\ = \regs|transmitter|counter\(2) & (GND # !\regs|transmitter|Add1~68\) # !\regs|transmitter|counter\(2) & (\regs|transmitter|Add1~68\ $ GND)
-- \regs|transmitter|Add1~70\ = CARRY(\regs|transmitter|counter\(2) # !\regs|transmitter|Add1~68\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101010101111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|counter\(2),
	datad => VCC,
	cin => \regs|transmitter|Add1~68\,
	combout => \regs|transmitter|Add1~69_combout\,
	cout => \regs|transmitter|Add1~70\);

\regs|transmitter|Add1~71\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Add1~71_combout\ = \regs|transmitter|counter\(3) & \regs|transmitter|Add1~70\ & VCC # !\regs|transmitter|counter\(3) & !\regs|transmitter|Add1~70\
-- \regs|transmitter|Add1~72\ = CARRY(!\regs|transmitter|counter\(3) & !\regs|transmitter|Add1~70\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|counter\(3),
	datad => VCC,
	cin => \regs|transmitter|Add1~70\,
	combout => \regs|transmitter|Add1~71_combout\,
	cout => \regs|transmitter|Add1~72\);

\regs|transmitter|Add1~73\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Add1~73_combout\ = \regs|transmitter|Add1~72\ $ \regs|transmitter|counter\(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \regs|transmitter|counter\(4),
	cin => \regs|transmitter|Add1~72\,
	combout => \regs|transmitter|Add1~73_combout\);

\regs|receiver|counter_b[1]~227\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_b[1]~227_combout\ = \regs|receiver|counter_b\(1) & (\regs|receiver|counter_b[0]~225\ $ GND) # !\regs|receiver|counter_b\(1) & !\regs|receiver|counter_b[0]~225\ & VCC
-- \regs|receiver|counter_b[1]~228\ = CARRY(\regs|receiver|counter_b\(1) & !\regs|receiver|counter_b[0]~225\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_b\(1),
	datad => VCC,
	cin => \regs|receiver|counter_b[0]~225\,
	combout => \regs|receiver|counter_b[1]~227_combout\,
	cout => \regs|receiver|counter_b[1]~228\);

\regs|receiver|counter_b[6]~237\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_b[6]~237_combout\ = \regs|receiver|counter_b\(6) & (GND # !\regs|receiver|counter_b[5]~236\) # !\regs|receiver|counter_b\(6) & (\regs|receiver|counter_b[5]~236\ $ GND)
-- \regs|receiver|counter_b[6]~238\ = CARRY(\regs|receiver|counter_b\(6) # !\regs|receiver|counter_b[5]~236\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101010101111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_b\(6),
	datad => VCC,
	cin => \regs|receiver|counter_b[5]~236\,
	combout => \regs|receiver|counter_b[6]~237_combout\,
	cout => \regs|receiver|counter_b[6]~238\);

\regs|receiver|counter_b[7]~239\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_b[7]~239_combout\ = \regs|receiver|counter_b\(7) $ !\regs|receiver|counter_b[6]~238\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010110100101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_b\(7),
	cin => \regs|receiver|counter_b[6]~238\,
	combout => \regs|receiver|counter_b[7]~239_combout\);

\regs|receiver|counter_t[3]~278\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_t[3]~278_combout\ = \regs|receiver|counter_t\(3) & (\regs|receiver|counter_t[2]~277\ $ GND) # !\regs|receiver|counter_t\(3) & !\regs|receiver|counter_t[2]~277\ & VCC
-- \regs|receiver|counter_t[3]~279\ = CARRY(\regs|receiver|counter_t\(3) & !\regs|receiver|counter_t[2]~277\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_t\(3),
	datad => VCC,
	cin => \regs|receiver|counter_t[2]~277\,
	combout => \regs|receiver|counter_t[3]~278_combout\,
	cout => \regs|receiver|counter_t[3]~279\);

\regs|transmitter|shift_out[0]~81\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|shift_out[0]~81_combout\ = \regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(10) # !\regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & (\regs|transmitter|fifo_tx|tfifo|ram~824_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(10),
	datab => \regs|transmitter|fifo_tx|tfifo|ram~820_combout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram~824_combout\,
	combout => \regs|transmitter|shift_out[0]~81_combout\);

\regs|transmitter|shift_out[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|shift_out[1]~82_combout\,
	sdata => \regs|transmitter|shift_out\(2),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|transmitter|ALT_INV_tstate\(0),
	ena => \regs|transmitter|bit_counter[0]~664_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|shift_out\(1));

\regs|transmitter|shift_out[4]~85\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|shift_out[4]~85_combout\ = \regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(14) # !\regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & (\regs|transmitter|fifo_tx|tfifo|ram~825_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(14),
	datab => \regs|transmitter|fifo_tx|tfifo|ram~820_combout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram~825_combout\,
	combout => \regs|transmitter|shift_out[4]~85_combout\);

\regs|transmitter|shift_out[3]~84\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|shift_out[3]~84_combout\ = \regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(13) # !\regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & (\regs|transmitter|fifo_tx|tfifo|ram~826_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(13),
	datab => \regs|transmitter|fifo_tx|tfifo|ram~820_combout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram~826_combout\,
	combout => \regs|transmitter|shift_out[3]~84_combout\);

\regs|transmitter|shift_out[1]~82\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|shift_out[1]~82_combout\ = \regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & (\regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(11)) # !\regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & \regs|transmitter|fifo_tx|tfifo|ram~827_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|tfifo|ram~827_combout\,
	datab => \regs|transmitter|fifo_tx|tfifo|ram~820_combout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(11),
	combout => \regs|transmitter|shift_out[1]~82_combout\);

\regs|transmitter|shift_out[2]~83\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|shift_out[2]~83_combout\ = \regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(12) # !\regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & (\regs|transmitter|fifo_tx|tfifo|ram~828_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|tfifo|ram~820_combout\,
	datab => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(12),
	datad => \regs|transmitter|fifo_tx|tfifo|ram~828_combout\,
	combout => \regs|transmitter|shift_out[2]~83_combout\);

\regs|transmitter|shift_out[5]~86\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|shift_out[5]~86_combout\ = \regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(15) # !\regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & (\regs|transmitter|fifo_tx|tfifo|ram~829_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|tfifo|ram~820_combout\,
	datab => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(15),
	datad => \regs|transmitter|fifo_tx|tfifo|ram~829_combout\,
	combout => \regs|transmitter|shift_out[5]~86_combout\);

\regs|dlc[1]~258\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[1]~258_combout\ = \regs|Add0~930_combout\ & \regs|dlc[0]~257\ & VCC # !\regs|Add0~930_combout\ & !\regs|dlc[0]~257\
-- \regs|dlc[1]~259\ = CARRY(!\regs|Add0~930_combout\ & !\regs|dlc[0]~257\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Add0~930_combout\,
	datad => VCC,
	cin => \regs|dlc[0]~257\,
	combout => \regs|dlc[1]~258_combout\,
	cout => \regs|dlc[1]~259\);

\regs|dlc[5]~266\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[5]~266_combout\ = \regs|Add0~934_combout\ & \regs|dlc[4]~265\ & VCC # !\regs|Add0~934_combout\ & !\regs|dlc[4]~265\
-- \regs|dlc[5]~267\ = CARRY(!\regs|Add0~934_combout\ & !\regs|dlc[4]~265\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|Add0~934_combout\,
	datad => VCC,
	cin => \regs|dlc[4]~265\,
	combout => \regs|dlc[5]~266_combout\,
	cout => \regs|dlc[5]~267\);

\regs|dlc[11]~278\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[11]~278_combout\ = \regs|Add0~940_combout\ & \regs|dlc[10]~277\ & VCC # !\regs|Add0~940_combout\ & !\regs|dlc[10]~277\
-- \regs|dlc[11]~279\ = CARRY(!\regs|Add0~940_combout\ & !\regs|dlc[10]~277\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Add0~940_combout\,
	datad => VCC,
	cin => \regs|dlc[10]~277\,
	combout => \regs|dlc[11]~278_combout\,
	cout => \regs|dlc[11]~279\);

\regs|dlc[14]~284\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[14]~284_combout\ = \regs|Add0~943_combout\ & (GND # !\regs|dlc[13]~283\) # !\regs|Add0~943_combout\ & (\regs|dlc[13]~283\ $ GND)
-- \regs|dlc[14]~285\ = CARRY(\regs|Add0~943_combout\ # !\regs|dlc[13]~283\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|Add0~943_combout\,
	datad => VCC,
	cin => \regs|dlc[13]~283\,
	combout => \regs|dlc[14]~284_combout\,
	cout => \regs|dlc[14]~285\);

\regs|dlc[15]~286\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[15]~286_combout\ = \regs|dlc[14]~285\ $ !\regs|Add0~944_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \regs|Add0~944_combout\,
	cin => \regs|dlc[14]~285\,
	combout => \regs|dlc[15]~286_combout\);

\regs|transmitter|shift_out[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|shift_out[2]~83_combout\,
	sdata => \regs|transmitter|shift_out\(3),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|transmitter|ALT_INV_tstate\(0),
	ena => \regs|transmitter|bit_counter[0]~664_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|shift_out\(2));

\regs|transmitter|shift_out[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|shift_out[3]~84_combout\,
	sdata => \regs|transmitter|shift_out\(4),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|transmitter|ALT_INV_tstate\(0),
	ena => \regs|transmitter|bit_counter[0]~664_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|shift_out\(3));

\regs|transmitter|shift_out[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|shift_out[4]~85_combout\,
	sdata => \regs|transmitter|shift_out\(5),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|transmitter|ALT_INV_tstate\(0),
	ena => \regs|transmitter|bit_counter[0]~664_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|shift_out\(4));

\regs|transmitter|shift_out[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|shift_out[5]~86_combout\,
	sdata => \regs|transmitter|shift_out\(6),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|transmitter|ALT_INV_tstate\(0),
	ena => \regs|transmitter|bit_counter[0]~664_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|shift_out\(5));

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|rfifo|ram_0_bypass[7]~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(7));

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|top\(1),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(3));

\regs|Mux7~333\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~333_combout\ = \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(7) & (\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(3) $ \regs|receiver|fifo_rx|bottom\(1) # !\regs|receiver|fifo_rx|bottom\(3)) # !\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(7) & 
-- (\regs|receiver|fifo_rx|bottom\(3) # \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(3) $ \regs|receiver|fifo_rx|bottom\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110111111110110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(7),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(3),
	datad => \regs|receiver|fifo_rx|bottom\(1),
	combout => \regs|Mux7~333_combout\);

\regs|lsr0r\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr0r~135_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr0r~regout\);

\regs|Mux7~342\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~342_combout\ = \regs|Mux7~340_combout\ & (\regs|Mux7~341_combout\) # !\regs|Mux7~340_combout\ & (\regs|Mux7~341_combout\ & (\regs|dl\(8)) # !\regs|Mux7~341_combout\ & \regs|ier\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|ier\(0),
	datab => \regs|Mux7~340_combout\,
	datac => \regs|dl\(8),
	datad => \regs|Mux7~341_combout\,
	combout => \regs|Mux7~342_combout\);

\regs|Mux7~343\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~343_combout\ = \regs|Mux7~340_combout\ & (\regs|Mux7~342_combout\ & (!\regs|lcr\(0)) # !\regs|Mux7~342_combout\ & \regs|lsr0r~regout\) # !\regs|Mux7~340_combout\ & (\regs|Mux7~342_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011111110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0r~regout\,
	datab => \regs|Mux7~340_combout\,
	datac => \regs|lcr\(0),
	datad => \regs|Mux7~342_combout\,
	combout => \regs|Mux7~343_combout\);

\regs|iir[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|iir~318_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|iir\(1));

\regs|Mux6~100\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux6~100_combout\ = \regs|Mux7~340_combout\ & (\regs|lsr1r~regout\ # \regs|Mux7~341_combout\) # !\regs|Mux7~340_combout\ & (\regs|ier\(1) & !\regs|Mux7~341_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110010111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr1r~regout\,
	datab => \regs|Mux7~340_combout\,
	datac => \regs|ier\(1),
	datad => \regs|Mux7~341_combout\,
	combout => \regs|Mux6~100_combout\);

\regs|scratch[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux37~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|always8~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|scratch\(2));

\regs|lsr4r\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr4r~36_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr4r~regout\);

\regs|scratch[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux35~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|always8~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|scratch\(4));

\regs|Mux3~107\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux3~107_combout\ = \wb_interface|wb_adr_is\(2) & (\regs|lsr4r~regout\ # !\regs|Mux0~211_combout\) # !\wb_interface|wb_adr_is\(2) & (\regs|dl\(12) & \regs|Mux0~211_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr4r~regout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|dl\(12),
	datad => \regs|Mux0~211_combout\,
	combout => \regs|Mux3~107_combout\);

\regs|Mux3~108\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux3~108_combout\ = \wb_interface|wb_adr_int[1]~63_combout\ & (\regs|Mux3~107_combout\ & \regs|scratch\(4) # !\regs|Mux3~107_combout\ & (\regs|lcr\(4))) # !\wb_interface|wb_adr_int[1]~63_combout\ & (\regs|Mux3~107_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|scratch\(4),
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \regs|lcr\(4),
	datad => \regs|Mux3~107_combout\,
	combout => \regs|Mux3~108_combout\);

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[13]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(7),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(13));

\regs|lsr6r\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr6r~68_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr6r~regout\);

\wb_interface|Mux25~211\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux25~211_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|transmitter|fifo_tx|count\(3)) # !\wb_interface|wb_adr_is\(2) & !\regs|lsr6r~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \dbg|Equal0~38_combout\,
	datab => \regs|lsr6r~regout\,
	datac => \regs|transmitter|fifo_tx|count\(3),
	datad => \wb_interface|wb_adr_is\(2),
	combout => \wb_interface|Mux25~211_combout\);

\regs|fcr[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|fcr[0]~37_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|always6~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|fcr\(0));

\dbg|Equal0~39\ : cycloneii_lcell_comb
-- Equation(s):
-- \dbg|Equal0~39_combout\ = !\wb_interface|wb_adr_is\(2) & \dbg|Equal0~38_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \wb_interface|wb_adr_is\(2),
	datad => \dbg|Equal0~38_combout\,
	combout => \dbg|Equal0~39_combout\);

\regs|lsr_mask_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr_mask_condition~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr_mask_d~regout\);

\regs|rda_int_pnd\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|rda_int_pnd~314_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|rda_int_pnd~regout\);

\wb_interface|wb_dat_is[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(4),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(4));

\wb_interface|wb_dat_is[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[6]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(6));

\wb_interface|wb_dat_is[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[9]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(9));

\regs|delayed_modem_signals[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|delayed_modem_signals[0]~8_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|delayed_modem_signals\(0));

\wb_interface|wb_dat_is[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[7]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(7));

\regs|lsr0r~132\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr0r~132_combout\ = !\regs|receiver|fifo_rx|count\(2) & !\regs|receiver|fifo_rx|count\(1) & !\regs|receiver|fifo_rx|count\(3) & \regs|receiver|fifo_rx|count\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(2),
	datab => \regs|receiver|fifo_rx|count\(1),
	datac => \regs|receiver|fifo_rx|count\(3),
	datad => \regs|receiver|fifo_rx|count\(0),
	combout => \regs|lsr0r~132_combout\);

\regs|lsr0r~134\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr0r~134_combout\ = !\regs|rx_reset~regout\ & (\regs|receiver|fifo_rx|count\(4) # !\regs|lsr0r~132_combout\ # !\regs|lsr0r~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|lsr0r~133_combout\,
	datac => \regs|lsr0r~132_combout\,
	datad => \regs|rx_reset~regout\,
	combout => \regs|lsr0r~134_combout\);

\regs|lsr0\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr0~combout\ = !\regs|receiver|fifo_rx|count\(4) & \regs|receiver|rf_push_pulse~combout\ & \regs|lsr0r~131_combout\ & !\regs|receiver|fifo_rx|count\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|receiver|rf_push_pulse~combout\,
	datac => \regs|lsr0r~131_combout\,
	datad => \regs|receiver|fifo_rx|count\(0),
	combout => \regs|lsr0~combout\);

\regs|lsr0_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr0~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr0_d~regout\);

\regs|lsr0r~135\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr0r~135_combout\ = \regs|lsr0r~134_combout\ & (\regs|lsr0r~regout\ # \regs|lsr0~combout\ & !\regs|lsr0_d~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0~combout\,
	datab => \regs|lsr0_d~regout\,
	datac => \regs|lsr0r~regout\,
	datad => \regs|lsr0r~134_combout\,
	combout => \regs|lsr0r~135_combout\);

\regs|transmitter|counter[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|Mux17~147_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|transmitter|counter[2]~594_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|counter\(3));

\regs|lsr5~73\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr5~73_combout\ = !\regs|transmitter|fifo_tx|count\(1) & !\regs|transmitter|fifo_tx|count\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001100000011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|fifo_tx|count\(1),
	datac => \regs|transmitter|fifo_tx|count\(0),
	combout => \regs|lsr5~73_combout\);

\regs|transmitter|bit_out~1052\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_out~1052_combout\ = !\regs|lcr\(3) & !\regs|transmitter|bit_counter\(1) & !\regs|transmitter|bit_counter\(2) & !\regs|transmitter|bit_counter\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(3),
	datab => \regs|transmitter|bit_counter\(1),
	datac => \regs|transmitter|bit_counter\(2),
	datad => \regs|transmitter|bit_counter\(0),
	combout => \regs|transmitter|bit_out~1052_combout\);

\regs|iir~318\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|iir~318_combout\ = \regs|rls_int_pnd~regout\ # \regs|thre_int_pnd~regout\ & !\regs|ti_int_pnd~regout\ & !\regs|rda_int~272_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|thre_int_pnd~regout\,
	datab => \regs|ti_int_pnd~regout\,
	datac => \regs|rls_int_pnd~regout\,
	datad => \regs|rda_int~272_combout\,
	combout => \regs|iir~318_combout\);

\regs|transmitter|Mux2~358\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux2~358_combout\ = \regs|transmitter|counter\(0) & \regs|transmitter|WideNor1~23_combout\ & (\regs|transmitter|tstate\(0) # \regs|transmitter|bit_out~1052_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|counter\(0),
	datab => \regs|transmitter|tstate\(0),
	datac => \regs|transmitter|bit_out~1052_combout\,
	datad => \regs|transmitter|WideNor1~23_combout\,
	combout => \regs|transmitter|Mux2~358_combout\);

\regs|receiver|fifo_rx|fifo[1][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|fifo[1][1]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|fifo_rx|fifo[1][1]~6648_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[1][1]~regout\);

\regs|receiver|fifo_rx|Mux62~61\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux62~61_combout\ = \regs|receiver|fifo_rx|bottom\(3) & \regs|receiver|fifo_rx|bottom\(2) # !\regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|fifo[5][1]~regout\ # 
-- !\regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|fifo[1][1]~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100111001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(3),
	datab => \regs|receiver|fifo_rx|bottom\(2),
	datac => \regs|receiver|fifo_rx|fifo[5][1]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[1][1]~regout\,
	combout => \regs|receiver|fifo_rx|Mux62~61_combout\);

\regs|receiver|fifo_rx|fifo[13][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[13][2]~6651_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[13][1]~regout\);

\regs|receiver|fifo_rx|Mux62~62\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux62~62_combout\ = \regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|Mux62~61_combout\ & \regs|receiver|fifo_rx|fifo[13][1]~regout\ # !\regs|receiver|fifo_rx|Mux62~61_combout\ & 
-- (\regs|receiver|fifo_rx|fifo[9][1]~regout\)) # !\regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|Mux62~61_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[13][1]~regout\,
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|fifo[9][1]~regout\,
	datad => \regs|receiver|fifo_rx|Mux62~61_combout\,
	combout => \regs|receiver|fifo_rx|Mux62~62_combout\);

\regs|receiver|fifo_rx|fifo[0][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|fifo[0][1]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|fifo_rx|fifo[0][1]~6672_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[0][1]~regout\);

\regs|receiver|fifo_rx|Mux62~65\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux62~65_combout\ = \regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|fifo[4][1]~regout\ # \regs|receiver|fifo_rx|bottom\(3)) # !\regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|fifo[0][1]~regout\ & 
-- (!\regs|receiver|fifo_rx|bottom\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(2),
	datab => \regs|receiver|fifo_rx|fifo[0][1]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[4][1]~regout\,
	datad => \regs|receiver|fifo_rx|bottom\(3),
	combout => \regs|receiver|fifo_rx|Mux62~65_combout\);

\regs|lsr2_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|Mux62~70_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr2_d~regout\);

\wb_interface|wb_dat_is[26]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[26]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(26));

\wb_interface|wb_dat_is[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(2),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(2));

\regs|receiver|fifo_rx|fifo[11][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[11][0]~6681_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[11][0]~regout\);

\regs|receiver|fifo_rx|fifo[6][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[6][1]~6654_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[6][0]~regout\);

\regs|receiver|fifo_rx|fifo[3][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[3][2]~6684_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[3][0]~regout\);

\wb_interface|wb_dat_is[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[3]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(3));

\regs|receiver|fifo_rx|Mux61~101\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux61~101_combout\ = \regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|bottom\(2)) # !\regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|fifo[6][2]~regout\) # 
-- !\regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|fifo[2][2]~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[2][2]~regout\,
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|fifo[6][2]~regout\,
	datad => \regs|receiver|fifo_rx|bottom\(2),
	combout => \regs|receiver|fifo_rx|Mux61~101_combout\);

\regs|receiver|fifo_rx|fifo[14][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[14][2]~6663_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[14][2]~regout\);

\regs|receiver|fifo_rx|Mux61~102\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux61~102_combout\ = \regs|receiver|fifo_rx|Mux61~101_combout\ & (\regs|receiver|fifo_rx|fifo[14][2]~regout\ # !\regs|receiver|fifo_rx|bottom\(3)) # !\regs|receiver|fifo_rx|Mux61~101_combout\ & 
-- (\regs|receiver|fifo_rx|fifo[10][2]~regout\ & \regs|receiver|fifo_rx|bottom\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Mux61~101_combout\,
	datab => \regs|receiver|fifo_rx|fifo[14][2]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[10][2]~regout\,
	datad => \regs|receiver|fifo_rx|bottom\(3),
	combout => \regs|receiver|fifo_rx|Mux61~102_combout\);

\regs|receiver|fifo_rx|Mux61~103\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux61~103_combout\ = \regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|bottom\(3)) # !\regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|fifo[9][2]~regout\) # 
-- !\regs|receiver|fifo_rx|bottom\(3) & \regs|receiver|fifo_rx|fifo[1][2]~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(2),
	datab => \regs|receiver|fifo_rx|fifo[1][2]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[9][2]~regout\,
	datad => \regs|receiver|fifo_rx|bottom\(3),
	combout => \regs|receiver|fifo_rx|Mux61~103_combout\);

\regs|receiver|fifo_rx|fifo[13][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[13][2]~6651_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[13][2]~regout\);

\regs|receiver|fifo_rx|Mux61~104\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux61~104_combout\ = \regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|Mux61~103_combout\ & (\regs|receiver|fifo_rx|fifo[13][2]~regout\) # !\regs|receiver|fifo_rx|Mux61~103_combout\ & 
-- \regs|receiver|fifo_rx|fifo[5][2]~regout\) # !\regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|Mux61~103_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(2),
	datab => \regs|receiver|fifo_rx|fifo[5][2]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[13][2]~regout\,
	datad => \regs|receiver|fifo_rx|Mux61~103_combout\,
	combout => \regs|receiver|fifo_rx|Mux61~104_combout\);

\regs|receiver|fifo_rx|fifo[4][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[4][2]~6669_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[4][2]~regout\);

\regs|receiver|fifo_rx|fifo[8][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[8][0]~6666_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[8][2]~regout\);

\regs|receiver|fifo_rx|fifo[0][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[0][1]~6672_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[0][2]~regout\);

\regs|receiver|fifo_rx|Mux61~105\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux61~105_combout\ = \regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|bottom\(3) # !\regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|bottom\(3) & \regs|receiver|fifo_rx|fifo[8][2]~regout\ # 
-- !\regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|fifo[0][2]~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100111001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(2),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|fifo[8][2]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[0][2]~regout\,
	combout => \regs|receiver|fifo_rx|Mux61~105_combout\);

\regs|receiver|fifo_rx|fifo[12][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[12][0]~6675_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[12][2]~regout\);

\regs|receiver|fifo_rx|Mux61~106\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux61~106_combout\ = \regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|Mux61~105_combout\ & (\regs|receiver|fifo_rx|fifo[12][2]~regout\) # !\regs|receiver|fifo_rx|Mux61~105_combout\ & 
-- \regs|receiver|fifo_rx|fifo[4][2]~regout\) # !\regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|Mux61~105_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(2),
	datab => \regs|receiver|fifo_rx|Mux61~105_combout\,
	datac => \regs|receiver|fifo_rx|fifo[4][2]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[12][2]~regout\,
	combout => \regs|receiver|fifo_rx|Mux61~106_combout\);

\regs|receiver|fifo_rx|Mux61~107\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux61~107_combout\ = \regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(0) # !\regs|receiver|fifo_rx|bottom\(1) & (\regs|receiver|fifo_rx|bottom\(0) & \regs|receiver|fifo_rx|Mux61~104_combout\ # 
-- !\regs|receiver|fifo_rx|bottom\(0) & (\regs|receiver|fifo_rx|Mux61~106_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100111001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(0),
	datac => \regs|receiver|fifo_rx|Mux61~104_combout\,
	datad => \regs|receiver|fifo_rx|Mux61~106_combout\,
	combout => \regs|receiver|fifo_rx|Mux61~107_combout\);

\regs|receiver|fifo_rx|Mux61~108\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux61~108_combout\ = \regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|bottom\(2)) # !\regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|fifo[7][2]~regout\) # 
-- !\regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|fifo[3][2]~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[3][2]~regout\,
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|fifo[7][2]~regout\,
	datad => \regs|receiver|fifo_rx|bottom\(2),
	combout => \regs|receiver|fifo_rx|Mux61~108_combout\);

\regs|receiver|fifo_rx|Mux61~109\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux61~109_combout\ = \regs|receiver|fifo_rx|Mux61~108_combout\ & (\regs|receiver|fifo_rx|fifo[15][2]~regout\ # !\regs|receiver|fifo_rx|bottom\(3)) # !\regs|receiver|fifo_rx|Mux61~108_combout\ & (\regs|receiver|fifo_rx|bottom\(3) & 
-- \regs|receiver|fifo_rx|fifo[11][2]~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101101010001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Mux61~108_combout\,
	datab => \regs|receiver|fifo_rx|fifo[15][2]~regout\,
	datac => \regs|receiver|fifo_rx|bottom\(3),
	datad => \regs|receiver|fifo_rx|fifo[11][2]~regout\,
	combout => \regs|receiver|fifo_rx|Mux61~109_combout\);

\regs|receiver|fifo_rx|Mux61~110\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux61~110_combout\ = \regs|receiver|fifo_rx|bottom\(1) & (\regs|receiver|fifo_rx|Mux61~107_combout\ & \regs|receiver|fifo_rx|Mux61~109_combout\ # !\regs|receiver|fifo_rx|Mux61~107_combout\ & 
-- (\regs|receiver|fifo_rx|Mux61~102_combout\)) # !\regs|receiver|fifo_rx|bottom\(1) & (\regs|receiver|fifo_rx|Mux61~107_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101101011010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|Mux61~109_combout\,
	datac => \regs|receiver|fifo_rx|Mux61~107_combout\,
	datad => \regs|receiver|fifo_rx|Mux61~102_combout\,
	combout => \regs|receiver|fifo_rx|Mux61~110_combout\);

\regs|lsr4_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|Mux61~110_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr4_d~regout\);

\regs|lsr4r~36\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr4r~36_combout\ = \regs|lsr_mask~combout\ & (\regs|lsr4r~regout\ # \regs|receiver|fifo_rx|Mux61~110_combout\ & !\regs|lsr4_d~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Mux61~110_combout\,
	datab => \regs|lsr4_d~regout\,
	datac => \regs|lsr4r~regout\,
	datad => \regs|lsr_mask~combout\,
	combout => \regs|lsr4r~36_combout\);

\wb_interface|wb_dat_is[21]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(21),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(21));

\wb_interface|wb_dat_is[13]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[13]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(13));

\regs|lsr5_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr5~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr5_d~regout\);

\regs|lsr6_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr6~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr6_d~regout\);

\regs|lsr6r~68\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr6r~68_combout\ = \regs|fifo_write~23_combout\ # \regs|lsr6r~regout\ & (\regs|lsr6~combout\ # !\regs|lsr6_d~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr6~combout\,
	datab => \regs|lsr6_d~regout\,
	datac => \regs|lsr6r~regout\,
	datad => \regs|fifo_write~23_combout\,
	combout => \regs|lsr6r~68_combout\);

\regs|lsr7~553\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~553_combout\ = \regs|receiver|fifo_rx|fifo[6][1]~regout\ # \regs|receiver|fifo_rx|fifo[10][1]~regout\ # \regs|receiver|fifo_rx|fifo[13][1]~regout\ # \regs|receiver|fifo_rx|fifo[2][1]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[6][1]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[10][1]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[13][1]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[2][1]~regout\,
	combout => \regs|lsr7~553_combout\);

\regs|lsr7~557\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~557_combout\ = \regs|receiver|fifo_rx|fifo[8][0]~regout\ # \regs|receiver|fifo_rx|fifo[10][0]~regout\ # \regs|receiver|fifo_rx|fifo[15][1]~regout\ # \regs|receiver|fifo_rx|fifo[9][0]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[8][0]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[10][0]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[15][1]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[9][0]~regout\,
	combout => \regs|lsr7~557_combout\);

\regs|lsr7~558\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~558_combout\ = \regs|receiver|fifo_rx|fifo[4][0]~regout\ # \regs|receiver|fifo_rx|fifo[5][0]~regout\ # \regs|receiver|fifo_rx|fifo[6][0]~regout\ # \regs|receiver|fifo_rx|fifo[11][0]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[4][0]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[5][0]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[6][0]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[11][0]~regout\,
	combout => \regs|lsr7~558_combout\);

\regs|lsr7~559\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~559_combout\ = \regs|receiver|fifo_rx|fifo[7][0]~regout\ # \regs|receiver|fifo_rx|fifo[0][0]~regout\ # \regs|receiver|fifo_rx|fifo[1][0]~regout\ # \regs|receiver|fifo_rx|fifo[2][0]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[7][0]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[0][0]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[1][0]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[2][0]~regout\,
	combout => \regs|lsr7~559_combout\);

\regs|lsr7~560\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~560_combout\ = \regs|receiver|fifo_rx|fifo[3][0]~regout\ # \regs|receiver|fifo_rx|fifo[14][0]~regout\ # \regs|receiver|fifo_rx|fifo[12][0]~regout\ # \regs|receiver|fifo_rx|fifo[13][0]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[3][0]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[14][0]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[12][0]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[13][0]~regout\,
	combout => \regs|lsr7~560_combout\);

\regs|lsr7~561\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~561_combout\ = \regs|lsr7~559_combout\ # \regs|lsr7~558_combout\ # \regs|lsr7~557_combout\ # \regs|lsr7~560_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr7~559_combout\,
	datab => \regs|lsr7~558_combout\,
	datac => \regs|lsr7~557_combout\,
	datad => \regs|lsr7~560_combout\,
	combout => \regs|lsr7~561_combout\);

\regs|lsr7~564\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~564_combout\ = \regs|receiver|fifo_rx|fifo[13][2]~regout\ # \regs|receiver|fifo_rx|fifo[4][2]~regout\ # \regs|receiver|fifo_rx|fifo[0][2]~regout\ # \regs|receiver|fifo_rx|fifo[8][2]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[13][2]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[4][2]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[0][2]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[8][2]~regout\,
	combout => \regs|lsr7~564_combout\);

\regs|receiver|Mux6~736\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux6~736_combout\ = \regs|receiver|rstate\(3) & !\regs|receiver|rframing_error~regout\ # !\regs|receiver|rstate\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(3),
	datac => \regs|receiver|rframing_error~regout\,
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Mux6~736_combout\);

\regs|receiver|Mux6~738\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux6~738_combout\ = \regs|receiver|rstate\(0) & (!\regs|receiver|Equal1~59_combout\) # !\regs|receiver|rstate\(0) & !\regs|receiver|Equal2~31_combout\ & (\regs|receiver|rstate\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011010100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal2~31_combout\,
	datab => \regs|receiver|Equal1~59_combout\,
	datac => \regs|receiver|rstate\(0),
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Mux6~738_combout\);

\regs|receiver|Mux6~739\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux6~739_combout\ = \regs|receiver|rstate\(3) & \regs|receiver|Mux6~737_combout\ & (\regs|receiver|Mux6~736_combout\) # !\regs|receiver|rstate\(3) & (\regs|receiver|Mux6~738_combout\ # \regs|receiver|Mux6~737_combout\ & 
-- \regs|receiver|Mux6~736_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(3),
	datab => \regs|receiver|Mux6~737_combout\,
	datac => \regs|receiver|Mux6~738_combout\,
	datad => \regs|receiver|Mux6~736_combout\,
	combout => \regs|receiver|Mux6~739_combout\);

\regs|receiver|Mux5~711\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux5~711_combout\ = !\regs|receiver|rstate\(0) & \regs|receiver|rf_push~197_combout\ & !\regs|receiver|rstate\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(0),
	datac => \regs|receiver|rf_push~197_combout\,
	datad => \regs|receiver|rstate\(2),
	combout => \regs|receiver|Mux5~711_combout\);

\regs|receiver|Mux5~712\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux5~712_combout\ = \regs|receiver|rstate\(2) & (!\regs|receiver|Mux4~1009_combout\) # !\regs|receiver|rstate\(2) & !\regs|receiver|Equal1~59_combout\ # !\regs|receiver|rstate\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011111101011111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal1~59_combout\,
	datab => \regs|receiver|Mux4~1009_combout\,
	datac => \regs|receiver|rstate\(0),
	datad => \regs|receiver|rstate\(2),
	combout => \regs|receiver|Mux5~712_combout\);

\regs|receiver|Mux5~713\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux5~713_combout\ = \regs|receiver|rstate\(1) & (\regs|receiver|Mux5~711_combout\ # \regs|receiver|Mux5~712_combout\ & !\regs|receiver|rstate\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Mux5~712_combout\,
	datab => \regs|receiver|rstate\(3),
	datac => \regs|receiver|rstate\(1),
	datad => \regs|receiver|Mux5~711_combout\,
	combout => \regs|receiver|Mux5~713_combout\);

\regs|receiver|Mux4~1013\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux4~1013_combout\ = \regs|receiver|rstate\(1) & (\regs|receiver|Equal2~31_combout\) # !\regs|receiver|rstate\(1) & !\regs|receiver|Equal1~59_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100010111000101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal1~59_combout\,
	datab => \regs|receiver|Equal2~31_combout\,
	datac => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Mux4~1013_combout\);

\regs|receiver|Mux3~359\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux3~359_combout\ = \regs|receiver|rstate\(2) & !\regs|receiver|rstate\(1) & (\regs|receiver|Equal1~59_combout\ # \regs|receiver|rstate\(0)) # !\regs|receiver|rstate\(2) & \regs|receiver|Equal1~59_combout\ & \regs|receiver|rstate\(1) & 
-- \regs|receiver|rstate\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010110000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal1~59_combout\,
	datab => \regs|receiver|rstate\(2),
	datac => \regs|receiver|rstate\(1),
	datad => \regs|receiver|rstate\(0),
	combout => \regs|receiver|Mux3~359_combout\);

\regs|receiver|fifo_rx|overrun~58\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|overrun~58_combout\ = !\regs|rf_pop~regout\ & \regs|receiver|fifo_rx|count\(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|rf_pop~regout\,
	datad => \regs|receiver|fifo_rx|count\(4),
	combout => \regs|receiver|fifo_rx|overrun~58_combout\);

\regs|lsr_mask_condition\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr_mask_condition~combout\ = \wb_interface|wb_adr_int[0]~64_combout\ & \regs|lsr_mask_condition~35_combout\ & !\wb_interface|wb_adr_int[1]~63_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \wb_interface|wb_adr_int[0]~64_combout\,
	datac => \regs|lsr_mask_condition~35_combout\,
	datad => \wb_interface|wb_adr_int[1]~63_combout\,
	combout => \regs|lsr_mask_condition~combout\);

\regs|rda_int_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|rda_int~272_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|rda_int_d~regout\);

\regs|rda_int_pnd~311\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rda_int_pnd~311_combout\ = \regs|rda_int_pnd~regout\ & (\regs|ier\(0) # !\regs|rda_int_d~regout\ & \regs|rda_int~272_combout\) # !\regs|rda_int_pnd~regout\ & !\regs|rda_int_d~regout\ & (\regs|rda_int~272_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011001110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|rda_int_pnd~regout\,
	datab => \regs|rda_int_d~regout\,
	datac => \regs|ier\(0),
	datad => \regs|rda_int~272_combout\,
	combout => \regs|rda_int_pnd~311_combout\);

\regs|rda_int_pnd~312\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rda_int_pnd~312_combout\ = \regs|fcr\(0) & !\regs|receiver|fifo_rx|count\(1) & (\regs|receiver|fifo_rx|count\(0) $ !\regs|fcr\(1)) # !\regs|fcr\(0) & !\regs|receiver|fifo_rx|count\(0) & (\regs|receiver|fifo_rx|count\(1) $ \regs|fcr\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100100010100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(0),
	datab => \regs|fcr\(0),
	datac => \regs|receiver|fifo_rx|count\(1),
	datad => \regs|fcr\(1),
	combout => \regs|rda_int_pnd~312_combout\);

\regs|LessThan0~104\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|LessThan0~104_combout\ = \regs|receiver|fifo_rx|count\(3) $ !\regs|fcr\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|receiver|fifo_rx|count\(3),
	datad => \regs|fcr\(1),
	combout => \regs|LessThan0~104_combout\);

\regs|rda_int_pnd~313\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rda_int_pnd~313_combout\ = !\regs|LessThan0~104_combout\ & !\regs|receiver|fifo_rx|count\(4) & (\regs|fcr\(0) $ \regs|receiver|fifo_rx|count\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|fcr\(0),
	datab => \regs|receiver|fifo_rx|count\(2),
	datac => \regs|LessThan0~104_combout\,
	datad => \regs|receiver|fifo_rx|count\(4),
	combout => \regs|rda_int_pnd~313_combout\);

\regs|rda_int_pnd~314\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rda_int_pnd~314_combout\ = \regs|rda_int_pnd~311_combout\ & (\regs|fifo_read~combout\ # !\regs|rda_int_pnd~312_combout\ # !\regs|rda_int_pnd~313_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|fifo_read~combout\,
	datab => \regs|rda_int_pnd~313_combout\,
	datac => \regs|rda_int_pnd~311_combout\,
	datad => \regs|rda_int_pnd~312_combout\,
	combout => \regs|rda_int_pnd~314_combout\);

\regs|thre_int_pnd~118\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|thre_int_pnd~118_combout\ = !\regs|iir\(2) & \regs|iir\(1) & \wb_interface|wb_adr_int[1]~63_combout\ & \regs|iir\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|iir\(2),
	datab => \regs|iir\(1),
	datac => \wb_interface|wb_adr_int[1]~63_combout\,
	datad => \regs|iir\(0),
	combout => \regs|thre_int_pnd~118_combout\);

\regs|thre_int_pnd~119\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|thre_int_pnd~119_combout\ = \regs|thre_int_pnd~118_combout\ & !\wb_interface|wb_adr_int[0]~64_combout\ & \regs|lsr_mask_condition~36_combout\ & !\wb_interface|wb_adr_is\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|thre_int_pnd~118_combout\,
	datab => \wb_interface|wb_adr_int[0]~64_combout\,
	datac => \regs|lsr_mask_condition~36_combout\,
	datad => \wb_interface|wb_adr_is\(2),
	combout => \regs|thre_int_pnd~119_combout\);

\regs|ti_int~99\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ti_int~99_combout\ = \regs|receiver|counter_t\(0) & \regs|receiver|counter_t\(2) & \regs|receiver|counter_t\(3) & \regs|receiver|counter_t\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_t\(0),
	datab => \regs|receiver|counter_t\(2),
	datac => \regs|receiver|counter_t\(3),
	datad => \regs|receiver|counter_t\(1),
	combout => \regs|ti_int~99_combout\);

\regs|ti_int_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|ti_int~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|ti_int_d~regout\);

\regs|rls_int~40\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rls_int~40_combout\ = \regs|lsr4r~regout\ # \regs|lsr1r~regout\ # \regs|lsr3r~regout\ # \regs|lsr2r~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr4r~regout\,
	datab => \regs|lsr1r~regout\,
	datac => \regs|lsr3r~regout\,
	datad => \regs|lsr2r~regout\,
	combout => \regs|rls_int~40_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[3]~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(3));

\regs|transmitter|parity_xor\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|Mux0~41_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|transmitter|parity_xor~22_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|parity_xor~regout\);

\regs|transmitter|bit_out~1055\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_out~1055_combout\ = \regs|lcr\(4) $ (\regs|lcr\(5) # !\regs|transmitter|parity_xor~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|lcr\(4),
	datac => \regs|lcr\(5),
	datad => \regs|transmitter|parity_xor~regout\,
	combout => \regs|transmitter|bit_out~1055_combout\);

\regs|transmitter|bit_out~1056\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_out~1056_combout\ = \regs|transmitter|LessThan0~50_combout\ & \regs|transmitter|shift_out\(0) # !\regs|transmitter|LessThan0~50_combout\ & (\regs|lcr\(3) & \regs|transmitter|bit_out~1055_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|shift_out\(0),
	datab => \regs|transmitter|LessThan0~50_combout\,
	datac => \regs|lcr\(3),
	datad => \regs|transmitter|bit_out~1055_combout\,
	combout => \regs|transmitter|bit_out~1056_combout\);

\regs|transmitter|bit_out~1057\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_out~1057_combout\ = \regs|transmitter|bit_out~1054_combout\ & (\regs|transmitter|bit_out~1056_combout\ # \regs|transmitter|bit_out~1052_combout\ & \regs|transmitter|bit_out~regout\) # !\regs|transmitter|bit_out~1054_combout\ & 
-- (\regs|transmitter|bit_out~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110010110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|bit_out~1052_combout\,
	datab => \regs|transmitter|bit_out~1054_combout\,
	datac => \regs|transmitter|bit_out~regout\,
	datad => \regs|transmitter|bit_out~1056_combout\,
	combout => \regs|transmitter|bit_out~1057_combout\);

\regs|WideOr1~105\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr1~105_combout\ = \regs|dl\(8) # \regs|dl\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|dl\(8),
	datad => \regs|dl\(0),
	combout => \regs|WideOr1~105_combout\);

\regs|WideOr1~108\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr1~108_combout\ = \regs|dl\(5) # \regs|dl\(13) # \regs|dl\(4) # \regs|dl\(12)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(5),
	datab => \regs|dl\(13),
	datac => \regs|dl\(4),
	datad => \regs|dl\(12),
	combout => \regs|WideOr1~108_combout\);

\regs|WideOr0~112\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr0~112_combout\ = \regs|dlc\(0) # \regs|dlc\(3) # \regs|dlc\(2) # \regs|dlc\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(0),
	datab => \regs|dlc\(3),
	datac => \regs|dlc\(2),
	datad => \regs|dlc\(1),
	combout => \regs|WideOr0~112_combout\);

\regs|receiver|rshift[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector23~15_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rshift[0]~1507_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rshift\(0));

\regs|transmitter|Mux17~147\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux17~147_combout\ = \regs|transmitter|WideNor1~combout\ & \regs|transmitter|Add1~71_combout\ # !\regs|transmitter|WideNor1~combout\ & (!\regs|transmitter|tstate\(2) # !\regs|receiver|Decoder4~13_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010001110101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|Add1~71_combout\,
	datab => \regs|receiver|Decoder4~13_combout\,
	datac => \regs|transmitter|WideNor1~combout\,
	datad => \regs|transmitter|tstate\(2),
	combout => \regs|transmitter|Mux17~147_combout\);

\regs|transmitter|bit_counter[2]~660\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_counter[2]~660_combout\ = \regs|transmitter|bit_counter\(0) # \regs|transmitter|bit_counter\(1) # !\regs|enable~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|bit_counter\(0),
	datac => \regs|enable~regout\,
	datad => \regs|transmitter|bit_counter\(1),
	combout => \regs|transmitter|bit_counter[2]~660_combout\);

\regs|transmitter|bit_counter[0]~663\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_counter[0]~663_combout\ = \regs|transmitter|tstate\(0) & !\regs|transmitter|tstate\(1) & \regs|transmitter|tstate\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(0),
	datac => \regs|transmitter|tstate\(1),
	datad => \regs|transmitter|tstate\(2),
	combout => \regs|transmitter|bit_counter[0]~663_combout\);

\regs|receiver|fifo_rx|overrun~59\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|overrun~59_combout\ = \regs|receiver|fifo_rx|overrun~58_combout\ & \regs|receiver|rf_push_pulse~combout\ & \regs|lsr0r~131_combout\ & !\regs|receiver|fifo_rx|count\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|overrun~58_combout\,
	datab => \regs|receiver|rf_push_pulse~combout\,
	datac => \regs|lsr0r~131_combout\,
	datad => \regs|receiver|fifo_rx|count\(0),
	combout => \regs|receiver|fifo_rx|overrun~59_combout\);

\regs|receiver|fifo_rx|Decoder1~272\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~272_combout\ = \regs|receiver|fifo_rx|top\(0) & !\regs|receiver|fifo_rx|top\(2) & \regs|receiver|fifo_rx|top\(3) & !\regs|receiver|fifo_rx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(0),
	datab => \regs|receiver|fifo_rx|top\(2),
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Decoder1~272_combout\);

\regs|receiver|fifo_rx|fifo[9][2]~6640\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[9][2]~6640_combout\ = \regs|receiver|rf_push_pulse~combout\ & (\regs|receiver|fifo_rx|count\(4) & !\regs|rf_pop~regout\ # !\regs|receiver|fifo_rx|Decoder1~272_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000010111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|receiver|fifo_rx|Decoder1~272_combout\,
	datac => \regs|receiver|rf_push_pulse~combout\,
	datad => \regs|rf_pop~regout\,
	combout => \regs|receiver|fifo_rx|fifo[9][2]~6640_combout\);

\regs|receiver|fifo_rx|Decoder1~273\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~273_combout\ = \regs|receiver|fifo_rx|top\(0) & \regs|receiver|fifo_rx|top\(2) & !\regs|receiver|fifo_rx|top\(3) & !\regs|receiver|fifo_rx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(0),
	datab => \regs|receiver|fifo_rx|top\(2),
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Decoder1~273_combout\);

\regs|receiver|fifo_rx|Decoder0~273\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~273_combout\ = !\regs|receiver|fifo_rx|bottom\(1) & !\regs|receiver|fifo_rx|bottom\(3) & \regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|bottom\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|receiver|fifo_rx|Decoder0~273_combout\);

\regs|receiver|fifo_rx|fifo[5][0]~6644\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[5][0]~6644_combout\ = !\regs|receiver|fifo_rx|count\(4) & !\regs|receiver|fifo_rx|count\(0) & \regs|lsr0r~131_combout\ # !\regs|receiver|fifo_rx|Decoder0~273_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101011101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder0~273_combout\,
	datab => \regs|receiver|fifo_rx|count\(4),
	datac => \regs|receiver|fifo_rx|count\(0),
	datad => \regs|lsr0r~131_combout\,
	combout => \regs|receiver|fifo_rx|fifo[5][0]~6644_combout\);

\regs|receiver|fifo_rx|Decoder1~274\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~274_combout\ = \regs|receiver|fifo_rx|top\(0) & !\regs|receiver|fifo_rx|top\(2) & !\regs|receiver|fifo_rx|top\(3) & !\regs|receiver|fifo_rx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(0),
	datab => \regs|receiver|fifo_rx|top\(2),
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Decoder1~274_combout\);

\regs|receiver|fifo_rx|Decoder0~274\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~274_combout\ = !\regs|receiver|fifo_rx|bottom\(1) & !\regs|receiver|fifo_rx|bottom\(3) & !\regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|bottom\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|receiver|fifo_rx|Decoder0~274_combout\);

\regs|receiver|fifo_rx|fifo[1][1]~6647\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[1][1]~6647_combout\ = !\regs|receiver|fifo_rx|count\(4) & !\regs|receiver|fifo_rx|count\(0) & \regs|lsr0r~131_combout\ # !\regs|receiver|fifo_rx|Decoder0~274_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101011101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder0~274_combout\,
	datab => \regs|receiver|fifo_rx|count\(4),
	datac => \regs|receiver|fifo_rx|count\(0),
	datad => \regs|lsr0r~131_combout\,
	combout => \regs|receiver|fifo_rx|fifo[1][1]~6647_combout\);

\regs|receiver|fifo_rx|Decoder0~275\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~275_combout\ = !\regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(3) & \regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|bottom\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|receiver|fifo_rx|Decoder0~275_combout\);

\regs|receiver|fifo_rx|Decoder1~278\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~278_combout\ = \regs|receiver|fifo_rx|top\(1) & !\regs|receiver|fifo_rx|top\(3) & !\regs|receiver|fifo_rx|top\(2) & !\regs|receiver|fifo_rx|top\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(1),
	datab => \regs|receiver|fifo_rx|top\(3),
	datac => \regs|receiver|fifo_rx|top\(2),
	datad => \regs|receiver|fifo_rx|top\(0),
	combout => \regs|receiver|fifo_rx|Decoder1~278_combout\);

\regs|receiver|fifo_rx|Decoder0~278\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~278_combout\ = \regs|receiver|fifo_rx|bottom\(1) & !\regs|receiver|fifo_rx|bottom\(3) & !\regs|receiver|fifo_rx|bottom\(2) & !\regs|receiver|fifo_rx|bottom\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|receiver|fifo_rx|Decoder0~278_combout\);

\regs|receiver|fifo_rx|fifo[2][2]~6659\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[2][2]~6659_combout\ = !\regs|receiver|fifo_rx|count\(4) & \regs|lsr0r~131_combout\ & !\regs|receiver|fifo_rx|count\(0) # !\regs|receiver|fifo_rx|Decoder0~278_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111101001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|lsr0r~131_combout\,
	datac => \regs|receiver|fifo_rx|Decoder0~278_combout\,
	datad => \regs|receiver|fifo_rx|count\(0),
	combout => \regs|receiver|fifo_rx|fifo[2][2]~6659_combout\);

\regs|receiver|fifo_rx|Decoder0~279\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~279_combout\ = \regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(3) & \regs|receiver|fifo_rx|bottom\(2) & !\regs|receiver|fifo_rx|bottom\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|receiver|fifo_rx|Decoder0~279_combout\);

\regs|receiver|fifo_rx|Decoder1~280\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~280_combout\ = !\regs|receiver|fifo_rx|top\(1) & !\regs|receiver|fifo_rx|top\(0) & !\regs|receiver|fifo_rx|top\(2) & \regs|receiver|fifo_rx|top\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(1),
	datab => \regs|receiver|fifo_rx|top\(0),
	datac => \regs|receiver|fifo_rx|top\(2),
	datad => \regs|receiver|fifo_rx|top\(3),
	combout => \regs|receiver|fifo_rx|Decoder1~280_combout\);

\regs|receiver|fifo_rx|Decoder0~280\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~280_combout\ = !\regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(3) & !\regs|receiver|fifo_rx|bottom\(2) & !\regs|receiver|fifo_rx|bottom\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|receiver|fifo_rx|Decoder0~280_combout\);

\regs|receiver|fifo_rx|Decoder1~281\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~281_combout\ = !\regs|receiver|fifo_rx|top\(1) & \regs|receiver|fifo_rx|top\(2) & !\regs|receiver|fifo_rx|top\(3) & !\regs|receiver|fifo_rx|top\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(1),
	datab => \regs|receiver|fifo_rx|top\(2),
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(0),
	combout => \regs|receiver|fifo_rx|Decoder1~281_combout\);

\regs|receiver|fifo_rx|fifo[4][2]~6667\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[4][2]~6667_combout\ = \regs|receiver|rf_push_pulse~combout\ & (!\regs|rf_pop~regout\ & \regs|receiver|fifo_rx|count\(4) # !\regs|receiver|fifo_rx|Decoder1~281_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010111100100111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rf_push_pulse~combout\,
	datab => \regs|receiver|fifo_rx|Decoder1~281_combout\,
	datac => \regs|rf_pop~regout\,
	datad => \regs|receiver|fifo_rx|count\(4),
	combout => \regs|receiver|fifo_rx|fifo[4][2]~6667_combout\);

\regs|receiver|fifo_rx|Decoder1~282\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~282_combout\ = !\regs|receiver|fifo_rx|top\(2) & !\regs|receiver|fifo_rx|top\(0) & !\regs|receiver|fifo_rx|top\(3) & !\regs|receiver|fifo_rx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(2),
	datab => \regs|receiver|fifo_rx|top\(0),
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Decoder1~282_combout\);

\regs|receiver|fifo_rx|Decoder0~282\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~282_combout\ = !\regs|receiver|fifo_rx|bottom\(1) & !\regs|receiver|fifo_rx|bottom\(2) & !\regs|receiver|fifo_rx|bottom\(0) & !\regs|receiver|fifo_rx|bottom\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(2),
	datac => \regs|receiver|fifo_rx|bottom\(0),
	datad => \regs|receiver|fifo_rx|bottom\(3),
	combout => \regs|receiver|fifo_rx|Decoder0~282_combout\);

\regs|receiver|fifo_rx|Decoder0~283\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~283_combout\ = !\regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(2) & !\regs|receiver|fifo_rx|bottom\(0) & \regs|receiver|fifo_rx|bottom\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(2),
	datac => \regs|receiver|fifo_rx|bottom\(0),
	datad => \regs|receiver|fifo_rx|bottom\(3),
	combout => \regs|receiver|fifo_rx|Decoder0~283_combout\);

\regs|receiver|fifo_rx|fifo[12][0]~6674\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[12][0]~6674_combout\ = !\regs|receiver|fifo_rx|count\(0) & !\regs|receiver|fifo_rx|count\(4) & \regs|lsr0r~131_combout\ # !\regs|receiver|fifo_rx|Decoder0~283_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101011101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder0~283_combout\,
	datab => \regs|receiver|fifo_rx|count\(0),
	datac => \regs|receiver|fifo_rx|count\(4),
	datad => \regs|lsr0r~131_combout\,
	combout => \regs|receiver|fifo_rx|fifo[12][0]~6674_combout\);

\regs|receiver|fifo_rx|Decoder0~285\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~285_combout\ = \regs|receiver|fifo_rx|bottom\(3) & \regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(0) & !\regs|receiver|fifo_rx|bottom\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(3),
	datab => \regs|receiver|fifo_rx|bottom\(1),
	datac => \regs|receiver|fifo_rx|bottom\(0),
	datad => \regs|receiver|fifo_rx|bottom\(2),
	combout => \regs|receiver|fifo_rx|Decoder0~285_combout\);

\regs|receiver|fifo_rx|fifo[11][0]~6680\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[11][0]~6680_combout\ = !\regs|receiver|fifo_rx|count\(4) & \regs|lsr0r~131_combout\ & !\regs|receiver|fifo_rx|count\(0) # !\regs|receiver|fifo_rx|Decoder0~285_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001101110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|receiver|fifo_rx|Decoder0~285_combout\,
	datac => \regs|lsr0r~131_combout\,
	datad => \regs|receiver|fifo_rx|count\(0),
	combout => \regs|receiver|fifo_rx|fifo[11][0]~6680_combout\);

\regs|receiver|fifo_rx|Decoder1~286\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~286_combout\ = !\regs|receiver|fifo_rx|top\(3) & \regs|receiver|fifo_rx|top\(0) & !\regs|receiver|fifo_rx|top\(2) & \regs|receiver|fifo_rx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(3),
	datab => \regs|receiver|fifo_rx|top\(0),
	datac => \regs|receiver|fifo_rx|top\(2),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Decoder1~286_combout\);

\regs|receiver|fifo_rx|Decoder0~287\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~287_combout\ = \regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|bottom\(0) & \regs|receiver|fifo_rx|bottom\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(2),
	datac => \regs|receiver|fifo_rx|bottom\(0),
	datad => \regs|receiver|fifo_rx|bottom\(3),
	combout => \regs|receiver|fifo_rx|Decoder0~287_combout\);

\regs|receiver|rframing_error~195\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rframing_error~195_combout\ = \regs|receiver|rstate\(2) & !\regs|receiver|rstate\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rstate\(2),
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|rframing_error~195_combout\);

\regs|receiver|rframing_error~196\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rframing_error~196_combout\ = !\regs|receiver|rstate\(3) & \regs|receiver|rframing_error~195_combout\ & !\regs|receiver|rstate\(0) & \regs|enable~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(3),
	datab => \regs|receiver|rframing_error~195_combout\,
	datac => \regs|receiver|rstate\(0),
	datad => \regs|enable~regout\,
	combout => \regs|receiver|rframing_error~196_combout\);

\regs|receiver|Equal2~32\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Equal2~32_combout\ = !\regs|receiver|rcounter16\(0) & !\regs|receiver|rcounter16\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001100000011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rcounter16\(0),
	datac => \regs|receiver|rcounter16\(1),
	combout => \regs|receiver|Equal2~32_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux38~26_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(10));

\regs|transmitter|fifo_tx|tfifo|ram~18\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux38~26_combout\,
	sload => VCC,
	ena => \regs|transmitter|fifo_tx|tfifo|ram~823_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram~18_regout\);

\regs|transmitter|fifo_tx|tfifo|ram~824\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~824_combout\ = \regs|receiver|fifo_rx|rfifo|ram~15_regout\ & (\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(1)) # !\regs|receiver|fifo_rx|rfifo|ram~15_regout\ & 
-- \regs|transmitter|fifo_tx|tfifo|ram~18_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	datac => \regs|transmitter|fifo_tx|tfifo|ram~18_regout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(1),
	combout => \regs|transmitter|fifo_tx|tfifo|ram~824_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[14]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux34~26_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(14));

\regs|transmitter|fifo_tx|tfifo|ram~26\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux34~26_combout\,
	sload => VCC,
	ena => \regs|transmitter|fifo_tx|tfifo|ram~823_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram~26_regout\);

\regs|transmitter|fifo_tx|tfifo|ram~825\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~825_combout\ = \regs|receiver|fifo_rx|rfifo|ram~15_regout\ & (\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(5)) # !\regs|receiver|fifo_rx|rfifo|ram~15_regout\ & 
-- \regs|transmitter|fifo_tx|tfifo|ram~26_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	datac => \regs|transmitter|fifo_tx|tfifo|ram~26_regout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(5),
	combout => \regs|transmitter|fifo_tx|tfifo|ram~825_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[13]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[13]~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(13));

\regs|transmitter|fifo_tx|tfifo|ram~24\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux35~26_combout\,
	sload => VCC,
	ena => \regs|transmitter|fifo_tx|tfifo|ram~823_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram~24_regout\);

\regs|transmitter|fifo_tx|tfifo|ram~826\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~826_combout\ = \regs|receiver|fifo_rx|rfifo|ram~15_regout\ & (\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(4)) # !\regs|receiver|fifo_rx|rfifo|ram~15_regout\ & 
-- \regs|transmitter|fifo_tx|tfifo|ram~24_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	datac => \regs|transmitter|fifo_tx|tfifo|ram~24_regout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(4),
	combout => \regs|transmitter|fifo_tx|tfifo|ram~826_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux37~26_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(11));

\regs|transmitter|fifo_tx|tfifo|ram~20\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux37~26_combout\,
	sload => VCC,
	ena => \regs|transmitter|fifo_tx|tfifo|ram~823_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram~20_regout\);

\regs|transmitter|fifo_tx|tfifo|ram~827\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~827_combout\ = \regs|receiver|fifo_rx|rfifo|ram~15_regout\ & (\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(2)) # !\regs|receiver|fifo_rx|rfifo|ram~15_regout\ & 
-- \regs|transmitter|fifo_tx|tfifo|ram~20_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	datac => \regs|transmitter|fifo_tx|tfifo|ram~20_regout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(2),
	combout => \regs|transmitter|fifo_tx|tfifo|ram~827_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux36~26_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(12));

\regs|transmitter|fifo_tx|tfifo|ram~22\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux36~26_combout\,
	ena => \regs|transmitter|fifo_tx|tfifo|ram~823_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram~22_regout\);

\regs|transmitter|fifo_tx|tfifo|ram~828\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~828_combout\ = \regs|receiver|fifo_rx|rfifo|ram~15_regout\ & \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(3) # !\regs|receiver|fifo_rx|rfifo|ram~15_regout\ & 
-- (\regs|transmitter|fifo_tx|tfifo|ram~22_regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	datac => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(3),
	datad => \regs|transmitter|fifo_tx|tfifo|ram~22_regout\,
	combout => \regs|transmitter|fifo_tx|tfifo|ram~828_combout\);

\regs|transmitter|Mux0~38\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux0~38_combout\ = \regs|transmitter|shift_out[1]~82_combout\ $ \regs|transmitter|fifo_tx|tfifo|ram~821_combout\ $ \regs|transmitter|shift_out[2]~83_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|shift_out[1]~82_combout\,
	datac => \regs|transmitter|fifo_tx|tfifo|ram~821_combout\,
	datad => \regs|transmitter|shift_out[2]~83_combout\,
	combout => \regs|transmitter|Mux0~38_combout\);

\regs|transmitter|Mux0~39\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux0~39_combout\ = \regs|transmitter|shift_out[3]~84_combout\ $ \regs|transmitter|Mux0~38_combout\ $ \regs|transmitter|shift_out[0]~81_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010101011010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|shift_out[3]~84_combout\,
	datac => \regs|transmitter|Mux0~38_combout\,
	datad => \regs|transmitter|shift_out[0]~81_combout\,
	combout => \regs|transmitter|Mux0~39_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[15]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[15]~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(15));

\regs|transmitter|fifo_tx|tfifo|ram~28\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux33~26_combout\,
	sload => VCC,
	ena => \regs|transmitter|fifo_tx|tfifo|ram~823_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram~28_regout\);

\regs|transmitter|fifo_tx|tfifo|ram~829\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~829_combout\ = \regs|receiver|fifo_rx|rfifo|ram~15_regout\ & (\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(6)) # !\regs|receiver|fifo_rx|rfifo|ram~15_regout\ & 
-- \regs|transmitter|fifo_tx|tfifo|ram~28_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	datac => \regs|transmitter|fifo_tx|tfifo|ram~28_regout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(6),
	combout => \regs|transmitter|fifo_tx|tfifo|ram~829_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[16]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux32~228_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(16));

\regs|transmitter|fifo_tx|tfifo|ram~30\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux32~228_combout\,
	sload => VCC,
	ena => \regs|transmitter|fifo_tx|tfifo|ram~823_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram~30_regout\);

\regs|transmitter|fifo_tx|tfifo|ram~830\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~830_combout\ = \regs|receiver|fifo_rx|rfifo|ram~15_regout\ & (\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(7)) # !\regs|receiver|fifo_rx|rfifo|ram~15_regout\ & 
-- \regs|transmitter|fifo_tx|tfifo|ram~30_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	datac => \regs|transmitter|fifo_tx|tfifo|ram~30_regout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(7),
	combout => \regs|transmitter|fifo_tx|tfifo|ram~830_combout\);

\regs|transmitter|fifo_tx|tfifo|ram~831\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~831_combout\ = \regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(16) # !\regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & 
-- (\regs|transmitter|fifo_tx|tfifo|ram~830_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(16),
	datab => \regs|transmitter|fifo_tx|tfifo|ram~820_combout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram~830_combout\,
	combout => \regs|transmitter|fifo_tx|tfifo|ram~831_combout\);

\regs|transmitter|Mux0~40\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux0~40_combout\ = \regs|lcr\(1) & \regs|lcr\(0) # !\regs|lcr\(1) & (\regs|transmitter|shift_out[5]~86_combout\ $ (!\regs|lcr\(0) & \regs|transmitter|fifo_tx|tfifo|ram~831_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101110011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(0),
	datab => \regs|lcr\(1),
	datac => \regs|transmitter|fifo_tx|tfifo|ram~831_combout\,
	datad => \regs|transmitter|shift_out[5]~86_combout\,
	combout => \regs|transmitter|Mux0~40_combout\);

\regs|transmitter|Mux0~41\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux0~41_combout\ = \regs|transmitter|Mux0~39_combout\ $ (\regs|transmitter|Mux0~40_combout\ & !\regs|lcr\(1) & !\regs|transmitter|shift_out[4]~85_combout\ # !\regs|transmitter|Mux0~40_combout\ & 
-- (\regs|transmitter|shift_out[4]~85_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100101100110100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(1),
	datab => \regs|transmitter|Mux0~40_combout\,
	datac => \regs|transmitter|shift_out[4]~85_combout\,
	datad => \regs|transmitter|Mux0~39_combout\,
	combout => \regs|transmitter|Mux0~41_combout\);

\regs|Add0~930\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~930_combout\ = \regs|start_dlc~regout\ & (\regs|dl\(1)) # !\regs|start_dlc~regout\ & (\regs|dlc\(1) # \regs|dl\(1) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011110010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(1),
	datab => \regs|start_dlc~regout\,
	datac => \regs|dl\(1),
	datad => \regs|WideOr0~116_combout\,
	combout => \regs|Add0~930_combout\);

\regs|Add0~936\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~936_combout\ = \regs|start_dlc~regout\ & (\regs|dl\(7)) # !\regs|start_dlc~regout\ & (\regs|dlc\(7) # \regs|dl\(7) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011110010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(7),
	datab => \regs|start_dlc~regout\,
	datac => \regs|dl\(7),
	datad => \regs|WideOr0~116_combout\,
	combout => \regs|Add0~936_combout\);

\regs|Add0~938\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~938_combout\ = \regs|start_dlc~regout\ & (\regs|dl\(9)) # !\regs|start_dlc~regout\ & (\regs|dlc\(9) # \regs|dl\(9) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011110010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(9),
	datab => \regs|start_dlc~regout\,
	datac => \regs|dl\(9),
	datad => \regs|WideOr0~116_combout\,
	combout => \regs|Add0~938_combout\);

\regs|Add0~940\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~940_combout\ = \regs|start_dlc~regout\ & (\regs|dl\(11)) # !\regs|start_dlc~regout\ & (\regs|dlc\(11) # !\regs|WideOr0~116_combout\ & \regs|dl\(11))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111100100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(11),
	datab => \regs|start_dlc~regout\,
	datac => \regs|WideOr0~116_combout\,
	datad => \regs|dl\(11),
	combout => \regs|Add0~940_combout\);

\regs|Add0~942\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~942_combout\ = \regs|start_dlc~regout\ & (\regs|dl\(13)) # !\regs|start_dlc~regout\ & (\regs|dlc\(13) # \regs|dl\(13) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100101011001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(13),
	datab => \regs|dl\(13),
	datac => \regs|start_dlc~regout\,
	datad => \regs|WideOr0~116_combout\,
	combout => \regs|Add0~942_combout\);

\regs|Add0~944\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~944_combout\ = \regs|start_dlc~regout\ & (\regs|dl\(15)) # !\regs|start_dlc~regout\ & (\regs|dlc\(15) # \regs|dl\(15) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110010101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(15),
	datab => \regs|dl\(15),
	datac => \regs|WideOr0~116_combout\,
	datad => \regs|start_dlc~regout\,
	combout => \regs|Add0~944_combout\);

\regs|receiver|Selector23~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector23~15_combout\ = \regs|receiver|rshift\(1) & !\regs|receiver|rstate\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rshift\(1),
	datad => \regs|receiver|rstate\(2),
	combout => \regs|receiver|Selector23~15_combout\);

\regs|receiver|rparity_error\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rparity_error~400_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rparity_error~regout\);

\regs|receiver|rf_data_in[0]~632\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rf_data_in[0]~632_combout\ = \regs|receiver|rframing_error~regout\ & \regs|receiver|Selector11~33_combout\ & (!\regs|receiver|Equal0~133_combout\ # !\regs|receiver|Equal0~134_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rframing_error~regout\,
	datab => \regs|receiver|Equal0~134_combout\,
	datac => \regs|receiver|Equal0~133_combout\,
	datad => \regs|receiver|Selector11~33_combout\,
	combout => \regs|receiver|rf_data_in[0]~632_combout\);

\regs|receiver|Selector10~14\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector10~14_combout\ = \regs|receiver|rstate\(0) # \regs|receiver|rstate\(2) # \regs|receiver|rstate\(1) $ \regs|receiver|rstate\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(1),
	datab => \regs|receiver|rstate\(0),
	datac => \regs|receiver|rstate\(2),
	datad => \regs|receiver|rstate\(3),
	combout => \regs|receiver|Selector10~14_combout\);

\regs|receiver|rf_data_in[2]~635\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rf_data_in[2]~635_combout\ = \regs|receiver|Equal0~133_combout\ & \regs|receiver|rf_data_in[0]~633_combout\ & \regs|receiver|Selector11~33_combout\ & \regs|receiver|Equal0~134_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal0~133_combout\,
	datab => \regs|receiver|rf_data_in[0]~633_combout\,
	datac => \regs|receiver|Selector11~33_combout\,
	datad => \regs|receiver|Equal0~134_combout\,
	combout => \regs|receiver|rf_data_in[2]~635_combout\);

\regs|receiver|rshift[6]~1509\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift[6]~1509_combout\ = !\regs|receiver|rstate\(3) & !\regs|receiver|rstate\(0) & \regs|receiver|rstate\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(3),
	datac => \regs|receiver|rstate\(0),
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|rshift[6]~1509_combout\);

\regs|receiver|rparity\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rparity~156_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rparity~regout\);

\regs|receiver|rparity_xor\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rparity_xor~29_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rparity_xor~regout\);

\regs|receiver|Selector12~416\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector12~416_combout\ = \regs|lcr\(4) $ (\regs|lcr\(5) & (!\regs|receiver|rparity~regout\) # !\regs|lcr\(5) & !\regs|receiver|rparity_xor~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001000011101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rparity_xor~regout\,
	datab => \regs|lcr\(5),
	datac => \regs|receiver|rparity~regout\,
	datad => \regs|lcr\(4),
	combout => \regs|receiver|Selector12~416_combout\);

\regs|receiver|Selector12~417\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector12~417_combout\ = \regs|receiver|rstate\(1) & \regs|receiver|rparity_error~regout\ & (!\regs|receiver|Mux4~1009_combout\) # !\regs|receiver|rstate\(1) & (\regs|receiver|Selector12~416_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000010111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rparity_error~regout\,
	datab => \regs|receiver|rstate\(1),
	datac => \regs|receiver|Selector12~416_combout\,
	datad => \regs|receiver|Mux4~1009_combout\,
	combout => \regs|receiver|Selector12~417_combout\);

\regs|receiver|rparity_error~399\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rparity_error~399_combout\ = \regs|receiver|rstate\(0) & \regs|receiver|rstate\(2) & \regs|enable~regout\ & !\regs|receiver|rstate\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(0),
	datab => \regs|receiver|rstate\(2),
	datac => \regs|enable~regout\,
	datad => \regs|receiver|rstate\(3),
	combout => \regs|receiver|rparity_error~399_combout\);

\regs|receiver|rparity_error~400\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rparity_error~400_combout\ = \regs|receiver|rparity_error~399_combout\ & (\regs|receiver|Selector12~417_combout\) # !\regs|receiver|rparity_error~399_combout\ & \regs|receiver|rparity_error~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rparity_error~399_combout\,
	datac => \regs|receiver|rparity_error~regout\,
	datad => \regs|receiver|Selector12~417_combout\,
	combout => \regs|receiver|rparity_error~400_combout\);

\regs|receiver|rparity~156\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rparity~156_combout\ = \regs|receiver|rparity~155_combout\ & (\regs|receiver|rparity~157_combout\ & (\regs|serial_in~34_combout\) # !\regs|receiver|rparity~157_combout\ & \regs|receiver|rparity~regout\) # 
-- !\regs|receiver|rparity~155_combout\ & (\regs|receiver|rparity~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rparity~155_combout\,
	datab => \regs|receiver|rparity~157_combout\,
	datac => \regs|receiver|rparity~regout\,
	datad => \regs|serial_in~34_combout\,
	combout => \regs|receiver|rparity~156_combout\);

\regs|receiver|WideXor0~53\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|WideXor0~53_combout\ = \regs|receiver|rshift\(2) $ \regs|receiver|rshift\(1) $ \regs|receiver|rshift\(3) $ \regs|receiver|rshift\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110010110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rshift\(2),
	datab => \regs|receiver|rshift\(1),
	datac => \regs|receiver|rshift\(3),
	datad => \regs|receiver|rshift\(0),
	combout => \regs|receiver|WideXor0~53_combout\);

\regs|receiver|WideXor0~54\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|WideXor0~54_combout\ = \regs|receiver|rshift\(7) $ \regs|receiver|rshift\(5) $ \regs|receiver|rshift\(6) $ \regs|receiver|rshift\(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110010110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rshift\(7),
	datab => \regs|receiver|rshift\(5),
	datac => \regs|receiver|rshift\(6),
	datad => \regs|receiver|rshift\(4),
	combout => \regs|receiver|WideXor0~54_combout\);

\regs|receiver|WideXor0~55\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|WideXor0~55_combout\ = \regs|receiver|WideXor0~54_combout\ $ \regs|receiver|rparity~regout\ $ \regs|receiver|WideXor0~53_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|WideXor0~54_combout\,
	datac => \regs|receiver|rparity~regout\,
	datad => \regs|receiver|WideXor0~53_combout\,
	combout => \regs|receiver|WideXor0~55_combout\);

\regs|receiver|rparity_xor~29\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rparity_xor~29_combout\ = \regs|receiver|Decoder1~147_combout\ & (\regs|receiver|Decoder1~146_combout\ & (\regs|receiver|WideXor0~55_combout\) # !\regs|receiver|Decoder1~146_combout\ & \regs|receiver|rparity_xor~regout\) # 
-- !\regs|receiver|Decoder1~147_combout\ & (\regs|receiver|rparity_xor~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100001110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Decoder1~147_combout\,
	datab => \regs|receiver|Decoder1~146_combout\,
	datac => \regs|receiver|rparity_xor~regout\,
	datad => \regs|receiver|WideXor0~55_combout\,
	combout => \regs|receiver|rparity_xor~29_combout\);

\regs|transmitter|shift_out[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|tfifo|ram~831_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|transmitter|parity_xor~22_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|shift_out\(6));

\regs|receiver|fifo_rx|bottom~850\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|bottom~850_combout\ = \regs|lsr0~14_combout\ & (\regs|receiver|rf_push_q~regout\ # !\regs|receiver|rf_push~regout\) # !\regs|rf_pop~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rf_push_q~regout\,
	datab => \regs|receiver|rf_push~regout\,
	datac => \regs|rf_pop~regout\,
	datad => \regs|lsr0~14_combout\,
	combout => \regs|receiver|fifo_rx|bottom~850_combout\);

\regs|lsr6\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr6~combout\ = \regs|transmitter|tstate\(2) # \regs|transmitter|tstate\(1) # \regs|transmitter|tstate\(0) # \regs|lsr5~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(2),
	datab => \regs|transmitter|tstate\(1),
	datac => \regs|transmitter|tstate\(0),
	datad => \regs|lsr5~combout\,
	combout => \regs|lsr6~combout\);

\regs|receiver|rparity~157\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rparity~157_combout\ = \regs|receiver|rstate\(0) & !\regs|receiver|rstate\(2) & \regs|receiver|Equal1~59_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(0),
	datab => \regs|receiver|rstate\(2),
	datac => \regs|receiver|Equal1~59_combout\,
	combout => \regs|receiver|rparity~157_combout\);

\regs|receiver|rcounter16[3]~434\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rcounter16[3]~434_combout\ = \regs|receiver|rstate\(0) & (\regs|receiver|Equal2~31_combout\ # !\regs|receiver|rstate\(3)) # !\regs|receiver|rstate\(0) & (\regs|receiver|rstate\(3) $ (\regs|receiver|rstate\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101010111100110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(3),
	datab => \regs|receiver|rstate\(0),
	datac => \regs|receiver|Equal2~31_combout\,
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|rcounter16[3]~434_combout\);

\regs|fcr[0]~37\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|fcr[0]~37_combout\ = !\wb_interface|Mux33~26_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|Mux33~26_combout\,
	combout => \regs|fcr[0]~37_combout\);

\regs|delayed_modem_signals[0]~8\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|delayed_modem_signals[0]~8_combout\ = !\cts_pad_i~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \cts_pad_i~combout\,
	combout => \regs|delayed_modem_signals[0]~8_combout\);

\wb_dat_i[4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(4),
	combout => \wb_dat_i~combout\(4));

\wb_dat_i[6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(6),
	combout => \wb_dat_i~combout\(6));

\wb_dat_i[9]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(9),
	combout => \wb_dat_i~combout\(9));

\wb_dat_i[7]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(7),
	combout => \wb_dat_i~combout\(7));

\wb_dat_i[26]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(26),
	combout => \wb_dat_i~combout\(26));

\wb_dat_i[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(2),
	combout => \wb_dat_i~combout\(2));

\wb_dat_i[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(3),
	combout => \wb_dat_i~combout\(3));

\wb_dat_i[21]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(21),
	combout => \wb_dat_i~combout\(21));

\wb_dat_i[13]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(13),
	combout => \wb_dat_i~combout\(13));

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[7]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|rfifo|ram_0_bypass[7]~feeder_combout\ = \regs|receiver|fifo_rx|top\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \regs|receiver|fifo_rx|top\(3),
	combout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass[7]~feeder_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[13]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[13]~feeder_combout\ = \wb_interface|Mux35~26_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_interface|Mux35~26_combout\,
	combout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[13]~feeder_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[15]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[15]~feeder_combout\ = \wb_interface|Mux33~26_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_interface|Mux33~26_combout\,
	combout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[15]~feeder_combout\);

\regs|receiver|fifo_rx|fifo[1][1]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[1][1]~feeder_combout\ = \regs|receiver|fifo_rx|fifo~6639_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \regs|receiver|fifo_rx|fifo~6639_combout\,
	combout => \regs|receiver|fifo_rx|fifo[1][1]~feeder_combout\);

\regs|receiver|fifo_rx|fifo[0][1]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[0][1]~feeder_combout\ = \regs|receiver|fifo_rx|fifo~6639_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \regs|receiver|fifo_rx|fifo~6639_combout\,
	combout => \regs|receiver|fifo_rx|fifo[0][1]~feeder_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[3]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[3]~feeder_combout\ = \regs|transmitter|fifo_tx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \regs|transmitter|fifo_tx|top\(1),
	combout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[3]~feeder_combout\);

\wb_interface|wb_dat_is[6]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[6]~feeder_combout\ = \wb_dat_i~combout\(6)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(6),
	combout => \wb_interface|wb_dat_is[6]~feeder_combout\);

\wb_interface|wb_dat_is[9]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[9]~feeder_combout\ = \wb_dat_i~combout\(9)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(9),
	combout => \wb_interface|wb_dat_is[9]~feeder_combout\);

\wb_interface|wb_dat_is[7]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[7]~feeder_combout\ = \wb_dat_i~combout\(7)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(7),
	combout => \wb_interface|wb_dat_is[7]~feeder_combout\);

\wb_interface|wb_dat_is[26]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[26]~feeder_combout\ = \wb_dat_i~combout\(26)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(26),
	combout => \wb_interface|wb_dat_is[26]~feeder_combout\);

\wb_interface|wb_dat_is[3]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[3]~feeder_combout\ = \wb_dat_i~combout\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(3),
	combout => \wb_interface|wb_dat_is[3]~feeder_combout\);

\wb_interface|wb_dat_is[13]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[13]~feeder_combout\ = \wb_dat_i~combout\(13)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(13),
	combout => \wb_interface|wb_dat_is[13]~feeder_combout\);

\wb_clk_i~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_clk_i,
	combout => \wb_clk_i~combout\);

\wb_clk_i~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "falling edge")
-- pragma translate_on
PORT MAP (
	inclk => \wb_clk_i~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \wb_clk_i~clkctrl_outclk\);

\regs|transmitter|Add1~65\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Add1~65_combout\ = \regs|transmitter|counter\(0) $ VCC
-- \regs|transmitter|Add1~66\ = CARRY(\regs|transmitter|counter\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|counter\(0),
	datad => VCC,
	combout => \regs|transmitter|Add1~65_combout\,
	cout => \regs|transmitter|Add1~66\);

\wb_sel_i[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_sel_i(3),
	combout => \wb_sel_i~combout\(3));

\wb_rst_i~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_rst_i,
	combout => \wb_rst_i~combout\);

\wb_rst_i~clkctrl\ : cycloneii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "falling edge")
-- pragma translate_on
PORT MAP (
	inclk => \wb_rst_i~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \wb_rst_i~clkctrl_outclk\);

\wb_interface|wb_sel_is[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_sel_i~combout\(3),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_sel_is\(3));

\wb_sel_i[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_sel_i(0),
	combout => \wb_sel_i~combout\(0));

\wb_interface|wb_sel_is[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_sel_i~combout\(0),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_sel_is\(0));

\wb_sel_i[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_sel_i(1),
	combout => \wb_sel_i~combout\(1));

\wb_interface|wb_sel_is[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_sel_i~combout\(1),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_sel_is\(1));

\wb_interface|Mux32~225\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux32~225_combout\ = \wb_interface|wb_sel_is\(0) # \wb_interface|wb_sel_is\(1) # \wb_interface|wb_sel_is\(2) $ !\wb_interface|wb_sel_is\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_sel_is\(2),
	datab => \wb_interface|wb_sel_is\(3),
	datac => \wb_interface|wb_sel_is\(0),
	datad => \wb_interface|wb_sel_is\(1),
	combout => \wb_interface|Mux32~225_combout\);

\wb_dat_i[10]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(10),
	combout => \wb_dat_i~combout\(10));

\wb_interface|wb_dat_is[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(10),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(10));

\wb_interface|Mux32~226\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux32~226_combout\ = \wb_interface|wb_sel_is\(2) # \wb_interface|wb_sel_is\(0) # \wb_interface|wb_sel_is\(3) $ !\wb_interface|wb_sel_is\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111101011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_sel_is\(2),
	datab => \wb_interface|wb_sel_is\(3),
	datac => \wb_interface|wb_sel_is\(1),
	datad => \wb_interface|wb_sel_is\(0),
	combout => \wb_interface|Mux32~226_combout\);

\wb_dat_i[18]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(18),
	combout => \wb_dat_i~combout\(18));

\wb_interface|wb_dat_is[18]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(18),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(18));

\wb_interface|Mux37~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux37~25_combout\ = \wb_interface|Mux32~226_combout\ & (\wb_interface|wb_dat_is\(18) # \wb_interface|Mux32~225_combout\) # !\wb_interface|Mux32~226_combout\ & \wb_interface|wb_dat_is\(26) & (!\wb_interface|Mux32~225_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_is\(26),
	datab => \wb_interface|Mux32~226_combout\,
	datac => \wb_interface|wb_dat_is\(18),
	datad => \wb_interface|Mux32~225_combout\,
	combout => \wb_interface|Mux37~25_combout\);

\wb_interface|Mux37~26\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux37~26_combout\ = \wb_interface|Mux32~225_combout\ & (\wb_interface|Mux37~25_combout\ & \wb_interface|wb_dat_is\(2) # !\wb_interface|Mux37~25_combout\ & (\wb_interface|wb_dat_is\(10))) # !\wb_interface|Mux32~225_combout\ & 
-- (\wb_interface|Mux37~25_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_is\(2),
	datab => \wb_interface|Mux32~225_combout\,
	datac => \wb_interface|wb_dat_is\(10),
	datad => \wb_interface|Mux37~25_combout\,
	combout => \wb_interface|Mux37~26_combout\);

\wb_adr_i[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_adr_i(2),
	combout => \wb_adr_i~combout\(2));

\wb_interface|wb_adr_is[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_adr_i~combout\(2),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_adr_is\(2));

\wb_interface|wb_adr_int[0]~64\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_adr_int[0]~64_combout\ = !\wb_interface|wb_sel_is\(1) & !\wb_interface|wb_sel_is\(3) & (\wb_interface|wb_sel_is\(2) $ \wb_interface|wb_sel_is\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_sel_is\(2),
	datab => \wb_interface|wb_sel_is\(1),
	datac => \wb_interface|wb_sel_is\(3),
	datad => \wb_interface|wb_sel_is\(0),
	combout => \wb_interface|wb_adr_int[0]~64_combout\);

\wb_sel_i[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_sel_i(2),
	combout => \wb_sel_i~combout\(2));

\wb_interface|wb_sel_is[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_sel_i~combout\(2),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_sel_is\(2));

\wb_interface|wb_adr_int[1]~63\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_adr_int[1]~63_combout\ = !\wb_interface|wb_sel_is\(3) & !\wb_interface|wb_sel_is\(2) & (\wb_interface|wb_sel_is\(0) $ \wb_interface|wb_sel_is\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_sel_is\(0),
	datab => \wb_interface|wb_sel_is\(3),
	datac => \wb_interface|wb_sel_is\(2),
	datad => \wb_interface|wb_sel_is\(1),
	combout => \wb_interface|wb_adr_int[1]~63_combout\);

\regs|always4~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|always4~0_combout\ = \regs|always4~28_combout\ & !\wb_interface|wb_adr_is\(2) & \wb_interface|wb_adr_int[0]~64_combout\ & \wb_interface|wb_adr_int[1]~63_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|always4~28_combout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \wb_interface|wb_adr_int[0]~64_combout\,
	datad => \wb_interface|wb_adr_int[1]~63_combout\,
	combout => \regs|always4~0_combout\);

\regs|lcr[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux37~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lcr\(2));

\regs|transmitter|WideNor1\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|WideNor1~combout\ = \regs|transmitter|counter\(0) # !\regs|transmitter|WideNor1~23_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|WideNor1~23_combout\,
	datad => \regs|transmitter|counter\(0),
	combout => \regs|transmitter|WideNor1~combout\);

\regs|transmitter|Mux3~230\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux3~230_combout\ = \regs|transmitter|tstate\(0) & (\regs|transmitter|tstate\(1) $ !\regs|transmitter|Equal1~36_combout\) # !\regs|transmitter|tstate\(0) & \regs|transmitter|tstate\(1) & (\regs|transmitter|Equal1~36_combout\ # 
-- !\regs|transmitter|bit_out~1052_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000011100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|bit_out~1052_combout\,
	datab => \regs|transmitter|tstate\(0),
	datac => \regs|transmitter|tstate\(1),
	datad => \regs|transmitter|Equal1~36_combout\,
	combout => \regs|transmitter|Mux3~230_combout\);

\wb_dat_i[30]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(30),
	combout => \wb_dat_i~combout\(30));

\wb_interface|wb_dat_is[30]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[30]~feeder_combout\ = \wb_dat_i~combout\(30)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(30),
	combout => \wb_interface|wb_dat_is[30]~feeder_combout\);

\wb_interface|wb_dat_is[30]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[30]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(30));

\wb_dat_i[22]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(22),
	combout => \wb_dat_i~combout\(22));

\wb_interface|wb_dat_is[22]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(22),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(22));

\wb_interface|Mux33~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux33~25_combout\ = \wb_interface|Mux32~225_combout\ & (\wb_interface|Mux32~226_combout\) # !\wb_interface|Mux32~225_combout\ & (\wb_interface|Mux32~226_combout\ & (\wb_interface|wb_dat_is\(22)) # !\wb_interface|Mux32~226_combout\ & 
-- \wb_interface|wb_dat_is\(30))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux32~225_combout\,
	datab => \wb_interface|wb_dat_is\(30),
	datac => \wb_interface|wb_dat_is\(22),
	datad => \wb_interface|Mux32~226_combout\,
	combout => \wb_interface|Mux33~25_combout\);

\wb_dat_i[14]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(14),
	combout => \wb_dat_i~combout\(14));

\wb_interface|wb_dat_is[14]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[14]~feeder_combout\ = \wb_dat_i~combout\(14)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(14),
	combout => \wb_interface|wb_dat_is[14]~feeder_combout\);

\wb_interface|wb_dat_is[14]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[14]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(14));

\wb_interface|Mux33~26\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux33~26_combout\ = \wb_interface|Mux32~225_combout\ & (\wb_interface|Mux33~25_combout\ & \wb_interface|wb_dat_is\(6) # !\wb_interface|Mux33~25_combout\ & (\wb_interface|wb_dat_is\(14))) # !\wb_interface|Mux32~225_combout\ & 
-- (\wb_interface|Mux33~25_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011110010110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_is\(6),
	datab => \wb_interface|Mux32~225_combout\,
	datac => \wb_interface|Mux33~25_combout\,
	datad => \wb_interface|wb_dat_is\(14),
	combout => \wb_interface|Mux33~26_combout\);

\wb_dat_i[23]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(23),
	combout => \wb_dat_i~combout\(23));

\wb_interface|wb_dat_is[23]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[23]~feeder_combout\ = \wb_dat_i~combout\(23)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(23),
	combout => \wb_interface|wb_dat_is[23]~feeder_combout\);

\wb_interface|wb_dat_is[23]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[23]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(23));

\wb_dat_i[31]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(31),
	combout => \wb_dat_i~combout\(31));

\wb_interface|wb_dat_is[31]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[31]~feeder_combout\ = \wb_dat_i~combout\(31)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(31),
	combout => \wb_interface|wb_dat_is[31]~feeder_combout\);

\wb_interface|wb_dat_is[31]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[31]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(31));

\wb_dat_i[15]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(15),
	combout => \wb_dat_i~combout\(15));

\wb_interface|wb_dat_is[15]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(15),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(15));

\wb_interface|Mux32~227\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux32~227_combout\ = \wb_interface|Mux32~226_combout\ & (\wb_interface|Mux32~225_combout\) # !\wb_interface|Mux32~226_combout\ & (\wb_interface|Mux32~225_combout\ & (\wb_interface|wb_dat_is\(15)) # !\wb_interface|Mux32~225_combout\ & 
-- \wb_interface|wb_dat_is\(31))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux32~226_combout\,
	datab => \wb_interface|wb_dat_is\(31),
	datac => \wb_interface|wb_dat_is\(15),
	datad => \wb_interface|Mux32~225_combout\,
	combout => \wb_interface|Mux32~227_combout\);

\wb_interface|Mux32~228\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux32~228_combout\ = \wb_interface|Mux32~227_combout\ & (\wb_interface|wb_dat_is\(7) # !\wb_interface|Mux32~226_combout\) # !\wb_interface|Mux32~227_combout\ & (\wb_interface|wb_dat_is\(23) & \wb_interface|Mux32~226_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_is\(7),
	datab => \wb_interface|wb_dat_is\(23),
	datac => \wb_interface|Mux32~227_combout\,
	datad => \wb_interface|Mux32~226_combout\,
	combout => \wb_interface|Mux32~228_combout\);

\regs|lcr[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux32~228_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lcr\(7));

\wb_stb_i~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_stb_i,
	combout => \wb_stb_i~combout\);

\wb_interface|wb_stb_is\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_stb_i~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_stb_is~regout\);

\wb_cyc_i~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_cyc_i,
	combout => \wb_cyc_i~combout\);

\wb_interface|wb_cyc_is\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_cyc_i~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_cyc_is~regout\);

\wb_interface|we_o~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|we_o~11_combout\ = \wb_interface|wb_stb_is~regout\ & \wb_interface|wb_cyc_is~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|wb_stb_is~regout\,
	datad => \wb_interface|wb_cyc_is~regout\,
	combout => \wb_interface|we_o~11_combout\);

\wb_we_i~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_we_i,
	combout => \wb_we_i~combout\);

\wb_interface|wb_we_is\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_we_i~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_we_is~regout\);

\wb_adr_i[4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_adr_i(4),
	combout => \wb_adr_i~combout\(4));

\wb_interface|wb_adr_is[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_adr_i~combout\(4),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_adr_is\(4));

\wb_adr_i[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_adr_i(3),
	combout => \wb_adr_i~combout\(3));

\wb_interface|wb_adr_is[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_adr_i~combout\(3),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_adr_is\(3));

\regs|always7~19\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|always7~19_combout\ = !\wb_interface|wb_adr_is\(4) & !\wb_interface|wb_adr_is\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|wb_adr_is\(4),
	datad => \wb_interface|wb_adr_is\(3),
	combout => \regs|always7~19_combout\);

\regs|always4~28\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|always4~28_combout\ = !\wb_interface|wre~regout\ & \wb_interface|we_o~11_combout\ & \wb_interface|wb_we_is~regout\ & \regs|always7~19_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wre~regout\,
	datab => \wb_interface|we_o~11_combout\,
	datac => \wb_interface|wb_we_is~regout\,
	datad => \regs|always7~19_combout\,
	combout => \regs|always4~28_combout\);

\regs|always4~29\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|always4~29_combout\ = !\wb_interface|wb_adr_is\(2) & \regs|always4~28_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \wb_interface|wb_adr_is\(2),
	datad => \regs|always4~28_combout\,
	combout => \regs|always4~29_combout\);

\regs|dl[0]~298\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dl[0]~298_combout\ = !\wb_interface|wb_adr_int[0]~64_combout\ & \regs|lcr\(7) & !\wb_interface|wb_adr_int[1]~63_combout\ & \regs|always4~29_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_int[0]~64_combout\,
	datab => \regs|lcr\(7),
	datac => \wb_interface|wb_adr_int[1]~63_combout\,
	datad => \regs|always4~29_combout\,
	combout => \regs|dl[0]~298_combout\);

\regs|dl[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux33~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[0]~298_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(6));

\regs|dl[8]~299\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dl[8]~299_combout\ = \regs|lcr\(7) & !\wb_interface|wb_adr_int[1]~63_combout\ & \regs|always4~29_combout\ & \wb_interface|wb_adr_int[0]~64_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(7),
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \regs|always4~29_combout\,
	datad => \wb_interface|wb_adr_int[0]~64_combout\,
	combout => \regs|dl[8]~299_combout\);

\regs|dl[15]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux32~228_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[8]~299_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(15));

\regs|dl[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux32~228_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[0]~298_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(7));

\regs|WideOr1~109\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr1~109_combout\ = \regs|dl\(14) # \regs|dl\(6) # \regs|dl\(15) # \regs|dl\(7)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(14),
	datab => \regs|dl\(6),
	datac => \regs|dl\(15),
	datad => \regs|dl\(7),
	combout => \regs|WideOr1~109_combout\);

\regs|start_dlc\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dl[0]~298_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|start_dlc~regout\);

\wb_dat_i[28]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(28),
	combout => \wb_dat_i~combout\(28));

\wb_interface|wb_dat_is[28]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(28),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(28));

\wb_dat_i[20]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(20),
	combout => \wb_dat_i~combout\(20));

\wb_interface|wb_dat_is[20]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(20),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(20));

\wb_interface|Mux35~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux35~25_combout\ = \wb_interface|Mux32~225_combout\ & (\wb_interface|Mux32~226_combout\) # !\wb_interface|Mux32~225_combout\ & (\wb_interface|Mux32~226_combout\ & (\wb_interface|wb_dat_is\(20)) # !\wb_interface|Mux32~226_combout\ & 
-- \wb_interface|wb_dat_is\(28))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux32~225_combout\,
	datab => \wb_interface|wb_dat_is\(28),
	datac => \wb_interface|wb_dat_is\(20),
	datad => \wb_interface|Mux32~226_combout\,
	combout => \wb_interface|Mux35~25_combout\);

\wb_dat_i[12]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(12),
	combout => \wb_dat_i~combout\(12));

\wb_interface|wb_dat_is[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(12),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(12));

\wb_interface|Mux35~26\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux35~26_combout\ = \wb_interface|Mux32~225_combout\ & (\wb_interface|Mux35~25_combout\ & \wb_interface|wb_dat_is\(4) # !\wb_interface|Mux35~25_combout\ & (\wb_interface|wb_dat_is\(12))) # !\wb_interface|Mux32~225_combout\ & 
-- (\wb_interface|Mux35~25_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011110010110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_is\(4),
	datab => \wb_interface|Mux32~225_combout\,
	datac => \wb_interface|Mux35~25_combout\,
	datad => \wb_interface|wb_dat_is\(12),
	combout => \wb_interface|Mux35~26_combout\);

\regs|dl[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux35~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[8]~299_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(12));

\regs|Add0~941\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~941_combout\ = \regs|start_dlc~regout\ & (\regs|dl\(12)) # !\regs|start_dlc~regout\ & (\regs|dlc\(12) # !\regs|WideOr0~116_combout\ & \regs|dl\(12))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101100001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(12),
	datab => \regs|WideOr0~116_combout\,
	datac => \regs|start_dlc~regout\,
	datad => \regs|dl\(12),
	combout => \regs|Add0~941_combout\);

\wb_dat_i[5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(5),
	combout => \wb_dat_i~combout\(5));

\wb_interface|wb_dat_is[5]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[5]~feeder_combout\ = \wb_dat_i~combout\(5)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(5),
	combout => \wb_interface|wb_dat_is[5]~feeder_combout\);

\wb_interface|wb_dat_is[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[5]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(5));

\wb_dat_i[29]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(29),
	combout => \wb_dat_i~combout\(29));

\wb_interface|wb_dat_is[29]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(29),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(29));

\wb_interface|Mux34~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux34~25_combout\ = \wb_interface|Mux32~226_combout\ & (\wb_interface|Mux32~225_combout\) # !\wb_interface|Mux32~226_combout\ & (\wb_interface|Mux32~225_combout\ & \wb_interface|wb_dat_is\(13) # !\wb_interface|Mux32~225_combout\ & 
-- (\wb_interface|wb_dat_is\(29)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_is\(13),
	datab => \wb_interface|Mux32~226_combout\,
	datac => \wb_interface|wb_dat_is\(29),
	datad => \wb_interface|Mux32~225_combout\,
	combout => \wb_interface|Mux34~25_combout\);

\wb_interface|Mux34~26\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux34~26_combout\ = \wb_interface|Mux32~226_combout\ & (\wb_interface|Mux34~25_combout\ & (\wb_interface|wb_dat_is\(5)) # !\wb_interface|Mux34~25_combout\ & \wb_interface|wb_dat_is\(21)) # !\wb_interface|Mux32~226_combout\ & 
-- (\wb_interface|Mux34~25_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_is\(21),
	datab => \wb_interface|Mux32~226_combout\,
	datac => \wb_interface|wb_dat_is\(5),
	datad => \wb_interface|Mux34~25_combout\,
	combout => \wb_interface|Mux34~26_combout\);

\regs|dl[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux34~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[0]~298_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(5));

\regs|Add0~934\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~934_combout\ = \regs|start_dlc~regout\ & (\regs|dl\(5)) # !\regs|start_dlc~regout\ & (\regs|dlc\(5) # \regs|dl\(5) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011110010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(5),
	datab => \regs|start_dlc~regout\,
	datac => \regs|dl\(5),
	datad => \regs|WideOr0~116_combout\,
	combout => \regs|Add0~934_combout\);

\regs|dl[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux35~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[0]~298_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(4));

\regs|Add0~933\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~933_combout\ = \regs|start_dlc~regout\ & (\regs|dl\(4)) # !\regs|start_dlc~regout\ & (\regs|dlc\(4) # \regs|dl\(4) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001011110010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(4),
	datab => \regs|start_dlc~regout\,
	datac => \regs|dl\(4),
	datad => \regs|WideOr0~116_combout\,
	combout => \regs|Add0~933_combout\);

\regs|dlc[0]~256\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[0]~256_combout\ = \regs|Add0~929_combout\ $ VCC
-- \regs|dlc[0]~257\ = CARRY(\regs|Add0~929_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|Add0~929_combout\,
	datad => VCC,
	combout => \regs|dlc[0]~256_combout\,
	cout => \regs|dlc[0]~257\);

\regs|dlc[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[0]~256_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(0));

\regs|Add0~929\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~929_combout\ = \regs|start_dlc~regout\ & \regs|dl\(0) # !\regs|start_dlc~regout\ & (\regs|dlc\(0) # \regs|dl\(0) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100010111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(0),
	datab => \regs|start_dlc~regout\,
	datac => \regs|dlc\(0),
	datad => \regs|WideOr0~116_combout\,
	combout => \regs|Add0~929_combout\);

\regs|dlc[2]~260\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[2]~260_combout\ = \regs|Add0~931_combout\ & (GND # !\regs|dlc[1]~259\) # !\regs|Add0~931_combout\ & (\regs|dlc[1]~259\ $ GND)
-- \regs|dlc[2]~261\ = CARRY(\regs|Add0~931_combout\ # !\regs|dlc[1]~259\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|Add0~931_combout\,
	datad => VCC,
	cin => \regs|dlc[1]~259\,
	combout => \regs|dlc[2]~260_combout\,
	cout => \regs|dlc[2]~261\);

\regs|dlc[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[2]~260_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(2));

\regs|Add0~931\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~931_combout\ = \regs|start_dlc~regout\ & \regs|dl\(2) # !\regs|start_dlc~regout\ & (\regs|dlc\(2) # \regs|dl\(2) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100010111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(2),
	datab => \regs|start_dlc~regout\,
	datac => \regs|dlc\(2),
	datad => \regs|WideOr0~116_combout\,
	combout => \regs|Add0~931_combout\);

\regs|dlc[3]~262\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[3]~262_combout\ = \regs|Add0~932_combout\ & \regs|dlc[2]~261\ & VCC # !\regs|Add0~932_combout\ & !\regs|dlc[2]~261\
-- \regs|dlc[3]~263\ = CARRY(!\regs|Add0~932_combout\ & !\regs|dlc[2]~261\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|Add0~932_combout\,
	datad => VCC,
	cin => \regs|dlc[2]~261\,
	combout => \regs|dlc[3]~262_combout\,
	cout => \regs|dlc[3]~263\);

\regs|dlc[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[3]~262_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(3));

\wb_dat_i[19]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(19),
	combout => \wb_dat_i~combout\(19));

\wb_interface|wb_dat_is[19]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[19]~feeder_combout\ = \wb_dat_i~combout\(19)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(19),
	combout => \wb_interface|wb_dat_is[19]~feeder_combout\);

\wb_interface|wb_dat_is[19]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[19]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(19));

\wb_dat_i[27]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(27),
	combout => \wb_dat_i~combout\(27));

\wb_interface|wb_dat_is[27]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(27),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(27));

\wb_dat_i[11]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(11),
	combout => \wb_dat_i~combout\(11));

\wb_interface|wb_dat_is[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(11),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(11));

\wb_interface|Mux36~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux36~25_combout\ = \wb_interface|Mux32~226_combout\ & (\wb_interface|Mux32~225_combout\) # !\wb_interface|Mux32~226_combout\ & (\wb_interface|Mux32~225_combout\ & (\wb_interface|wb_dat_is\(11)) # !\wb_interface|Mux32~225_combout\ & 
-- \wb_interface|wb_dat_is\(27))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux32~226_combout\,
	datab => \wb_interface|wb_dat_is\(27),
	datac => \wb_interface|wb_dat_is\(11),
	datad => \wb_interface|Mux32~225_combout\,
	combout => \wb_interface|Mux36~25_combout\);

\wb_interface|Mux36~26\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux36~26_combout\ = \wb_interface|Mux32~226_combout\ & (\wb_interface|Mux36~25_combout\ & \wb_interface|wb_dat_is\(3) # !\wb_interface|Mux36~25_combout\ & (\wb_interface|wb_dat_is\(19))) # !\wb_interface|Mux32~226_combout\ & 
-- (\wb_interface|Mux36~25_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_is\(3),
	datab => \wb_interface|Mux32~226_combout\,
	datac => \wb_interface|wb_dat_is\(19),
	datad => \wb_interface|Mux36~25_combout\,
	combout => \wb_interface|Mux36~26_combout\);

\regs|dl[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux36~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[0]~298_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(3));

\regs|Add0~932\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~932_combout\ = \regs|start_dlc~regout\ & (\regs|dl\(3)) # !\regs|start_dlc~regout\ & (\regs|dlc\(3) # !\regs|WideOr0~116_combout\ & \regs|dl\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011011100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|WideOr0~116_combout\,
	datab => \regs|dlc\(3),
	datac => \regs|dl\(3),
	datad => \regs|start_dlc~regout\,
	combout => \regs|Add0~932_combout\);

\regs|dlc[4]~264\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[4]~264_combout\ = \regs|Add0~933_combout\ & (GND # !\regs|dlc[3]~263\) # !\regs|Add0~933_combout\ & (\regs|dlc[3]~263\ $ GND)
-- \regs|dlc[4]~265\ = CARRY(\regs|Add0~933_combout\ # !\regs|dlc[3]~263\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|Add0~933_combout\,
	datad => VCC,
	cin => \regs|dlc[3]~263\,
	combout => \regs|dlc[4]~264_combout\,
	cout => \regs|dlc[4]~265\);

\regs|dlc[6]~268\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[6]~268_combout\ = \regs|Add0~935_combout\ & (GND # !\regs|dlc[5]~267\) # !\regs|Add0~935_combout\ & (\regs|dlc[5]~267\ $ GND)
-- \regs|dlc[6]~269\ = CARRY(\regs|Add0~935_combout\ # !\regs|dlc[5]~267\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|Add0~935_combout\,
	datad => VCC,
	cin => \regs|dlc[5]~267\,
	combout => \regs|dlc[6]~268_combout\,
	cout => \regs|dlc[6]~269\);

\regs|dlc[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[6]~268_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(6));

\regs|Add0~935\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~935_combout\ = \regs|start_dlc~regout\ & \regs|dl\(6) # !\regs|start_dlc~regout\ & (\regs|dlc\(6) # \regs|dl\(6) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100010111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(6),
	datab => \regs|start_dlc~regout\,
	datac => \regs|dlc\(6),
	datad => \regs|WideOr0~116_combout\,
	combout => \regs|Add0~935_combout\);

\regs|dlc[7]~270\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[7]~270_combout\ = \regs|Add0~936_combout\ & \regs|dlc[6]~269\ & VCC # !\regs|Add0~936_combout\ & !\regs|dlc[6]~269\
-- \regs|dlc[7]~271\ = CARRY(!\regs|Add0~936_combout\ & !\regs|dlc[6]~269\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Add0~936_combout\,
	datad => VCC,
	cin => \regs|dlc[6]~269\,
	combout => \regs|dlc[7]~270_combout\,
	cout => \regs|dlc[7]~271\);

\regs|dlc[8]~272\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[8]~272_combout\ = \regs|Add0~937_combout\ & (GND # !\regs|dlc[7]~271\) # !\regs|Add0~937_combout\ & (\regs|dlc[7]~271\ $ GND)
-- \regs|dlc[8]~273\ = CARRY(\regs|Add0~937_combout\ # !\regs|dlc[7]~271\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|Add0~937_combout\,
	datad => VCC,
	cin => \regs|dlc[7]~271\,
	combout => \regs|dlc[8]~272_combout\,
	cout => \regs|dlc[8]~273\);

\regs|dlc[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[8]~272_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(8));

\wb_dat_i[8]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(8),
	combout => \wb_dat_i~combout\(8));

\wb_interface|wb_dat_is[8]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[8]~feeder_combout\ = \wb_dat_i~combout\(8)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(8),
	combout => \wb_interface|wb_dat_is[8]~feeder_combout\);

\wb_interface|wb_dat_is[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[8]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(8));

\wb_dat_i[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(0),
	combout => \wb_dat_i~combout\(0));

\wb_interface|wb_dat_is[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(0),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(0));

\wb_dat_i[16]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(16),
	combout => \wb_dat_i~combout\(16));

\wb_interface|wb_dat_is[16]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[16]~feeder_combout\ = \wb_dat_i~combout\(16)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(16),
	combout => \wb_interface|wb_dat_is[16]~feeder_combout\);

\wb_interface|wb_dat_is[16]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[16]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(16));

\wb_dat_i[24]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(24),
	combout => \wb_dat_i~combout\(24));

\wb_interface|wb_dat_is[24]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(24),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(24));

\wb_interface|Mux39~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux39~25_combout\ = \wb_interface|Mux32~226_combout\ & (\wb_interface|wb_dat_is\(16) # \wb_interface|Mux32~225_combout\) # !\wb_interface|Mux32~226_combout\ & (\wb_interface|wb_dat_is\(24) & !\wb_interface|Mux32~225_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux32~226_combout\,
	datab => \wb_interface|wb_dat_is\(16),
	datac => \wb_interface|wb_dat_is\(24),
	datad => \wb_interface|Mux32~225_combout\,
	combout => \wb_interface|Mux39~25_combout\);

\wb_interface|Mux39~26\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux39~26_combout\ = \wb_interface|Mux32~225_combout\ & (\wb_interface|Mux39~25_combout\ & (\wb_interface|wb_dat_is\(0)) # !\wb_interface|Mux39~25_combout\ & \wb_interface|wb_dat_is\(8)) # !\wb_interface|Mux32~225_combout\ & 
-- (\wb_interface|Mux39~25_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux32~225_combout\,
	datab => \wb_interface|wb_dat_is\(8),
	datac => \wb_interface|wb_dat_is\(0),
	datad => \wb_interface|Mux39~25_combout\,
	combout => \wb_interface|Mux39~26_combout\);

\regs|dl[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux39~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[8]~299_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(8));

\regs|Add0~937\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~937_combout\ = \regs|start_dlc~regout\ & (\regs|dl\(8)) # !\regs|start_dlc~regout\ & (\regs|dlc\(8) # !\regs|WideOr0~116_combout\ & \regs|dl\(8))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011011100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|WideOr0~116_combout\,
	datab => \regs|dlc\(8),
	datac => \regs|dl\(8),
	datad => \regs|start_dlc~regout\,
	combout => \regs|Add0~937_combout\);

\regs|dlc[9]~274\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[9]~274_combout\ = \regs|Add0~938_combout\ & \regs|dlc[8]~273\ & VCC # !\regs|Add0~938_combout\ & !\regs|dlc[8]~273\
-- \regs|dlc[9]~275\ = CARRY(!\regs|Add0~938_combout\ & !\regs|dlc[8]~273\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Add0~938_combout\,
	datad => VCC,
	cin => \regs|dlc[8]~273\,
	combout => \regs|dlc[9]~274_combout\,
	cout => \regs|dlc[9]~275\);

\regs|dlc[10]~276\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[10]~276_combout\ = \regs|Add0~939_combout\ & (GND # !\regs|dlc[9]~275\) # !\regs|Add0~939_combout\ & (\regs|dlc[9]~275\ $ GND)
-- \regs|dlc[10]~277\ = CARRY(\regs|Add0~939_combout\ # !\regs|dlc[9]~275\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|Add0~939_combout\,
	datad => VCC,
	cin => \regs|dlc[9]~275\,
	combout => \regs|dlc[10]~276_combout\,
	cout => \regs|dlc[10]~277\);

\regs|dlc[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[10]~276_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(10));

\regs|Add0~939\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~939_combout\ = \regs|start_dlc~regout\ & \regs|dl\(10) # !\regs|start_dlc~regout\ & (\regs|dlc\(10) # \regs|dl\(10) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100010111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(10),
	datab => \regs|start_dlc~regout\,
	datac => \regs|dlc\(10),
	datad => \regs|WideOr0~116_combout\,
	combout => \regs|Add0~939_combout\);

\regs|dlc[12]~280\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[12]~280_combout\ = \regs|Add0~941_combout\ & (GND # !\regs|dlc[11]~279\) # !\regs|Add0~941_combout\ & (\regs|dlc[11]~279\ $ GND)
-- \regs|dlc[12]~281\ = CARRY(\regs|Add0~941_combout\ # !\regs|dlc[11]~279\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|Add0~941_combout\,
	datad => VCC,
	cin => \regs|dlc[11]~279\,
	combout => \regs|dlc[12]~280_combout\,
	cout => \regs|dlc[12]~281\);

\regs|dlc[13]~282\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dlc[13]~282_combout\ = \regs|Add0~942_combout\ & \regs|dlc[12]~281\ & VCC # !\regs|Add0~942_combout\ & !\regs|dlc[12]~281\
-- \regs|dlc[13]~283\ = CARRY(!\regs|Add0~942_combout\ & !\regs|dlc[12]~281\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Add0~942_combout\,
	datad => VCC,
	cin => \regs|dlc[12]~281\,
	combout => \regs|dlc[13]~282_combout\,
	cout => \regs|dlc[13]~283\);

\regs|dlc[13]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[13]~282_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(13));

\regs|Add0~943\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Add0~943_combout\ = \regs|start_dlc~regout\ & \regs|dl\(14) # !\regs|start_dlc~regout\ & (\regs|dlc\(14) # \regs|dl\(14) & !\regs|WideOr0~116_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010110010101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(14),
	datab => \regs|dlc\(14),
	datac => \regs|start_dlc~regout\,
	datad => \regs|WideOr0~116_combout\,
	combout => \regs|Add0~943_combout\);

\regs|dlc[14]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[14]~284_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(14));

\regs|dlc[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[12]~280_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(12));

\regs|WideOr0~115\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr0~115_combout\ = \regs|dlc\(15) # \regs|dlc\(13) # \regs|dlc\(14) # \regs|dlc\(12)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(15),
	datab => \regs|dlc\(13),
	datac => \regs|dlc\(14),
	datad => \regs|dlc\(12),
	combout => \regs|WideOr0~115_combout\);

\regs|dlc[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[7]~270_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(7));

\regs|dlc[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[4]~264_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(4));

\regs|WideOr0~113\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr0~113_combout\ = \regs|dlc\(5) # \regs|dlc\(7) # \regs|dlc\(6) # \regs|dlc\(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(5),
	datab => \regs|dlc\(7),
	datac => \regs|dlc\(6),
	datad => \regs|dlc\(4),
	combout => \regs|WideOr0~113_combout\);

\regs|dlc[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dlc[9]~274_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dlc\(9));

\regs|WideOr0~114\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr0~114_combout\ = \regs|dlc\(11) # \regs|dlc\(8) # \regs|dlc\(9) # \regs|dlc\(10)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dlc\(11),
	datab => \regs|dlc\(8),
	datac => \regs|dlc\(9),
	datad => \regs|dlc\(10),
	combout => \regs|WideOr0~114_combout\);

\regs|WideOr0~116\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr0~116_combout\ = \regs|WideOr0~112_combout\ # \regs|WideOr0~115_combout\ # \regs|WideOr0~113_combout\ # \regs|WideOr0~114_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|WideOr0~112_combout\,
	datab => \regs|WideOr0~115_combout\,
	datac => \regs|WideOr0~113_combout\,
	datad => \regs|WideOr0~114_combout\,
	combout => \regs|WideOr0~116_combout\);

\regs|dl[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux36~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[8]~299_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(11));

\regs|dl[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux37~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[0]~298_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(2));

\regs|dl[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux37~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[8]~299_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(10));

\regs|WideOr1~106\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr1~106_combout\ = \regs|dl\(3) # \regs|dl\(11) # \regs|dl\(2) # \regs|dl\(10)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(3),
	datab => \regs|dl\(11),
	datac => \regs|dl\(2),
	datad => \regs|dl\(10),
	combout => \regs|WideOr1~106_combout\);

\wb_dat_i[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(1),
	combout => \wb_dat_i~combout\(1));

\wb_interface|wb_dat_is[1]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[1]~feeder_combout\ = \wb_dat_i~combout\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(1),
	combout => \wb_interface|wb_dat_is[1]~feeder_combout\);

\wb_interface|wb_dat_is[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[1]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(1));

\wb_dat_i[17]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(17),
	combout => \wb_dat_i~combout\(17));

\wb_interface|wb_dat_is[17]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_is[17]~feeder_combout\ = \wb_dat_i~combout\(17)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_dat_i~combout\(17),
	combout => \wb_interface|wb_dat_is[17]~feeder_combout\);

\wb_interface|wb_dat_is[17]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_dat_is[17]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(17));

\wb_dat_i[25]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_dat_i(25),
	combout => \wb_dat_i~combout\(25));

\wb_interface|wb_dat_is[25]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_dat_i~combout\(25),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_is\(25));

\wb_interface|Mux38~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux38~25_combout\ = \wb_interface|Mux32~226_combout\ & (\wb_interface|Mux32~225_combout\) # !\wb_interface|Mux32~226_combout\ & (\wb_interface|Mux32~225_combout\ & \wb_interface|wb_dat_is\(9) # !\wb_interface|Mux32~225_combout\ & 
-- (\wb_interface|wb_dat_is\(25)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_is\(9),
	datab => \wb_interface|Mux32~226_combout\,
	datac => \wb_interface|wb_dat_is\(25),
	datad => \wb_interface|Mux32~225_combout\,
	combout => \wb_interface|Mux38~25_combout\);

\wb_interface|Mux38~26\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux38~26_combout\ = \wb_interface|Mux32~226_combout\ & (\wb_interface|Mux38~25_combout\ & \wb_interface|wb_dat_is\(1) # !\wb_interface|Mux38~25_combout\ & (\wb_interface|wb_dat_is\(17))) # !\wb_interface|Mux32~226_combout\ & 
-- (\wb_interface|Mux38~25_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux32~226_combout\,
	datab => \wb_interface|wb_dat_is\(1),
	datac => \wb_interface|wb_dat_is\(17),
	datad => \wb_interface|Mux38~25_combout\,
	combout => \wb_interface|Mux38~26_combout\);

\regs|dl[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux38~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[8]~299_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(9));

\regs|dl[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux38~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|dl[0]~298_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(1));

\regs|WideOr1~107\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr1~107_combout\ = \regs|WideOr1~105_combout\ # \regs|WideOr1~106_combout\ # \regs|dl\(9) # \regs|dl\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|WideOr1~105_combout\,
	datab => \regs|WideOr1~106_combout\,
	datac => \regs|dl\(9),
	datad => \regs|dl\(1),
	combout => \regs|WideOr1~107_combout\);

\regs|always29~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|always29~0_combout\ = !\regs|WideOr0~116_combout\ & (\regs|WideOr1~108_combout\ # \regs|WideOr1~109_combout\ # \regs|WideOr1~107_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|WideOr1~108_combout\,
	datab => \regs|WideOr1~109_combout\,
	datac => \regs|WideOr0~116_combout\,
	datad => \regs|WideOr1~107_combout\,
	combout => \regs|always29~0_combout\);

\regs|enable\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|always29~0_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|enable~regout\);

\regs|transmitter|tstate[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|Mux3~230_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|transmitter|tstate\(2),
	ena => \regs|enable~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|tstate\(1));

\regs|transmitter|Mux5~207\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux5~207_combout\ = \regs|transmitter|tstate\(1) & (\regs|transmitter|tf_pop~regout\) # !\regs|transmitter|tstate\(1) & \regs|transmitter|tstate\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|tstate\(2),
	datac => \regs|transmitter|tstate\(1),
	datad => \regs|transmitter|tf_pop~regout\,
	combout => \regs|transmitter|Mux5~207_combout\);

\regs|transmitter|Mux5~208\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux5~208_combout\ = \regs|transmitter|tstate\(0) & (\regs|transmitter|Mux5~207_combout\) # !\regs|transmitter|tstate\(0) & \regs|transmitter|tf_pop~regout\ & (\regs|lsr5~74_combout\ # \regs|transmitter|Mux5~207_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr5~74_combout\,
	datab => \regs|transmitter|tstate\(0),
	datac => \regs|transmitter|tf_pop~regout\,
	datad => \regs|transmitter|Mux5~207_combout\,
	combout => \regs|transmitter|Mux5~208_combout\);

\regs|transmitter|tf_pop\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|Mux5~208_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|ALT_INV_enable~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|tf_pop~regout\);

\regs|transmitter|fifo_tx|Add1~111\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|Add1~111_combout\ = \regs|transmitter|tf_pop~regout\ # !\regs|transmitter|fifo_tx|count\(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|fifo_tx|count\(4),
	datad => \regs|transmitter|tf_pop~regout\,
	combout => \regs|transmitter|fifo_tx|Add1~111_combout\);

\regs|transmitter|fifo_tx|count[0]~330\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|count[0]~330_combout\ = \regs|transmitter|fifo_tx|count\(0) & (\regs|transmitter|fifo_tx|Add1~111_combout\ $ VCC) # !\regs|transmitter|fifo_tx|count\(0) & \regs|transmitter|fifo_tx|Add1~111_combout\ & VCC
-- \regs|transmitter|fifo_tx|count[0]~331\ = CARRY(\regs|transmitter|fifo_tx|count\(0) & \regs|transmitter|fifo_tx|Add1~111_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|count\(0),
	datab => \regs|transmitter|fifo_tx|Add1~111_combout\,
	datad => VCC,
	combout => \regs|transmitter|fifo_tx|count[0]~330_combout\,
	cout => \regs|transmitter|fifo_tx|count[0]~331\);

\regs|transmitter|fifo_tx|count[1]~333\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|count[1]~333_combout\ = \regs|transmitter|fifo_tx|count\(1) & (\regs|transmitter|tf_pop~regout\ & \regs|transmitter|fifo_tx|count[0]~331\ & VCC # !\regs|transmitter|tf_pop~regout\ & !\regs|transmitter|fifo_tx|count[0]~331\) # 
-- !\regs|transmitter|fifo_tx|count\(1) & (\regs|transmitter|tf_pop~regout\ & !\regs|transmitter|fifo_tx|count[0]~331\ # !\regs|transmitter|tf_pop~regout\ & (\regs|transmitter|fifo_tx|count[0]~331\ # GND))
-- \regs|transmitter|fifo_tx|count[1]~334\ = CARRY(\regs|transmitter|fifo_tx|count\(1) & !\regs|transmitter|tf_pop~regout\ & !\regs|transmitter|fifo_tx|count[0]~331\ # !\regs|transmitter|fifo_tx|count\(1) & (!\regs|transmitter|fifo_tx|count[0]~331\ # 
-- !\regs|transmitter|tf_pop~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|count\(1),
	datab => \regs|transmitter|tf_pop~regout\,
	datad => VCC,
	cin => \regs|transmitter|fifo_tx|count[0]~331\,
	combout => \regs|transmitter|fifo_tx|count[1]~333_combout\,
	cout => \regs|transmitter|fifo_tx|count[1]~334\);

\regs|transmitter|fifo_tx|count[2]~335\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|count[2]~335_combout\ = (\regs|transmitter|fifo_tx|count\(2) $ \regs|transmitter|tf_pop~regout\ $ !\regs|transmitter|fifo_tx|count[1]~334\) # GND
-- \regs|transmitter|fifo_tx|count[2]~336\ = CARRY(\regs|transmitter|fifo_tx|count\(2) & (\regs|transmitter|tf_pop~regout\ # !\regs|transmitter|fifo_tx|count[1]~334\) # !\regs|transmitter|fifo_tx|count\(2) & \regs|transmitter|tf_pop~regout\ & 
-- !\regs|transmitter|fifo_tx|count[1]~334\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|count\(2),
	datab => \regs|transmitter|tf_pop~regout\,
	datad => VCC,
	cin => \regs|transmitter|fifo_tx|count[1]~334\,
	combout => \regs|transmitter|fifo_tx|count[2]~335_combout\,
	cout => \regs|transmitter|fifo_tx|count[2]~336\);

\regs|transmitter|fifo_tx|count[3]~337\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|count[3]~337_combout\ = \regs|transmitter|fifo_tx|count\(3) & (\regs|transmitter|tf_pop~regout\ & \regs|transmitter|fifo_tx|count[2]~336\ & VCC # !\regs|transmitter|tf_pop~regout\ & !\regs|transmitter|fifo_tx|count[2]~336\) # 
-- !\regs|transmitter|fifo_tx|count\(3) & (\regs|transmitter|tf_pop~regout\ & !\regs|transmitter|fifo_tx|count[2]~336\ # !\regs|transmitter|tf_pop~regout\ & (\regs|transmitter|fifo_tx|count[2]~336\ # GND))
-- \regs|transmitter|fifo_tx|count[3]~338\ = CARRY(\regs|transmitter|fifo_tx|count\(3) & !\regs|transmitter|tf_pop~regout\ & !\regs|transmitter|fifo_tx|count[2]~336\ # !\regs|transmitter|fifo_tx|count\(3) & (!\regs|transmitter|fifo_tx|count[2]~336\ # 
-- !\regs|transmitter|tf_pop~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|count\(3),
	datab => \regs|transmitter|tf_pop~regout\,
	datad => VCC,
	cin => \regs|transmitter|fifo_tx|count[2]~336\,
	combout => \regs|transmitter|fifo_tx|count[3]~337_combout\,
	cout => \regs|transmitter|fifo_tx|count[3]~338\);

\regs|transmitter|fifo_tx|count[4]~339\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|count[4]~339_combout\ = \regs|transmitter|fifo_tx|count\(4) $ \regs|transmitter|fifo_tx|count[3]~338\ $ !\regs|transmitter|tf_pop~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|fifo_tx|count\(4),
	datad => \regs|transmitter|tf_pop~regout\,
	cin => \regs|transmitter|fifo_tx|count[3]~338\,
	combout => \regs|transmitter|fifo_tx|count[4]~339_combout\);

\regs|always6~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|always6~11_combout\ = \regs|always4~28_combout\ & !\wb_interface|wb_adr_is\(2) & !\wb_interface|wb_adr_int[0]~64_combout\ & \wb_interface|wb_adr_int[1]~63_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|always4~28_combout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \wb_interface|wb_adr_int[0]~64_combout\,
	datad => \wb_interface|wb_adr_int[1]~63_combout\,
	combout => \regs|always6~11_combout\);

\regs|tx_reset~32\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|tx_reset~32_combout\ = \wb_interface|Mux37~26_combout\ & \regs|always6~11_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|Mux37~26_combout\,
	datad => \regs|always6~11_combout\,
	combout => \regs|tx_reset~32_combout\);

\regs|tx_reset\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|tx_reset~32_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|tx_reset~regout\);

\regs|fifo_write~23\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|fifo_write~23_combout\ = !\wb_interface|wb_adr_int[0]~64_combout\ & !\regs|lcr\(7) & !\wb_interface|wb_adr_int[1]~63_combout\ & \regs|always4~29_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_int[0]~64_combout\,
	datab => \regs|lcr\(7),
	datac => \wb_interface|wb_adr_int[1]~63_combout\,
	datad => \regs|always4~29_combout\,
	combout => \regs|fifo_write~23_combout\);

\regs|tf_push\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|fifo_write~23_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|tf_push~regout\);

\regs|transmitter|fifo_tx|count[3]~332\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|count[3]~332_combout\ = \regs|tx_reset~regout\ # \regs|tf_push~regout\ & (!\regs|transmitter|tf_pop~regout\) # !\regs|tf_push~regout\ & !\regs|lsr5~74_combout\ & \regs|transmitter|tf_pop~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000111111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr5~74_combout\,
	datab => \regs|tf_push~regout\,
	datac => \regs|tx_reset~regout\,
	datad => \regs|transmitter|tf_pop~regout\,
	combout => \regs|transmitter|fifo_tx|count[3]~332_combout\);

\regs|transmitter|fifo_tx|count[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|count[4]~339_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|tx_reset~regout\,
	ena => \regs|transmitter|fifo_tx|count[3]~332_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|count\(4));

\regs|transmitter|fifo_tx|count[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|count[3]~337_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|tx_reset~regout\,
	ena => \regs|transmitter|fifo_tx|count[3]~332_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|count\(3));

\regs|transmitter|fifo_tx|count[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|count[2]~335_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|tx_reset~regout\,
	ena => \regs|transmitter|fifo_tx|count[3]~332_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|count\(2));

\regs|lsr5~74\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr5~74_combout\ = \regs|lsr5~73_combout\ & !\regs|transmitter|fifo_tx|count\(4) & !\regs|transmitter|fifo_tx|count\(3) & !\regs|transmitter|fifo_tx|count\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr5~73_combout\,
	datab => \regs|transmitter|fifo_tx|count\(4),
	datac => \regs|transmitter|fifo_tx|count\(3),
	datad => \regs|transmitter|fifo_tx|count\(2),
	combout => \regs|lsr5~74_combout\);

\regs|transmitter|Mux2~359\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux2~359_combout\ = !\regs|transmitter|tstate\(0) & (\regs|transmitter|tstate\(2) & \regs|transmitter|Equal1~36_combout\ # !\regs|transmitter|tstate\(2) & (!\regs|lsr5~74_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100000001101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(2),
	datab => \regs|transmitter|Equal1~36_combout\,
	datac => \regs|transmitter|tstate\(0),
	datad => \regs|lsr5~74_combout\,
	combout => \regs|transmitter|Mux2~359_combout\);

\regs|transmitter|Mux2~360\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux2~360_combout\ = \regs|transmitter|tstate\(1) & \regs|transmitter|Mux2~358_combout\ & (!\regs|transmitter|tstate\(2)) # !\regs|transmitter|tstate\(1) & (\regs|transmitter|Mux2~359_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|Mux2~358_combout\,
	datab => \regs|transmitter|Mux2~359_combout\,
	datac => \regs|transmitter|tstate\(2),
	datad => \regs|transmitter|tstate\(1),
	combout => \regs|transmitter|Mux2~360_combout\);

\regs|transmitter|tstate[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|Mux2~360_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|enable~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|tstate\(2));

\regs|transmitter|Mux16~69\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux16~69_combout\ = \regs|transmitter|WideNor1~combout\ & \regs|transmitter|Add1~73_combout\ # !\regs|transmitter|WideNor1~combout\ & (\regs|lcr\(2) & \regs|transmitter|tstate\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|Add1~73_combout\,
	datab => \regs|lcr\(2),
	datac => \regs|transmitter|WideNor1~combout\,
	datad => \regs|transmitter|tstate\(2),
	combout => \regs|transmitter|Mux16~69_combout\);

\regs|transmitter|counter[2]~594\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|counter[2]~594_combout\ = \regs|enable~regout\ & (\regs|transmitter|tstate\(2) $ (\regs|transmitter|tstate\(0) # \regs|transmitter|tstate\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100010001001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(2),
	datab => \regs|enable~regout\,
	datac => \regs|transmitter|tstate\(0),
	datad => \regs|transmitter|tstate\(1),
	combout => \regs|transmitter|counter[2]~594_combout\);

\regs|transmitter|counter[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|Mux16~69_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|transmitter|counter[2]~594_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|counter\(4));

\regs|transmitter|Mux16~70\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux16~70_combout\ = \regs|transmitter|tstate\(2) & \regs|transmitter|WideNor1~23_combout\ & !\regs|transmitter|counter\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(2),
	datab => \regs|transmitter|WideNor1~23_combout\,
	datad => \regs|transmitter|counter\(0),
	combout => \regs|transmitter|Mux16~70_combout\);

\regs|transmitter|counter[1]~595\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|counter[1]~595_combout\ = \regs|transmitter|counter[2]~594_combout\ & \regs|transmitter|Add1~67_combout\ & (!\regs|transmitter|Mux16~70_combout\) # !\regs|transmitter|counter[2]~594_combout\ & (\regs|transmitter|counter\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000010111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|Add1~67_combout\,
	datab => \regs|transmitter|counter[2]~594_combout\,
	datac => \regs|transmitter|counter\(1),
	datad => \regs|transmitter|Mux16~70_combout\,
	combout => \regs|transmitter|counter[1]~595_combout\);

\regs|transmitter|counter[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|counter[1]~595_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|counter\(1));

\regs|transmitter|Mux18~81\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux18~81_combout\ = \regs|transmitter|WideNor1~23_combout\ & (!\regs|transmitter|counter\(0)) # !\regs|transmitter|WideNor1~23_combout\ & \regs|transmitter|Add1~69_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000011111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|WideNor1~23_combout\,
	datac => \regs|transmitter|Add1~69_combout\,
	datad => \regs|transmitter|counter\(0),
	combout => \regs|transmitter|Mux18~81_combout\);

\regs|transmitter|counter[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|Mux18~81_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|transmitter|counter[2]~594_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|counter\(2));

\regs|transmitter|WideNor1~23\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|WideNor1~23_combout\ = !\regs|transmitter|counter\(3) & !\regs|transmitter|counter\(4) & !\regs|transmitter|counter\(2) & !\regs|transmitter|counter\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|counter\(3),
	datab => \regs|transmitter|counter\(4),
	datac => \regs|transmitter|counter\(2),
	datad => \regs|transmitter|counter\(1),
	combout => \regs|transmitter|WideNor1~23_combout\);

\regs|transmitter|Mux20~65\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux20~65_combout\ = \regs|transmitter|WideNor1~23_combout\ & (!\regs|transmitter|counter\(0)) # !\regs|transmitter|WideNor1~23_combout\ & \regs|transmitter|Add1~65_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|Add1~65_combout\,
	datac => \regs|transmitter|counter\(0),
	datad => \regs|transmitter|WideNor1~23_combout\,
	combout => \regs|transmitter|Mux20~65_combout\);

\regs|transmitter|counter[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|Mux20~65_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|transmitter|counter[2]~594_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|counter\(0));

\regs|transmitter|Equal1~36\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Equal1~36_combout\ = !\regs|transmitter|WideNor1~23_combout\ # !\regs|transmitter|counter\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|transmitter|counter\(0),
	datad => \regs|transmitter|WideNor1~23_combout\,
	combout => \regs|transmitter|Equal1~36_combout\);

\regs|transmitter|bit_counter[0]~661\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_counter[0]~661_combout\ = !\regs|transmitter|tstate\(2) & !\regs|transmitter|Equal1~36_combout\ & !\regs|transmitter|tstate\(0) & \regs|transmitter|tstate\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(2),
	datab => \regs|transmitter|Equal1~36_combout\,
	datac => \regs|transmitter|tstate\(0),
	datad => \regs|transmitter|tstate\(1),
	combout => \regs|transmitter|bit_counter[0]~661_combout\);

\regs|transmitter|parity_xor~22\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|parity_xor~22_combout\ = \regs|transmitter|tstate\(2) & \regs|enable~regout\ & \regs|transmitter|tstate\(0) & !\regs|transmitter|tstate\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(2),
	datab => \regs|enable~regout\,
	datac => \regs|transmitter|tstate\(0),
	datad => \regs|transmitter|tstate\(1),
	combout => \regs|transmitter|parity_xor~22_combout\);

\regs|transmitter|bit_counter[2]~662\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_counter[2]~662_combout\ = \regs|transmitter|parity_xor~22_combout\ # \regs|transmitter|bit_counter\(2) & (\regs|transmitter|bit_counter[2]~660_combout\ # !\regs|transmitter|bit_counter[0]~661_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|bit_counter[2]~660_combout\,
	datab => \regs|transmitter|bit_counter[0]~661_combout\,
	datac => \regs|transmitter|bit_counter\(2),
	datad => \regs|transmitter|parity_xor~22_combout\,
	combout => \regs|transmitter|bit_counter[2]~662_combout\);

\regs|transmitter|bit_counter[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|bit_counter[2]~662_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|bit_counter\(2));

\regs|transmitter|LessThan0~50\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|LessThan0~50_combout\ = \regs|transmitter|bit_counter\(0) # \regs|transmitter|bit_counter\(2) # \regs|transmitter|bit_counter\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|bit_counter\(0),
	datac => \regs|transmitter|bit_counter\(2),
	datad => \regs|transmitter|bit_counter\(1),
	combout => \regs|transmitter|LessThan0~50_combout\);

\regs|transmitter|bit_counter[0]~664\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_counter[0]~664_combout\ = \regs|enable~regout\ & (\regs|transmitter|bit_counter[0]~663_combout\ # \regs|transmitter|LessThan0~50_combout\ & \regs|transmitter|bit_counter[0]~661_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|bit_counter[0]~663_combout\,
	datab => \regs|transmitter|LessThan0~50_combout\,
	datac => \regs|transmitter|bit_counter[0]~661_combout\,
	datad => \regs|enable~regout\,
	combout => \regs|transmitter|bit_counter[0]~664_combout\);

\regs|lcr[0]~167\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lcr[0]~167_combout\ = !\wb_interface|Mux39~26_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|Mux39~26_combout\,
	combout => \regs|lcr[0]~167_combout\);

\regs|lcr[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lcr[0]~167_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|always4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lcr\(0));

\regs|transmitter|bit_counter[0]~665\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_counter[0]~665_combout\ = \regs|transmitter|bit_counter[0]~664_combout\ & (\regs|transmitter|tstate\(0) & (!\regs|lcr\(0)) # !\regs|transmitter|tstate\(0) & !\regs|transmitter|bit_counter\(0)) # 
-- !\regs|transmitter|bit_counter[0]~664_combout\ & (\regs|transmitter|bit_counter\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011010010111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(0),
	datab => \regs|transmitter|bit_counter[0]~664_combout\,
	datac => \regs|transmitter|bit_counter\(0),
	datad => \regs|lcr\(0),
	combout => \regs|transmitter|bit_counter[0]~665_combout\);

\regs|transmitter|bit_counter[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|bit_counter[0]~665_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|bit_counter\(0));

\regs|transmitter|Add0~49\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Add0~49_combout\ = \regs|transmitter|bit_counter\(1) $ !\regs|transmitter|bit_counter\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|transmitter|bit_counter\(1),
	datad => \regs|transmitter|bit_counter\(0),
	combout => \regs|transmitter|Add0~49_combout\);

\regs|lcr[1]~168\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lcr[1]~168_combout\ = !\wb_interface|Mux38~26_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|Mux38~26_combout\,
	combout => \regs|lcr[1]~168_combout\);

\regs|lcr[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lcr[1]~168_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|always4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lcr\(1));

\regs|lcr[1]~_wirecell\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lcr[1]~_wirecell_combout\ = !\regs|lcr\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \regs|lcr\(1),
	combout => \regs|lcr[1]~_wirecell_combout\);

\regs|transmitter|bit_counter[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|Add0~49_combout\,
	sdata => \regs|lcr[1]~_wirecell_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|transmitter|tstate\(0),
	ena => \regs|transmitter|bit_counter[0]~664_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|bit_counter\(1));

\regs|transmitter|Mux4~494\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux4~494_combout\ = \regs|lcr\(3) & !\regs|transmitter|bit_counter\(1) & !\regs|transmitter|bit_counter\(2) & !\regs|transmitter|bit_counter\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(3),
	datab => \regs|transmitter|bit_counter\(1),
	datac => \regs|transmitter|bit_counter\(2),
	datad => \regs|transmitter|bit_counter\(0),
	combout => \regs|transmitter|Mux4~494_combout\);

\regs|transmitter|Mux4~495\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux4~495_combout\ = \regs|transmitter|tstate\(1) & !\regs|transmitter|Equal1~36_combout\ & \regs|transmitter|Mux4~494_combout\ # !\regs|transmitter|tstate\(1) & (!\regs|lsr5~74_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000001110101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(1),
	datab => \regs|transmitter|Equal1~36_combout\,
	datac => \regs|transmitter|Mux4~494_combout\,
	datad => \regs|lsr5~74_combout\,
	combout => \regs|transmitter|Mux4~495_combout\);

\regs|transmitter|Mux4~493\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux4~493_combout\ = \regs|transmitter|tstate\(2) & (!\regs|transmitter|tstate\(1)) # !\regs|transmitter|tstate\(2) & (!\regs|transmitter|counter\(0) # !\regs|transmitter|WideNor1~23_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001010110111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(2),
	datab => \regs|transmitter|WideNor1~23_combout\,
	datac => \regs|transmitter|counter\(0),
	datad => \regs|transmitter|tstate\(1),
	combout => \regs|transmitter|Mux4~493_combout\);

\regs|transmitter|Mux4~496\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux4~496_combout\ = \regs|transmitter|tstate\(0) & (\regs|transmitter|Mux4~493_combout\) # !\regs|transmitter|tstate\(0) & !\regs|transmitter|tstate\(2) & \regs|transmitter|Mux4~495_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010000000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(2),
	datab => \regs|transmitter|Mux4~495_combout\,
	datac => \regs|transmitter|tstate\(0),
	datad => \regs|transmitter|Mux4~493_combout\,
	combout => \regs|transmitter|Mux4~496_combout\);

\regs|transmitter|tstate[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|Mux4~496_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|enable~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|tstate\(0));

\dbg|Equal0~38\ : cycloneii_lcell_comb
-- Equation(s):
-- \dbg|Equal0~38_combout\ = !\wb_interface|wb_adr_int[1]~63_combout\ & !\wb_interface|wb_adr_int[0]~64_combout\ & \wb_interface|wb_adr_is\(3) & !\wb_interface|wb_adr_is\(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_int[1]~63_combout\,
	datab => \wb_interface|wb_adr_int[0]~64_combout\,
	datac => \wb_interface|wb_adr_is\(3),
	datad => \wb_interface|wb_adr_is\(4),
	combout => \dbg|Equal0~38_combout\);

\wb_interface|Mux31~215\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux31~215_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|transmitter|tstate\(0)) # !\wb_interface|wb_adr_is\(2) & \regs|lsr0r~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0r~regout\,
	datab => \regs|transmitter|tstate\(0),
	datac => \dbg|Equal0~38_combout\,
	datad => \wb_interface|wb_adr_is\(2),
	combout => \wb_interface|Mux31~215_combout\);

\regs|always8~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|always8~0_combout\ = \wb_interface|wb_adr_is\(2) & \wb_interface|wb_adr_int[1]~63_combout\ & \wb_interface|wb_adr_int[0]~64_combout\ & \regs|always4~28_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_is\(2),
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \wb_interface|wb_adr_int[0]~64_combout\,
	datad => \regs|always4~28_combout\,
	combout => \regs|always8~0_combout\);

\regs|scratch[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux39~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always8~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|scratch\(0));

\regs|msi_reset~17\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|msi_reset~17_combout\ = \wb_interface|wb_adr_int[0]~64_combout\ # !\regs|msi_reset~regout\ # !\wb_interface|wb_adr_int[1]~63_combout\ # !\regs|lsr_mask_condition~35_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111101111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr_mask_condition~35_combout\,
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \regs|msi_reset~regout\,
	datad => \wb_interface|wb_adr_int[0]~64_combout\,
	combout => \regs|msi_reset~17_combout\);

\regs|msi_reset\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|msi_reset~17_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|msi_reset~regout\);

\cts_pad_i~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_cts_pad_i,
	combout => \cts_pad_i~combout\);

\regs|msr~172\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|msr~172_combout\ = \regs|msi_reset~regout\ & (\regs|msr\(0) # \regs|delayed_modem_signals\(0) $ !\cts_pad_i~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100100011000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|delayed_modem_signals\(0),
	datab => \regs|msi_reset~regout\,
	datac => \regs|msr\(0),
	datad => \cts_pad_i~combout\,
	combout => \regs|msr~172_combout\);

\regs|msr[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|msr~172_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|msr\(0));

\regs|msr_read~19\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|msr_read~19_combout\ = \wb_interface|wb_adr_int[1]~63_combout\ & !\wb_interface|wb_adr_int[0]~64_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \wb_interface|wb_adr_int[0]~64_combout\,
	combout => \regs|msr_read~19_combout\);

\regs|Mux7~344\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~344_combout\ = \wb_interface|wb_adr_int[0]~64_combout\ # !\wb_interface|wb_adr_int[1]~63_combout\ & !\wb_interface|wb_adr_is\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011011101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_int[1]~63_combout\,
	datab => \wb_interface|wb_adr_int[0]~64_combout\,
	datad => \wb_interface|wb_adr_is\(2),
	combout => \regs|Mux7~344_combout\);

\regs|Mux7~345\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~345_combout\ = \wb_interface|wb_adr_int[0]~64_combout\ # \wb_interface|wb_adr_int[1]~63_combout\ & \wb_interface|wb_adr_is\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_int[1]~63_combout\,
	datab => \wb_interface|wb_adr_int[0]~64_combout\,
	datad => \wb_interface|wb_adr_is\(2),
	combout => \regs|Mux7~345_combout\);

\regs|receiver|counter_b[0]~224\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_b[0]~224_combout\ = !\regs|receiver|counter_b\(0)
-- \regs|receiver|counter_b[0]~225\ = CARRY(!\regs|receiver|counter_b\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|counter_b\(0),
	combout => \regs|receiver|counter_b[0]~224_combout\,
	cout => \regs|receiver|counter_b[0]~225\);

\~GND\ : cycloneii_lcell_comb
-- Equation(s):
-- \~GND~combout\ = GND

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	combout => \~GND~combout\);

\regs|lcr[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux33~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|always4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lcr\(6));

\srx_pad_i~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_srx_pad_i,
	combout => \srx_pad_i~combout\);

\regs|i_uart_sync_flops|flop_0[0]~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|i_uart_sync_flops|flop_0[0]~2_combout\ = !\srx_pad_i~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \srx_pad_i~combout\,
	combout => \regs|i_uart_sync_flops|flop_0[0]~2_combout\);

\regs|i_uart_sync_flops|flop_0[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|i_uart_sync_flops|flop_0[0]~2_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|i_uart_sync_flops|flop_0\(0));

\regs|i_uart_sync_flops|sync_dat_o[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|i_uart_sync_flops|flop_0\(0),
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|i_uart_sync_flops|sync_dat_o\(0));

\regs|always7~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|always7~0_combout\ = \regs|always4~28_combout\ & \wb_interface|wb_adr_is\(2) & !\wb_interface|wb_adr_int[0]~64_combout\ & !\wb_interface|wb_adr_int[1]~63_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|always4~28_combout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \wb_interface|wb_adr_int[0]~64_combout\,
	datad => \wb_interface|wb_adr_int[1]~63_combout\,
	combout => \regs|always7~0_combout\);

\regs|mcr[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux35~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always7~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|mcr\(4));

\regs|serial_in~34\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|serial_in~34_combout\ = \regs|mcr\(4) & !\regs|transmitter|stx_o_tmp~regout\ & !\regs|lcr\(6) # !\regs|mcr\(4) & (!\regs|i_uart_sync_flops|sync_dat_o\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|stx_o_tmp~regout\,
	datab => \regs|lcr\(6),
	datac => \regs|i_uart_sync_flops|sync_dat_o\(0),
	datad => \regs|mcr\(4),
	combout => \regs|serial_in~34_combout\);

\regs|receiver|counter_b[3]~231\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_b[3]~231_combout\ = \regs|receiver|counter_b\(3) & (\regs|receiver|counter_b[2]~230\ $ GND) # !\regs|receiver|counter_b\(3) & !\regs|receiver|counter_b[2]~230\ & VCC
-- \regs|receiver|counter_b[3]~232\ = CARRY(\regs|receiver|counter_b\(3) & !\regs|receiver|counter_b[2]~230\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_b\(3),
	datad => VCC,
	cin => \regs|receiver|counter_b[2]~230\,
	combout => \regs|receiver|counter_b[3]~231_combout\,
	cout => \regs|receiver|counter_b[3]~232\);

\regs|receiver|Decoder4~13\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Decoder4~13_combout\ = \regs|lcr\(2) & \regs|lcr\(1) & \regs|lcr\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|lcr\(2),
	datac => \regs|lcr\(1),
	datad => \regs|lcr\(0),
	combout => \regs|receiver|Decoder4~13_combout\);

\regs|receiver|counter_b[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_b[3]~231_combout\,
	sdata => \regs|receiver|Decoder4~13_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|serial_in~34_combout\,
	ena => \regs|receiver|counter_b[4]~226_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_b\(3));

\regs|receiver|Equal0~133\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Equal0~133_combout\ = \regs|receiver|counter_b\(1) & \regs|receiver|counter_b\(2) & \regs|receiver|counter_b\(0) & \regs|receiver|counter_b\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_b\(1),
	datab => \regs|receiver|counter_b\(2),
	datac => \regs|receiver|counter_b\(0),
	datad => \regs|receiver|counter_b\(3),
	combout => \regs|receiver|Equal0~133_combout\);

\regs|receiver|counter_b[4]~226\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_b[4]~226_combout\ = \regs|serial_in~34_combout\ # \regs|enable~regout\ & (!\regs|receiver|Equal0~133_combout\ # !\regs|receiver|Equal0~134_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111101110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal0~134_combout\,
	datab => \regs|receiver|Equal0~133_combout\,
	datac => \regs|enable~regout\,
	datad => \regs|serial_in~34_combout\,
	combout => \regs|receiver|counter_b[4]~226_combout\);

\regs|receiver|counter_b[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_b[0]~224_combout\,
	sdata => \~GND~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|serial_in~34_combout\,
	ena => \regs|receiver|counter_b[4]~226_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_b\(0));

\regs|receiver|counter_b[2]~229\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_b[2]~229_combout\ = \regs|receiver|counter_b\(2) & !\regs|receiver|counter_b[1]~228\ # !\regs|receiver|counter_b\(2) & (\regs|receiver|counter_b[1]~228\ # GND)
-- \regs|receiver|counter_b[2]~230\ = CARRY(!\regs|receiver|counter_b[1]~228\ # !\regs|receiver|counter_b\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|counter_b\(2),
	datad => VCC,
	cin => \regs|receiver|counter_b[1]~228\,
	combout => \regs|receiver|counter_b[2]~229_combout\,
	cout => \regs|receiver|counter_b[2]~230\);

\regs|receiver|counter_b[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_b[2]~229_combout\,
	sdata => \~GND~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|serial_in~34_combout\,
	ena => \regs|receiver|counter_b[4]~226_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_b\(2));

\regs|receiver|counter_b[4]~233\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_b[4]~233_combout\ = \regs|receiver|counter_b\(4) & !\regs|receiver|counter_b[3]~232\ # !\regs|receiver|counter_b\(4) & (\regs|receiver|counter_b[3]~232\ # GND)
-- \regs|receiver|counter_b[4]~234\ = CARRY(!\regs|receiver|counter_b[3]~232\ # !\regs|receiver|counter_b\(4))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_b\(4),
	datad => VCC,
	cin => \regs|receiver|counter_b[3]~232\,
	combout => \regs|receiver|counter_b[4]~233_combout\,
	cout => \regs|receiver|counter_b[4]~234\);

\regs|receiver|counter_b[5]~235\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_b[5]~235_combout\ = \regs|receiver|counter_b\(5) & \regs|receiver|counter_b[4]~234\ & VCC # !\regs|receiver|counter_b\(5) & !\regs|receiver|counter_b[4]~234\
-- \regs|receiver|counter_b[5]~236\ = CARRY(!\regs|receiver|counter_b\(5) & !\regs|receiver|counter_b[4]~234\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|counter_b\(5),
	datad => VCC,
	cin => \regs|receiver|counter_b[4]~234\,
	combout => \regs|receiver|counter_b[5]~235_combout\,
	cout => \regs|receiver|counter_b[5]~236\);

\regs|lcr[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux36~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lcr\(3));

\regs|receiver|WideOr6~23\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|WideOr6~23_combout\ = \regs|lcr\(1) $ (\regs|lcr\(3) & (\regs|lcr\(2) # !\regs|lcr\(0)) # !\regs|lcr\(3) & \regs|lcr\(2) & !\regs|lcr\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110101001010110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(1),
	datab => \regs|lcr\(3),
	datac => \regs|lcr\(2),
	datad => \regs|lcr\(0),
	combout => \regs|receiver|WideOr6~23_combout\);

\regs|receiver|counter_b[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_b[5]~235_combout\,
	sdata => \regs|receiver|WideOr6~23_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|serial_in~34_combout\,
	ena => \regs|receiver|counter_b[4]~226_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_b\(5));

\regs|receiver|WideOr5~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|WideOr5~15_combout\ = \regs|lcr\(1) & (\regs|lcr\(3) & !\regs|lcr\(2) & \regs|lcr\(0) # !\regs|lcr\(3) & (\regs|lcr\(0) # !\regs|lcr\(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010101000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(1),
	datab => \regs|lcr\(3),
	datac => \regs|lcr\(2),
	datad => \regs|lcr\(0),
	combout => \regs|receiver|WideOr5~15_combout\);

\regs|receiver|counter_b[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_b[6]~237_combout\,
	sdata => \regs|receiver|WideOr5~15_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|serial_in~34_combout\,
	ena => \regs|receiver|counter_b[4]~226_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_b\(6));

\regs|receiver|WideOr7~30\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|WideOr7~30_combout\ = \regs|lcr\(3) $ \regs|lcr\(2) $ \regs|lcr\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|lcr\(3),
	datac => \regs|lcr\(2),
	datad => \regs|lcr\(0),
	combout => \regs|receiver|WideOr7~30_combout\);

\regs|receiver|counter_b[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_b[4]~233_combout\,
	sdata => \regs|receiver|WideOr7~30_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|serial_in~34_combout\,
	ena => \regs|receiver|counter_b[4]~226_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_b\(4));

\regs|receiver|Equal0~134\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Equal0~134_combout\ = \regs|receiver|counter_b\(7) & !\regs|receiver|counter_b\(5) & !\regs|receiver|counter_b\(6) & \regs|receiver|counter_b\(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_b\(7),
	datab => \regs|receiver|counter_b\(5),
	datac => \regs|receiver|counter_b\(6),
	datad => \regs|receiver|counter_b\(4),
	combout => \regs|receiver|Equal0~134_combout\);

\regs|receiver|rparity~155\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rparity~155_combout\ = !\regs|receiver|rstate\(3) & \regs|receiver|rstate\(1) & \regs|enable~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(3),
	datab => \regs|receiver|rstate\(1),
	datad => \regs|enable~regout\,
	combout => \regs|receiver|rparity~155_combout\);

\regs|receiver|rbit_counter[2]~375\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rbit_counter[2]~375_combout\ = \regs|receiver|rbit_counter\(0) # \regs|receiver|rbit_counter\(1) # !\regs|receiver|rstate\(2) # !\regs|receiver|rparity~155_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rbit_counter\(0),
	datab => \regs|receiver|rbit_counter\(1),
	datac => \regs|receiver|rparity~155_combout\,
	datad => \regs|receiver|rstate\(2),
	combout => \regs|receiver|rbit_counter[2]~375_combout\);

\regs|receiver|rbit_counter[2]~376\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rbit_counter[2]~376_combout\ = \regs|receiver|rshift[6]~1506_combout\ & (\regs|receiver|rstate\(2) # \regs|receiver|rbit_counter\(2) & \regs|receiver|rbit_counter[2]~375_combout\) # !\regs|receiver|rshift[6]~1506_combout\ & 
-- (\regs|receiver|rbit_counter\(2) & \regs|receiver|rbit_counter[2]~375_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rshift[6]~1506_combout\,
	datab => \regs|receiver|rstate\(2),
	datac => \regs|receiver|rbit_counter\(2),
	datad => \regs|receiver|rbit_counter[2]~375_combout\,
	combout => \regs|receiver|rbit_counter[2]~376_combout\);

\regs|receiver|rbit_counter[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rbit_counter[2]~376_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rbit_counter\(2));

\regs|receiver|Equal3~33\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Equal3~33_combout\ = !\regs|receiver|rbit_counter\(0) & !\regs|receiver|rbit_counter\(1) & !\regs|receiver|rbit_counter\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rbit_counter\(0),
	datab => \regs|receiver|rbit_counter\(1),
	datad => \regs|receiver|rbit_counter\(2),
	combout => \regs|receiver|Equal3~33_combout\);

\regs|receiver|rbit_counter[0]~377\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rbit_counter[0]~377_combout\ = \regs|receiver|rparity~155_combout\ & \regs|receiver|rstate\(2) & (!\regs|receiver|Equal3~33_combout\ # !\regs|receiver|rstate\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(0),
	datab => \regs|receiver|rparity~155_combout\,
	datac => \regs|receiver|Equal3~33_combout\,
	datad => \regs|receiver|rstate\(2),
	combout => \regs|receiver|rbit_counter[0]~377_combout\);

\regs|receiver|rbit_counter[0]~378\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rbit_counter[0]~378_combout\ = \regs|receiver|rbit_counter[0]~377_combout\ & (\regs|receiver|rstate\(0) & !\regs|receiver|rbit_counter\(0) # !\regs|receiver|rstate\(0) & (!\regs|lcr\(0))) # !\regs|receiver|rbit_counter[0]~377_combout\ & 
-- (\regs|receiver|rbit_counter\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011100001111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(0),
	datab => \regs|receiver|rbit_counter[0]~377_combout\,
	datac => \regs|receiver|rbit_counter\(0),
	datad => \regs|lcr\(0),
	combout => \regs|receiver|rbit_counter[0]~378_combout\);

\regs|receiver|rbit_counter[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rbit_counter[0]~378_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rbit_counter\(0));

\regs|receiver|Add1~49\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Add1~49_combout\ = \regs|receiver|rbit_counter\(1) $ !\regs|receiver|rbit_counter\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|receiver|rbit_counter\(1),
	datad => \regs|receiver|rbit_counter\(0),
	combout => \regs|receiver|Add1~49_combout\);

\regs|receiver|rbit_counter[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Add1~49_combout\,
	sdata => \regs|lcr[1]~_wirecell_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|receiver|ALT_INV_rstate\(0),
	ena => \regs|receiver|rbit_counter[0]~377_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rbit_counter\(1));

\regs|receiver|Mux4~1009\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux4~1009_combout\ = !\regs|receiver|rbit_counter\(0) & !\regs|receiver|rbit_counter\(1) & !\regs|lcr\(3) & !\regs|receiver|rbit_counter\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rbit_counter\(0),
	datab => \regs|receiver|rbit_counter\(1),
	datac => \regs|lcr\(3),
	datad => \regs|receiver|rbit_counter\(2),
	combout => \regs|receiver|Mux4~1009_combout\);

\regs|receiver|Mux4~1014\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux4~1014_combout\ = \regs|receiver|rstate\(0) & (\regs|receiver|rstate\(1) & \regs|receiver|Mux4~1009_combout\) # !\regs|receiver|rstate\(0) & \regs|receiver|Mux4~1013_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Mux4~1013_combout\,
	datab => \regs|receiver|rstate\(0),
	datac => \regs|receiver|rstate\(1),
	datad => \regs|receiver|Mux4~1009_combout\,
	combout => \regs|receiver|Mux4~1014_combout\);

\regs|receiver|rcounter16[3]~435\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rcounter16[3]~435_combout\ = \regs|receiver|rstate\(2) & (!\regs|receiver|rstate\(1) # !\regs|receiver|rstate\(0)) # !\regs|receiver|rstate\(2) & \regs|receiver|rcounter16[3]~434_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010111011101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rcounter16[3]~434_combout\,
	datab => \regs|receiver|rstate\(2),
	datac => \regs|receiver|rstate\(0),
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|rcounter16[3]~435_combout\);

\regs|receiver|Mux10~46\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux10~46_combout\ = \regs|receiver|rcounter16[3]~435_combout\ & !\regs|receiver|rcounter16\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rcounter16[3]~435_combout\,
	datac => \regs|receiver|rcounter16\(0),
	combout => \regs|receiver|Mux10~46_combout\);

\regs|receiver|Mux3~358\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux3~358_combout\ = !\regs|receiver|rstate\(2) & \regs|receiver|rstate\(3) & (\regs|receiver|rstate\(1) $ \regs|receiver|rstate\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000011000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(1),
	datab => \regs|receiver|rstate\(0),
	datac => \regs|receiver|rstate\(2),
	datad => \regs|receiver|rstate\(3),
	combout => \regs|receiver|Mux3~358_combout\);

\regs|receiver|Mux3~357\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux3~357_combout\ = \regs|receiver|rstate\(1) & \regs|receiver|rf_push~197_combout\ # !\regs|receiver|rstate\(1) & (\regs|receiver|Equal2~31_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rf_push~197_combout\,
	datac => \regs|receiver|rstate\(1),
	datad => \regs|receiver|Equal2~31_combout\,
	combout => \regs|receiver|Mux3~357_combout\);

\regs|receiver|Mux3~360\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux3~360_combout\ = \regs|receiver|Mux3~359_combout\ & (\regs|receiver|Mux3~358_combout\ & \regs|receiver|Mux3~357_combout\ # !\regs|receiver|rstate\(3)) # !\regs|receiver|Mux3~359_combout\ & \regs|receiver|Mux3~358_combout\ & 
-- (\regs|receiver|Mux3~357_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Mux3~359_combout\,
	datab => \regs|receiver|Mux3~358_combout\,
	datac => \regs|receiver|rstate\(3),
	datad => \regs|receiver|Mux3~357_combout\,
	combout => \regs|receiver|Mux3~360_combout\);

\regs|receiver|rstate[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Mux3~360_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|enable~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rstate\(3));

\regs|receiver|Mux9~40\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux9~40_combout\ = \regs|receiver|rcounter16\(1) $ !\regs|receiver|rcounter16\(0) # !\regs|receiver|rcounter16[3]~435_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001100111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rcounter16[3]~435_combout\,
	datac => \regs|receiver|rcounter16\(1),
	datad => \regs|receiver|rcounter16\(0),
	combout => \regs|receiver|Mux9~40_combout\);

\regs|receiver|rcounter16[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Mux9~40_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rcounter16[3]~433_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rcounter16\(1));

\regs|receiver|Equal1~59\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Equal1~59_combout\ = \regs|receiver|rcounter16\(2) & !\regs|receiver|rcounter16\(3) & \regs|receiver|rcounter16\(1) & \regs|receiver|rcounter16\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rcounter16\(2),
	datab => \regs|receiver|rcounter16\(3),
	datac => \regs|receiver|rcounter16\(1),
	datad => \regs|receiver|rcounter16\(0),
	combout => \regs|receiver|Equal1~59_combout\);

\regs|receiver|rframing_error~197\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rframing_error~197_combout\ = \regs|receiver|rframing_error~196_combout\ & (\regs|receiver|Equal1~59_combout\ & (!\regs|serial_in~34_combout\) # !\regs|receiver|Equal1~59_combout\ & \regs|receiver|rframing_error~regout\) # 
-- !\regs|receiver|rframing_error~196_combout\ & (\regs|receiver|rframing_error~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111000011111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rframing_error~196_combout\,
	datab => \regs|receiver|Equal1~59_combout\,
	datac => \regs|receiver|rframing_error~regout\,
	datad => \regs|serial_in~34_combout\,
	combout => \regs|receiver|rframing_error~197_combout\);

\regs|receiver|rframing_error\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rframing_error~197_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rframing_error~regout\);

\regs|receiver|Mux6~737\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux6~737_combout\ = !\regs|receiver|rstate\(0) & !\regs|serial_in~34_combout\ & (!\regs|receiver|Equal0~133_combout\ # !\regs|receiver|Equal0~134_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal0~134_combout\,
	datab => \regs|receiver|rstate\(0),
	datac => \regs|receiver|Equal0~133_combout\,
	datad => \regs|serial_in~34_combout\,
	combout => \regs|receiver|Mux6~737_combout\);

\regs|receiver|rcounter16[3]~432\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rcounter16[3]~432_combout\ = !\regs|receiver|rframing_error~regout\ & \regs|receiver|Mux6~737_combout\ # !\regs|receiver|rstate\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011111100110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rstate\(1),
	datac => \regs|receiver|rframing_error~regout\,
	datad => \regs|receiver|Mux6~737_combout\,
	combout => \regs|receiver|rcounter16[3]~432_combout\);

\regs|receiver|rcounter16[3]~433\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rcounter16[3]~433_combout\ = \regs|enable~regout\ & (!\regs|receiver|rstate\(2) & \regs|receiver|rcounter16[3]~432_combout\ # !\regs|receiver|rstate\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010101000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|enable~regout\,
	datab => \regs|receiver|rstate\(2),
	datac => \regs|receiver|rstate\(3),
	datad => \regs|receiver|rcounter16[3]~432_combout\,
	combout => \regs|receiver|rcounter16[3]~433_combout\);

\regs|receiver|rcounter16[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Mux10~46_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rcounter16[3]~433_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rcounter16\(0));

\regs|receiver|Mux8~52\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux8~52_combout\ = \regs|receiver|rcounter16\(2) $ (!\regs|receiver|rcounter16\(1) & !\regs|receiver|rcounter16\(0)) # !\regs|receiver|rcounter16[3]~435_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110110111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rcounter16\(1),
	datab => \regs|receiver|rcounter16[3]~435_combout\,
	datac => \regs|receiver|rcounter16\(2),
	datad => \regs|receiver|rcounter16\(0),
	combout => \regs|receiver|Mux8~52_combout\);

\regs|receiver|rcounter16[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Mux8~52_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rcounter16[3]~433_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rcounter16\(2));

\regs|receiver|Mux7~52\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux7~52_combout\ = \regs|receiver|rcounter16\(3) $ (\regs|receiver|Equal2~32_combout\ & !\regs|receiver|rcounter16\(2)) # !\regs|receiver|rcounter16[3]~435_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001101111011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal2~32_combout\,
	datab => \regs|receiver|rcounter16[3]~435_combout\,
	datac => \regs|receiver|rcounter16\(3),
	datad => \regs|receiver|rcounter16\(2),
	combout => \regs|receiver|Mux7~52_combout\);

\regs|receiver|rcounter16[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Mux7~52_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rcounter16[3]~433_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rcounter16\(3));

\regs|receiver|Equal2~31\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Equal2~31_combout\ = \regs|receiver|rcounter16\(2) # \regs|receiver|rcounter16\(3) # \regs|receiver|rcounter16\(1) # \regs|receiver|rcounter16\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rcounter16\(2),
	datab => \regs|receiver|rcounter16\(3),
	datac => \regs|receiver|rcounter16\(1),
	datad => \regs|receiver|rcounter16\(0),
	combout => \regs|receiver|Equal2~31_combout\);

\regs|receiver|Decoder1~146\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Decoder1~146_combout\ = \regs|receiver|rstate\(3) & !\regs|receiver|rstate\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(3),
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Decoder1~146_combout\);

\regs|receiver|Mux4~1010\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux4~1010_combout\ = \regs|receiver|rstate\(1) & !\regs|receiver|Equal2~31_combout\ # !\regs|receiver|rstate\(1) & (\regs|receiver|Equal1~59_combout\ & !\regs|serial_in~34_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100010001110100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal2~31_combout\,
	datab => \regs|receiver|rstate\(1),
	datac => \regs|receiver|Equal1~59_combout\,
	datad => \regs|serial_in~34_combout\,
	combout => \regs|receiver|Mux4~1010_combout\);

\regs|receiver|Mux4~1011\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux4~1011_combout\ = !\regs|receiver|rstate\(3) & \regs|receiver|Mux4~1010_combout\ & (\regs|receiver|rstate\(1) $ \regs|receiver|rstate\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(3),
	datab => \regs|receiver|rstate\(1),
	datac => \regs|receiver|rstate\(0),
	datad => \regs|receiver|Mux4~1010_combout\,
	combout => \regs|receiver|Mux4~1011_combout\);

\regs|receiver|Mux4~1012\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux4~1012_combout\ = \regs|receiver|Mux4~1011_combout\ # \regs|receiver|Decoder1~146_combout\ & (!\regs|receiver|Equal2~31_combout\ # !\regs|receiver|rstate\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111101110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(0),
	datab => \regs|receiver|Equal2~31_combout\,
	datac => \regs|receiver|Decoder1~146_combout\,
	datad => \regs|receiver|Mux4~1011_combout\,
	combout => \regs|receiver|Mux4~1012_combout\);

\regs|receiver|Mux4~1015\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux4~1015_combout\ = \regs|receiver|rstate\(2) & !\regs|receiver|rstate\(3) & \regs|receiver|Mux4~1014_combout\ # !\regs|receiver|rstate\(2) & (\regs|receiver|Mux4~1012_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100111101000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(3),
	datab => \regs|receiver|Mux4~1014_combout\,
	datac => \regs|receiver|rstate\(2),
	datad => \regs|receiver|Mux4~1012_combout\,
	combout => \regs|receiver|Mux4~1015_combout\);

\regs|receiver|rstate[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Mux4~1015_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|enable~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rstate\(2));

\regs|receiver|Mux6~741\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux6~741_combout\ = \regs|receiver|rstate\(3) & !\regs|receiver|rstate\(1) & (\regs|receiver|Equal2~31_combout\ # !\regs|receiver|rstate\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(3),
	datab => \regs|receiver|rstate\(0),
	datac => \regs|receiver|Equal2~31_combout\,
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Mux6~741_combout\);

\regs|receiver|Mux6~734\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux6~734_combout\ = \regs|receiver|rstate\(2) & !\regs|receiver|rstate\(3) & \regs|receiver|rstate\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(2),
	datab => \regs|receiver|rstate\(3),
	datac => \regs|receiver|rstate\(0),
	combout => \regs|receiver|Mux6~734_combout\);

\regs|receiver|Mux6~735\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux6~735_combout\ = \regs|receiver|Mux6~734_combout\ & (\regs|lcr\(3) & \regs|receiver|Equal3~33_combout\ # !\regs|receiver|rstate\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011000000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(3),
	datab => \regs|receiver|rstate\(1),
	datac => \regs|receiver|Mux6~734_combout\,
	datad => \regs|receiver|Equal3~33_combout\,
	combout => \regs|receiver|Mux6~735_combout\);

\regs|receiver|Mux6~740\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux6~740_combout\ = \regs|receiver|Mux6~735_combout\ # !\regs|receiver|rstate\(2) & (\regs|receiver|Mux6~739_combout\ # \regs|receiver|Mux6~741_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100110010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Mux6~739_combout\,
	datab => \regs|receiver|rstate\(2),
	datac => \regs|receiver|Mux6~741_combout\,
	datad => \regs|receiver|Mux6~735_combout\,
	combout => \regs|receiver|Mux6~740_combout\);

\regs|receiver|rstate[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Mux6~740_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|enable~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rstate\(0));

\regs|receiver|Mux5~714\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux5~714_combout\ = !\regs|receiver|rstate\(1) & !\regs|receiver|rstate\(3) & (\regs|receiver|rstate\(0) $ \regs|receiver|rstate\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(1),
	datab => \regs|receiver|rstate\(0),
	datac => \regs|receiver|rstate\(2),
	datad => \regs|receiver|rstate\(3),
	combout => \regs|receiver|Mux5~714_combout\);

\regs|receiver|rshift[7]~1505\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift[7]~1505_combout\ = \regs|serial_in~34_combout\ & !\regs|receiver|rstate\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|serial_in~34_combout\,
	datac => \regs|receiver|rstate\(2),
	combout => \regs|receiver|rshift[7]~1505_combout\);

\regs|receiver|Mux5~715\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux5~715_combout\ = \regs|receiver|Mux5~713_combout\ # \regs|receiver|Mux5~714_combout\ & !\regs|receiver|rshift[7]~1505_combout\ & \regs|receiver|Equal1~59_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Mux5~713_combout\,
	datab => \regs|receiver|Mux5~714_combout\,
	datac => \regs|receiver|rshift[7]~1505_combout\,
	datad => \regs|receiver|Equal1~59_combout\,
	combout => \regs|receiver|Mux5~715_combout\);

\regs|receiver|rstate[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Mux5~715_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|enable~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rstate\(1));

\regs|receiver|Selector7~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector7~42_combout\ = \regs|receiver|rshift\(0) & \regs|receiver|rstate\(1) & (!\regs|receiver|Equal0~133_combout\ # !\regs|receiver|Equal0~134_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rshift\(0),
	datab => \regs|receiver|Equal0~134_combout\,
	datac => \regs|receiver|Equal0~133_combout\,
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Selector7~42_combout\);

\regs|receiver|Decoder1~147\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Decoder1~147_combout\ = \regs|enable~regout\ & !\regs|receiver|rstate\(2) & !\regs|receiver|rstate\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|enable~regout\,
	datab => \regs|receiver|rstate\(2),
	datac => \regs|receiver|rstate\(0),
	combout => \regs|receiver|Decoder1~147_combout\);

\regs|receiver|rf_data_in[3]~631\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rf_data_in[3]~631_combout\ = \regs|receiver|Decoder1~147_combout\ & (\regs|receiver|rstate\(1) & !\regs|receiver|rf_push~197_combout\ & \regs|receiver|rstate\(3) # !\regs|receiver|rstate\(1) & (!\regs|receiver|rstate\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rf_push~197_combout\,
	datab => \regs|receiver|rstate\(1),
	datac => \regs|receiver|Decoder1~147_combout\,
	datad => \regs|receiver|rstate\(3),
	combout => \regs|receiver|rf_data_in[3]~631_combout\);

\regs|receiver|rf_data_in[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector7~42_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rf_data_in[3]~631_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_data_in\(3));

\regs|rx_reset~30\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rx_reset~30_combout\ = \wb_interface|Mux38~26_combout\ & \regs|always6~11_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|Mux38~26_combout\,
	datad => \regs|always6~11_combout\,
	combout => \regs|rx_reset~30_combout\);

\regs|rx_reset\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|rx_reset~30_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|rx_reset~regout\);

\regs|receiver|fifo_rx|top~115\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|top~115_combout\ = !\regs|receiver|fifo_rx|top\(0) & !\regs|rx_reset~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|receiver|fifo_rx|top\(0),
	datad => \regs|rx_reset~regout\,
	combout => \regs|receiver|fifo_rx|top~115_combout\);

\regs|receiver|rf_push~197\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rf_push~197_combout\ = \regs|receiver|rframing_error~regout\ & !\regs|serial_in~34_combout\ & (!\regs|receiver|Equal0~133_combout\ # !\regs|receiver|Equal0~134_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rframing_error~regout\,
	datab => \regs|receiver|Equal0~134_combout\,
	datac => \regs|receiver|Equal0~133_combout\,
	datad => \regs|serial_in~34_combout\,
	combout => \regs|receiver|rf_push~197_combout\);

\regs|receiver|Selector11~34\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector11~34_combout\ = \regs|receiver|rstate\(2) # \regs|receiver|rstate\(1) & (\regs|receiver|rstate\(0) # !\regs|receiver|rstate\(3)) # !\regs|receiver|rstate\(1) & (\regs|receiver|rstate\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110111111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(1),
	datab => \regs|receiver|rstate\(0),
	datac => \regs|receiver|rstate\(2),
	datad => \regs|receiver|rstate\(3),
	combout => \regs|receiver|Selector11~34_combout\);

\regs|receiver|rf_push~198\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rf_push~198_combout\ = !\regs|receiver|Selector11~34_combout\ & \regs|enable~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|Selector11~34_combout\,
	datac => \regs|enable~regout\,
	combout => \regs|receiver|rf_push~198_combout\);

\regs|receiver|rf_push~199\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rf_push~199_combout\ = \regs|receiver|rf_push~198_combout\ & \regs|receiver|Selector11~33_combout\ & (\regs|receiver|rf_push~regout\ # !\regs|receiver|rf_push~197_combout\) # !\regs|receiver|rf_push~198_combout\ & 
-- (\regs|receiver|rf_push~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010001011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Selector11~33_combout\,
	datab => \regs|receiver|rf_push~197_combout\,
	datac => \regs|receiver|rf_push~regout\,
	datad => \regs|receiver|rf_push~198_combout\,
	combout => \regs|receiver|rf_push~199_combout\);

\regs|receiver|rf_push\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rf_push~199_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_push~regout\);

\regs|receiver|rf_push_q\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_push~regout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_push_q~regout\);

\regs|receiver|rf_push_pulse\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rf_push_pulse~combout\ = \regs|receiver|rf_push~regout\ & !\regs|receiver|rf_push_q~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rf_push~regout\,
	datac => \regs|receiver|rf_push_q~regout\,
	combout => \regs|receiver|rf_push_pulse~combout\);

\wb_interface|wb_ack_o~4\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_ack_o~4_combout\ = \wb_interface|wb_cyc_is~regout\ & !\wb_interface|wbstate.00~regout\ & \wb_interface|wb_stb_is~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_cyc_is~regout\,
	datac => \wb_interface|wbstate.00~regout\,
	datad => \wb_interface|wb_stb_is~regout\,
	combout => \wb_interface|wb_ack_o~4_combout\);

\wb_interface|wb_ack_o\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wb_ack_o~4_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_ack_o~regout\);

\wb_interface|wbstate.10~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wbstate.10~feeder_combout\ = \wb_interface|wb_ack_o~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \wb_interface|wb_ack_o~regout\,
	combout => \wb_interface|wbstate.10~feeder_combout\);

\wb_interface|wbstate.10\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wbstate.10~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wbstate.10~regout\);

\wb_interface|Selector0~32\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Selector0~32_combout\ = !\wb_interface|wbstate.10~regout\ & (\wb_interface|wbstate.00~regout\ # \wb_interface|wb_cyc_is~regout\ & \wb_interface|wb_stb_is~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_cyc_is~regout\,
	datab => \wb_interface|wbstate.10~regout\,
	datac => \wb_interface|wbstate.00~regout\,
	datad => \wb_interface|wb_stb_is~regout\,
	combout => \wb_interface|Selector0~32_combout\);

\wb_interface|wbstate.00\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Selector0~32_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wbstate.00~regout\);

\wb_interface|wre~25\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wre~25_combout\ = \wb_interface|wbstate.00~regout\ # \wb_interface|wb_cyc_is~regout\ & \wb_interface|wb_stb_is~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_cyc_is~regout\,
	datac => \wb_interface|wbstate.00~regout\,
	datad => \wb_interface|wb_stb_is~regout\,
	combout => \wb_interface|wre~25_combout\);

\wb_interface|wre\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|wre~25_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wre~regout\);

\wb_interface|re_o\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|re_o~combout\ = !\wb_interface|wb_we_is~regout\ & !\wb_interface|wre~regout\ & \wb_interface|wb_cyc_is~regout\ & \wb_interface|wb_stb_is~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_we_is~regout\,
	datab => \wb_interface|wre~regout\,
	datac => \wb_interface|wb_cyc_is~regout\,
	datad => \wb_interface|wb_stb_is~regout\,
	combout => \wb_interface|re_o~combout\);

\regs|lsr_mask_condition~36\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr_mask_condition~36_combout\ = !\wb_interface|wb_adr_is\(4) & !\wb_interface|wb_adr_is\(3) & !\regs|lcr\(7) & \wb_interface|re_o~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_is\(4),
	datab => \wb_interface|wb_adr_is\(3),
	datac => \regs|lcr\(7),
	datad => \wb_interface|re_o~combout\,
	combout => \regs|lsr_mask_condition~36_combout\);

\regs|fifo_read\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|fifo_read~combout\ = \wb_interface|wb_adr_int[1]~63_combout\ # \wb_interface|wb_adr_is\(2) # \wb_interface|wb_adr_int[0]~64_combout\ # !\regs|lsr_mask_condition~36_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_int[1]~63_combout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|lsr_mask_condition~36_combout\,
	datad => \wb_interface|wb_adr_int[0]~64_combout\,
	combout => \regs|fifo_read~combout\);

\regs|rf_pop~49\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rf_pop~49_combout\ = \regs|rf_pop~regout\ # !\regs|fifo_read~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|rf_pop~regout\,
	datad => \regs|fifo_read~combout\,
	combout => \regs|rf_pop~49_combout\);

\regs|rf_pop\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|rf_pop~49_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|rf_pop~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|rf_pop~regout\);

\regs|receiver|fifo_rx|count[0]~310\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|count[0]~310_combout\ = \regs|receiver|fifo_rx|overrun~58_combout\ & \regs|receiver|fifo_rx|count\(0) & VCC # !\regs|receiver|fifo_rx|overrun~58_combout\ & (\regs|receiver|fifo_rx|count\(0) $ VCC)
-- \regs|receiver|fifo_rx|count[0]~311\ = CARRY(!\regs|receiver|fifo_rx|overrun~58_combout\ & \regs|receiver|fifo_rx|count\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001100101000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|overrun~58_combout\,
	datab => \regs|receiver|fifo_rx|count\(0),
	datad => VCC,
	combout => \regs|receiver|fifo_rx|count[0]~310_combout\,
	cout => \regs|receiver|fifo_rx|count[0]~311\);

\regs|receiver|fifo_rx|count[2]~315\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|count[2]~315_combout\ = (\regs|receiver|fifo_rx|count\(2) $ \regs|rf_pop~regout\ $ !\regs|receiver|fifo_rx|count[1]~314\) # GND
-- \regs|receiver|fifo_rx|count[2]~316\ = CARRY(\regs|receiver|fifo_rx|count\(2) & (\regs|rf_pop~regout\ # !\regs|receiver|fifo_rx|count[1]~314\) # !\regs|receiver|fifo_rx|count\(2) & \regs|rf_pop~regout\ & !\regs|receiver|fifo_rx|count[1]~314\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100110001110",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(2),
	datab => \regs|rf_pop~regout\,
	datad => VCC,
	cin => \regs|receiver|fifo_rx|count[1]~314\,
	combout => \regs|receiver|fifo_rx|count[2]~315_combout\,
	cout => \regs|receiver|fifo_rx|count[2]~316\);

\regs|receiver|fifo_rx|count[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|count[2]~315_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|rx_reset~regout\,
	ena => \regs|receiver|fifo_rx|count[3]~312_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|count\(2));

\regs|receiver|fifo_rx|count[1]~313\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|count[1]~313_combout\ = \regs|receiver|fifo_rx|count\(1) & (\regs|rf_pop~regout\ & \regs|receiver|fifo_rx|count[0]~311\ & VCC # !\regs|rf_pop~regout\ & !\regs|receiver|fifo_rx|count[0]~311\) # !\regs|receiver|fifo_rx|count\(1) & 
-- (\regs|rf_pop~regout\ & !\regs|receiver|fifo_rx|count[0]~311\ # !\regs|rf_pop~regout\ & (\regs|receiver|fifo_rx|count[0]~311\ # GND))
-- \regs|receiver|fifo_rx|count[1]~314\ = CARRY(\regs|receiver|fifo_rx|count\(1) & !\regs|rf_pop~regout\ & !\regs|receiver|fifo_rx|count[0]~311\ # !\regs|receiver|fifo_rx|count\(1) & (!\regs|receiver|fifo_rx|count[0]~311\ # !\regs|rf_pop~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(1),
	datab => \regs|rf_pop~regout\,
	datad => VCC,
	cin => \regs|receiver|fifo_rx|count[0]~311\,
	combout => \regs|receiver|fifo_rx|count[1]~313_combout\,
	cout => \regs|receiver|fifo_rx|count[1]~314\);

\regs|receiver|fifo_rx|count[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|count[1]~313_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|rx_reset~regout\,
	ena => \regs|receiver|fifo_rx|count[3]~312_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|count\(1));

\regs|lsr0r~131\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr0r~131_combout\ = !\regs|receiver|fifo_rx|count\(3) & !\regs|receiver|fifo_rx|count\(2) & !\regs|receiver|fifo_rx|count\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(3),
	datac => \regs|receiver|fifo_rx|count\(2),
	datad => \regs|receiver|fifo_rx|count\(1),
	combout => \regs|lsr0r~131_combout\);

\regs|lsr0~14\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr0~14_combout\ = !\regs|receiver|fifo_rx|count\(4) & \regs|lsr0r~131_combout\ & !\regs|receiver|fifo_rx|count\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datac => \regs|lsr0r~131_combout\,
	datad => \regs|receiver|fifo_rx|count\(0),
	combout => \regs|lsr0~14_combout\);

\regs|receiver|fifo_rx|count[3]~312\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|count[3]~312_combout\ = \regs|rx_reset~regout\ # \regs|rf_pop~regout\ & !\regs|receiver|rf_push_pulse~combout\ & !\regs|lsr0~14_combout\ # !\regs|rf_pop~regout\ & \regs|receiver|rf_push_pulse~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111101000110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|rf_pop~regout\,
	datab => \regs|receiver|rf_push_pulse~combout\,
	datac => \regs|lsr0~14_combout\,
	datad => \regs|rx_reset~regout\,
	combout => \regs|receiver|fifo_rx|count[3]~312_combout\);

\regs|receiver|fifo_rx|count[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|count[0]~310_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|rx_reset~regout\,
	ena => \regs|receiver|fifo_rx|count[3]~312_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|count\(0));

\regs|receiver|fifo_rx|count[3]~317\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|count[3]~317_combout\ = \regs|rf_pop~regout\ & (\regs|receiver|fifo_rx|count\(3) & \regs|receiver|fifo_rx|count[2]~316\ & VCC # !\regs|receiver|fifo_rx|count\(3) & !\regs|receiver|fifo_rx|count[2]~316\) # !\regs|rf_pop~regout\ & 
-- (\regs|receiver|fifo_rx|count\(3) & !\regs|receiver|fifo_rx|count[2]~316\ # !\regs|receiver|fifo_rx|count\(3) & (\regs|receiver|fifo_rx|count[2]~316\ # GND))
-- \regs|receiver|fifo_rx|count[3]~318\ = CARRY(\regs|rf_pop~regout\ & !\regs|receiver|fifo_rx|count\(3) & !\regs|receiver|fifo_rx|count[2]~316\ # !\regs|rf_pop~regout\ & (!\regs|receiver|fifo_rx|count[2]~316\ # !\regs|receiver|fifo_rx|count\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000010111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|rf_pop~regout\,
	datab => \regs|receiver|fifo_rx|count\(3),
	datad => VCC,
	cin => \regs|receiver|fifo_rx|count[2]~316\,
	combout => \regs|receiver|fifo_rx|count[3]~317_combout\,
	cout => \regs|receiver|fifo_rx|count[3]~318\);

\regs|receiver|fifo_rx|count[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|count[3]~317_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|rx_reset~regout\,
	ena => \regs|receiver|fifo_rx|count[3]~312_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|count\(3));

\regs|receiver|fifo_rx|count[4]~319\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|count[4]~319_combout\ = \regs|rf_pop~regout\ $ \regs|receiver|fifo_rx|count[3]~318\ $ !\regs|receiver|fifo_rx|count\(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|rf_pop~regout\,
	datad => \regs|receiver|fifo_rx|count\(4),
	cin => \regs|receiver|fifo_rx|count[3]~318\,
	combout => \regs|receiver|fifo_rx|count[4]~319_combout\);

\regs|receiver|fifo_rx|count[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|count[4]~319_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|rx_reset~regout\,
	ena => \regs|receiver|fifo_rx|count[3]~312_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|count\(4));

\regs|receiver|fifo_rx|top[3]~116\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|top[3]~116_combout\ = \regs|rx_reset~regout\ # \regs|receiver|rf_push_pulse~combout\ & (\regs|rf_pop~regout\ # !\regs|receiver|fifo_rx|count\(4))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|rf_pop~regout\,
	datab => \regs|receiver|rf_push_pulse~combout\,
	datac => \regs|receiver|fifo_rx|count\(4),
	datad => \regs|rx_reset~regout\,
	combout => \regs|receiver|fifo_rx|top[3]~116_combout\);

\regs|receiver|fifo_rx|top[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|top~115_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|fifo_rx|top[3]~116_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|top\(0));

\regs|receiver|fifo_rx|Add0~104\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Add0~104_combout\ = \regs|receiver|fifo_rx|top\(0) $ \regs|receiver|fifo_rx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|fifo_rx|top\(0),
	datac => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Add0~104_combout\);

\regs|receiver|fifo_rx|top[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|Add0~104_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|rx_reset~regout\,
	ena => \regs|receiver|fifo_rx|top[3]~116_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|top\(1));

\regs|receiver|fifo_rx|Add0~103\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Add0~103_combout\ = \regs|receiver|fifo_rx|top\(3) $ (\regs|receiver|fifo_rx|top\(2) & \regs|receiver|fifo_rx|top\(0) & \regs|receiver|fifo_rx|top\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111100011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(2),
	datab => \regs|receiver|fifo_rx|top\(0),
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Add0~103_combout\);

\regs|receiver|fifo_rx|top[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|Add0~103_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|rx_reset~regout\,
	ena => \regs|receiver|fifo_rx|top[3]~116_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|top\(3));

\regs|receiver|fifo_rx|rfifo|ram~144\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|rfifo|ram~144_combout\ = !\regs|receiver|fifo_rx|top\(3) & !\regs|receiver|fifo_rx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|rfifo|ram~144_combout\);

\regs|receiver|fifo_rx|Add0~105\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Add0~105_combout\ = \regs|receiver|fifo_rx|top\(2) $ (\regs|receiver|fifo_rx|top\(0) & \regs|receiver|fifo_rx|top\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|fifo_rx|top\(0),
	datac => \regs|receiver|fifo_rx|top\(2),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Add0~105_combout\);

\regs|receiver|fifo_rx|top[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|Add0~105_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|rx_reset~regout\,
	ena => \regs|receiver|fifo_rx|top[3]~116_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|top\(2));

\regs|receiver|fifo_rx|rfifo|ram~145\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|rfifo|ram~145_combout\ = \regs|receiver|rf_push_pulse~combout\ & \regs|receiver|fifo_rx|rfifo|ram~144_combout\ & !\regs|receiver|fifo_rx|top\(2) & !\regs|receiver|fifo_rx|top\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rf_push_pulse~combout\,
	datab => \regs|receiver|fifo_rx|rfifo|ram~144_combout\,
	datac => \regs|receiver|fifo_rx|top\(2),
	datad => \regs|receiver|fifo_rx|top\(0),
	combout => \regs|receiver|fifo_rx|rfifo|ram~145_combout\);

\regs|receiver|fifo_rx|rfifo|ram~16\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(3),
	sload => VCC,
	ena => \regs|receiver|fifo_rx|rfifo|ram~145_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram~16_regout\);

\regs|receiver|fifo_rx|rfifo|ram~15feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|rfifo|ram~15feeder_combout\ = VCC

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	combout => \regs|receiver|fifo_rx|rfifo|ram~15feeder_combout\);

\regs|receiver|fifo_rx|rfifo|ram~15\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|rfifo|ram~15feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram~15_regout\);

\regs|Mux7~337\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~337_combout\ = \regs|receiver|fifo_rx|rfifo|ram~16_regout\ # \regs|receiver|fifo_rx|rfifo|ram~15_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|receiver|fifo_rx|rfifo|ram~16_regout\,
	datad => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	combout => \regs|Mux7~337_combout\);

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(3),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(9));

\regs|Mux7~338\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~338_combout\ = \regs|Mux7~335_combout\ & (\regs|Mux7~337_combout\ # \regs|lcr\(7)) # !\regs|Mux7~335_combout\ & (\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(9) & !\regs|lcr\(7))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~335_combout\,
	datab => \regs|Mux7~337_combout\,
	datac => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(9),
	datad => \regs|lcr\(7),
	combout => \regs|Mux7~338_combout\);

\regs|dl[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux39~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[0]~298_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(0));

\regs|receiver|fifo_rx|bottom[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|bottom~848_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|bottom\(0));

\regs|receiver|fifo_rx|bottom~848\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|bottom~848_combout\ = !\regs|rx_reset~regout\ & (\regs|receiver|fifo_rx|bottom~850_combout\ $ !\regs|receiver|fifo_rx|bottom\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010100101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom~850_combout\,
	datac => \regs|receiver|fifo_rx|bottom\(0),
	datad => \regs|rx_reset~regout\,
	combout => \regs|receiver|fifo_rx|bottom~848_combout\);

\regs|receiver|fifo_rx|bottom[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|bottom~847_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|bottom\(1));

\regs|receiver|fifo_rx|bottom~847\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|bottom~847_combout\ = !\regs|rx_reset~regout\ & (\regs|receiver|fifo_rx|bottom\(1) $ (!\regs|receiver|fifo_rx|bottom~850_combout\ & \regs|receiver|fifo_rx|bottom\(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom~850_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|receiver|fifo_rx|bottom\(1),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|receiver|fifo_rx|bottom~847_combout\);

\regs|receiver|fifo_rx|bottom[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|bottom~849_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|bottom\(2));

\regs|receiver|fifo_rx|Add3~104\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Add3~104_combout\ = \regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|fifo_rx|bottom\(1),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|receiver|fifo_rx|Add3~104_combout\);

\regs|receiver|fifo_rx|bottom~849\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|bottom~849_combout\ = !\regs|rx_reset~regout\ & (\regs|receiver|fifo_rx|bottom\(2) $ (!\regs|receiver|fifo_rx|bottom~850_combout\ & \regs|receiver|fifo_rx|Add3~104_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom~850_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|Add3~104_combout\,
	combout => \regs|receiver|fifo_rx|bottom~849_combout\);

\regs|receiver|fifo_rx|bottom[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|bottom~846_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|bottom\(3));

\regs|receiver|fifo_rx|Add3~103\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Add3~103_combout\ = \regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(0) & \regs|receiver|fifo_rx|bottom\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|fifo_rx|bottom\(1),
	datac => \regs|receiver|fifo_rx|bottom\(0),
	datad => \regs|receiver|fifo_rx|bottom\(2),
	combout => \regs|receiver|fifo_rx|Add3~103_combout\);

\regs|receiver|fifo_rx|bottom~846\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|bottom~846_combout\ = !\regs|rx_reset~regout\ & (\regs|receiver|fifo_rx|bottom\(3) $ (!\regs|receiver|fifo_rx|bottom~850_combout\ & \regs|receiver|fifo_rx|Add3~103_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom~850_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|receiver|fifo_rx|bottom\(3),
	datad => \regs|receiver|fifo_rx|Add3~103_combout\,
	combout => \regs|receiver|fifo_rx|bottom~846_combout\);

\regs|receiver|rshift[6]~1506\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift[6]~1506_combout\ = \regs|receiver|rstate\(1) & !\regs|receiver|rstate\(0) & \regs|enable~regout\ & !\regs|receiver|rstate\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(1),
	datab => \regs|receiver|rstate\(0),
	datac => \regs|enable~regout\,
	datad => \regs|receiver|rstate\(3),
	combout => \regs|receiver|rshift[6]~1506_combout\);

\regs|receiver|rshift~1514\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift~1514_combout\ = !\regs|lcr\(1) & !\regs|lcr\(0) & \regs|receiver|Equal1~59_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|lcr\(1),
	datac => \regs|lcr\(0),
	datad => \regs|receiver|Equal1~59_combout\,
	combout => \regs|receiver|rshift~1514_combout\);

\regs|receiver|rshift[7]~1515\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift[7]~1515_combout\ = \regs|receiver|rshift\(7) & (\regs|receiver|rstate\(2) & \regs|receiver|Equal2~31_combout\ # !\regs|receiver|rstate\(2) & (!\regs|receiver|rshift~1514_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000011000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(2),
	datab => \regs|receiver|rshift\(7),
	datac => \regs|receiver|Equal2~31_combout\,
	datad => \regs|receiver|rshift~1514_combout\,
	combout => \regs|receiver|rshift[7]~1515_combout\);

\regs|receiver|rshift[7]~1516\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift[7]~1516_combout\ = \regs|receiver|rshift[7]~1515_combout\ # \regs|receiver|rshift[6]~1506_combout\ & \regs|receiver|rshift~1514_combout\ & \regs|receiver|rshift[7]~1505_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rshift[6]~1506_combout\,
	datab => \regs|receiver|rshift~1514_combout\,
	datac => \regs|receiver|rshift[7]~1515_combout\,
	datad => \regs|receiver|rshift[7]~1505_combout\,
	combout => \regs|receiver|rshift[7]~1516_combout\);

\regs|receiver|rshift[7]~1517\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift[7]~1517_combout\ = \regs|receiver|rshift[6]~1509_combout\ & (\regs|receiver|rshift[7]~1516_combout\ # !\regs|receiver|rshift[6]~1506_combout\ & \regs|receiver|rshift\(7)) # !\regs|receiver|rshift[6]~1509_combout\ & 
-- !\regs|receiver|rshift[6]~1506_combout\ & \regs|receiver|rshift\(7)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rshift[6]~1509_combout\,
	datab => \regs|receiver|rshift[6]~1506_combout\,
	datac => \regs|receiver|rshift\(7),
	datad => \regs|receiver|rshift[7]~1516_combout\,
	combout => \regs|receiver|rshift[7]~1517_combout\);

\regs|receiver|rshift[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rshift[7]~1517_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rshift\(7));

\regs|receiver|rshift[6]~1510\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift[6]~1510_combout\ = \regs|lcr\(0) & \regs|serial_in~34_combout\ # !\regs|lcr\(0) & (\regs|receiver|rshift\(7))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|lcr\(0),
	datac => \regs|serial_in~34_combout\,
	datad => \regs|receiver|rshift\(7),
	combout => \regs|receiver|rshift[6]~1510_combout\);

\regs|receiver|rshift[6]~1511\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift[6]~1511_combout\ = \regs|receiver|rstate\(2) & (\regs|receiver|Equal2~31_combout\) # !\regs|receiver|rstate\(2) & !\regs|lcr\(1) & (\regs|receiver|Equal1~59_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011000110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(2),
	datab => \regs|lcr\(1),
	datac => \regs|receiver|Equal2~31_combout\,
	datad => \regs|receiver|Equal1~59_combout\,
	combout => \regs|receiver|rshift[6]~1511_combout\);

\regs|receiver|rshift[6]~1512\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift[6]~1512_combout\ = \regs|receiver|rstate\(2) & \regs|receiver|rshift\(6) & (!\regs|receiver|rshift[6]~1511_combout\) # !\regs|receiver|rstate\(2) & \regs|receiver|rshift[6]~1511_combout\ & (\regs|receiver|rshift\(6) $ 
-- \regs|receiver|rshift[6]~1510_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001010010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(2),
	datab => \regs|receiver|rshift\(6),
	datac => \regs|receiver|rshift[6]~1510_combout\,
	datad => \regs|receiver|rshift[6]~1511_combout\,
	combout => \regs|receiver|rshift[6]~1512_combout\);

\regs|receiver|rshift[6]~1513\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift[6]~1513_combout\ = \regs|receiver|rshift[6]~1506_combout\ & \regs|receiver|rshift[6]~1509_combout\ & (\regs|receiver|rshift\(6) $ \regs|receiver|rshift[6]~1512_combout\) # !\regs|receiver|rshift[6]~1506_combout\ & 
-- (\regs|receiver|rshift\(6))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011100010110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rshift[6]~1509_combout\,
	datab => \regs|receiver|rshift[6]~1506_combout\,
	datac => \regs|receiver|rshift\(6),
	datad => \regs|receiver|rshift[6]~1512_combout\,
	combout => \regs|receiver|rshift[6]~1513_combout\);

\regs|receiver|rshift[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rshift[6]~1513_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rshift\(6));

\regs|receiver|Mux1~213\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux1~213_combout\ = \regs|lcr\(0) & \regs|receiver|rshift\(5) # !\regs|lcr\(0) & (\regs|serial_in~34_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|lcr\(0),
	datac => \regs|receiver|rshift\(5),
	datad => \regs|serial_in~34_combout\,
	combout => \regs|receiver|Mux1~213_combout\);

\regs|receiver|Mux1~214\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Mux1~214_combout\ = \regs|lcr\(1) & (\regs|receiver|Mux1~213_combout\) # !\regs|lcr\(1) & \regs|receiver|rshift\(6)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rshift\(6),
	datac => \regs|receiver|Mux1~213_combout\,
	datad => \regs|lcr\(1),
	combout => \regs|receiver|Mux1~214_combout\);

\regs|receiver|rshift[0]~1507\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift[0]~1507_combout\ = \regs|receiver|rshift[6]~1506_combout\ & (\regs|receiver|rstate\(2) & (!\regs|receiver|Equal2~31_combout\) # !\regs|receiver|rstate\(2) & \regs|receiver|Equal1~59_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010111000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal1~59_combout\,
	datab => \regs|receiver|rstate\(2),
	datac => \regs|receiver|Equal2~31_combout\,
	datad => \regs|receiver|rshift[6]~1506_combout\,
	combout => \regs|receiver|rshift[0]~1507_combout\);

\regs|receiver|rshift[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Mux1~214_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|receiver|rstate\(2),
	ena => \regs|receiver|rshift[0]~1507_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rshift\(5));

\regs|receiver|rshift~1508\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rshift~1508_combout\ = \regs|lcr\(0) & (\regs|lcr\(1) & \regs|serial_in~34_combout\ # !\regs|lcr\(1) & (\regs|receiver|rshift\(5))) # !\regs|lcr\(0) & (\regs|receiver|rshift\(5))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010110011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|serial_in~34_combout\,
	datab => \regs|receiver|rshift\(5),
	datac => \regs|lcr\(0),
	datad => \regs|lcr\(1),
	combout => \regs|receiver|rshift~1508_combout\);

\regs|receiver|rshift[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rshift~1508_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|receiver|rstate\(2),
	ena => \regs|receiver|rshift[0]~1507_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rshift\(4));

\regs|receiver|Selector20~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector20~15_combout\ = \regs|receiver|rshift\(4) & !\regs|receiver|rstate\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rshift\(4),
	datad => \regs|receiver|rstate\(2),
	combout => \regs|receiver|Selector20~15_combout\);

\regs|receiver|rshift[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector20~15_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rshift[0]~1507_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rshift\(3));

\regs|receiver|Selector21~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector21~15_combout\ = \regs|receiver|rshift\(3) & !\regs|receiver|rstate\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rshift\(3),
	datad => \regs|receiver|rstate\(2),
	combout => \regs|receiver|Selector21~15_combout\);

\regs|receiver|rshift[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector21~15_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rshift[0]~1507_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rshift\(2));

\regs|receiver|Selector22~15\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector22~15_combout\ = \regs|receiver|rshift\(2) & !\regs|receiver|rstate\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|receiver|rshift\(2),
	datad => \regs|receiver|rstate\(2),
	combout => \regs|receiver|Selector22~15_combout\);

\regs|receiver|rshift[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector22~15_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rshift[0]~1507_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rshift\(1));

\regs|receiver|Selector6~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector6~42_combout\ = \regs|receiver|rshift\(1) & \regs|receiver|rstate\(1) & (!\regs|receiver|Equal0~134_combout\ # !\regs|receiver|Equal0~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal0~133_combout\,
	datab => \regs|receiver|rshift\(1),
	datac => \regs|receiver|Equal0~134_combout\,
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Selector6~42_combout\);

\regs|receiver|rf_data_in[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector6~42_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rf_data_in[3]~631_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_data_in\(4));

\regs|receiver|Selector5~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector5~42_combout\ = \regs|receiver|rshift\(2) & \regs|receiver|rstate\(1) & (!\regs|receiver|Equal0~133_combout\ # !\regs|receiver|Equal0~134_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rshift\(2),
	datab => \regs|receiver|Equal0~134_combout\,
	datac => \regs|receiver|Equal0~133_combout\,
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Selector5~42_combout\);

\regs|receiver|rf_data_in[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector5~42_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rf_data_in[3]~631_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_data_in\(5));

\regs|receiver|Selector4~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector4~42_combout\ = \regs|receiver|rshift\(3) & \regs|receiver|rstate\(1) & (!\regs|receiver|Equal0~134_combout\ # !\regs|receiver|Equal0~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal0~133_combout\,
	datab => \regs|receiver|Equal0~134_combout\,
	datac => \regs|receiver|rshift\(3),
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Selector4~42_combout\);

\regs|receiver|rf_data_in[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector4~42_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rf_data_in[3]~631_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_data_in\(6));

\regs|receiver|Selector3~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector3~42_combout\ = \regs|receiver|rshift\(4) & \regs|receiver|rstate\(1) & (!\regs|receiver|Equal0~133_combout\ # !\regs|receiver|Equal0~134_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rshift\(4),
	datab => \regs|receiver|Equal0~134_combout\,
	datac => \regs|receiver|Equal0~133_combout\,
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Selector3~42_combout\);

\regs|receiver|rf_data_in[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector3~42_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rf_data_in[3]~631_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_data_in\(7));

\regs|receiver|Selector2~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector2~42_combout\ = \regs|receiver|rshift\(5) & \regs|receiver|rstate\(1) & (!\regs|receiver|Equal0~134_combout\ # !\regs|receiver|Equal0~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal0~133_combout\,
	datab => \regs|receiver|Equal0~134_combout\,
	datac => \regs|receiver|rshift\(5),
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Selector2~42_combout\);

\regs|receiver|rf_data_in[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector2~42_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rf_data_in[3]~631_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_data_in\(8));

\regs|receiver|Selector1~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector1~42_combout\ = \regs|receiver|rshift\(6) & \regs|receiver|rstate\(1) & (!\regs|receiver|Equal0~133_combout\ # !\regs|receiver|Equal0~134_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rshift\(6),
	datab => \regs|receiver|Equal0~134_combout\,
	datac => \regs|receiver|Equal0~133_combout\,
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Selector1~42_combout\);

\regs|receiver|rf_data_in[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector1~42_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rf_data_in[3]~631_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_data_in\(9));

\regs|receiver|Selector0~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector0~42_combout\ = \regs|receiver|rshift\(7) & \regs|receiver|rstate\(1) & (!\regs|receiver|Equal0~134_combout\ # !\regs|receiver|Equal0~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Equal0~133_combout\,
	datab => \regs|receiver|Equal0~134_combout\,
	datac => \regs|receiver|rshift\(7),
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Selector0~42_combout\);

\regs|receiver|rf_data_in[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector0~42_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rf_data_in[3]~631_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_data_in\(10));

\regs|Mux7~339\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~339_combout\ = \regs|Mux7~336_combout\ & (\regs|Mux7~338_combout\ & (\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(0)) # !\regs|Mux7~338_combout\ & \regs|dl\(0)) # !\regs|Mux7~336_combout\ & \regs|Mux7~338_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~336_combout\,
	datab => \regs|Mux7~338_combout\,
	datac => \regs|dl\(0),
	datad => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(0),
	combout => \regs|Mux7~339_combout\);

\regs|Mux7~346\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~346_combout\ = \regs|Mux7~344_combout\ & (\regs|Mux7~345_combout\ & \regs|Mux7~343_combout\ # !\regs|Mux7~345_combout\ & (\regs|Mux7~339_combout\)) # !\regs|Mux7~344_combout\ & (\regs|Mux7~345_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011110010110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~343_combout\,
	datab => \regs|Mux7~344_combout\,
	datac => \regs|Mux7~345_combout\,
	datad => \regs|Mux7~339_combout\,
	combout => \regs|Mux7~346_combout\);

\regs|Mux7~347\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~347_combout\ = \regs|msr_read~19_combout\ & (\regs|Mux7~346_combout\ & (\regs|msr\(0)) # !\regs|Mux7~346_combout\ & !\regs|iir\(0)) # !\regs|msr_read~19_combout\ & (\regs|Mux7~346_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111101010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|iir\(0),
	datab => \regs|msr\(0),
	datac => \regs|msr_read~19_combout\,
	datad => \regs|Mux7~346_combout\,
	combout => \regs|Mux7~347_combout\);

\regs|Mux7~348\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~348_combout\ = \regs|always4~27_combout\ & (\wb_interface|wb_adr_is\(2) & \regs|scratch\(0) # !\wb_interface|wb_adr_is\(2) & (\regs|Mux7~347_combout\)) # !\regs|always4~27_combout\ & (\regs|Mux7~347_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111011110000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|always4~27_combout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|scratch\(0),
	datad => \regs|Mux7~347_combout\,
	combout => \regs|Mux7~348_combout\);

\wb_interface|wb_dat_o[2]~538\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_o[2]~538_combout\ = \wb_interface|wb_sel_is\(2) & (!\wb_interface|wb_sel_is\(3) # !\wb_interface|wb_sel_is\(1)) # !\wb_interface|wb_sel_is\(2) & (\wb_interface|wb_sel_is\(1) # \wb_interface|wb_sel_is\(3)) # 
-- !\wb_interface|wb_sel_is\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111111111101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_sel_is\(2),
	datab => \wb_interface|wb_sel_is\(1),
	datac => \wb_interface|wb_sel_is\(0),
	datad => \wb_interface|wb_sel_is\(3),
	combout => \wb_interface|wb_dat_o[2]~538_combout\);

\wb_interface|Mux31~219\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux31~219_combout\ = !\wb_interface|wb_sel_is\(1) & !\wb_interface|wb_adr_is\(3) & !\wb_interface|wb_dat_o[2]~538_combout\ & !\wb_interface|wb_adr_is\(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_sel_is\(1),
	datab => \wb_interface|wb_adr_is\(3),
	datac => \wb_interface|wb_dat_o[2]~538_combout\,
	datad => \wb_interface|wb_adr_is\(4),
	combout => \wb_interface|Mux31~219_combout\);

\wb_interface|Mux31~217\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux31~217_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux31~215_combout\ # \regs|Mux7~348_combout\ & \wb_interface|Mux31~219_combout\) # !\wb_interface|Mux31~216_combout\ & (\regs|Mux7~348_combout\ & 
-- \wb_interface|Mux31~219_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux31~215_combout\,
	datac => \regs|Mux7~348_combout\,
	datad => \wb_interface|Mux31~219_combout\,
	combout => \wb_interface|Mux31~217_combout\);

\wb_interface|wb_dat_o[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux31~217_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(0));

\regs|lsr_mask_condition~35\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr_mask_condition~35_combout\ = \wb_interface|re_o~combout\ & !\regs|lcr\(7) & \regs|always7~19_combout\ & \wb_interface|wb_adr_is\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|re_o~combout\,
	datab => \regs|lcr\(7),
	datac => \regs|always7~19_combout\,
	datad => \wb_interface|wb_adr_is\(2),
	combout => \regs|lsr_mask_condition~35_combout\);

\regs|lsr_mask\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr_mask~combout\ = \regs|lsr_mask_d~regout\ # \wb_interface|wb_adr_int[1]~63_combout\ # !\regs|lsr_mask_condition~35_combout\ # !\wb_interface|wb_adr_int[0]~64_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr_mask_d~regout\,
	datab => \wb_interface|wb_adr_int[0]~64_combout\,
	datac => \regs|lsr_mask_condition~35_combout\,
	datad => \wb_interface|wb_adr_int[1]~63_combout\,
	combout => \regs|lsr_mask~combout\);

\regs|receiver|fifo_rx|overrun~60\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|overrun~60_combout\ = !\regs|rx_reset~regout\ & \regs|lsr_mask~combout\ & (\regs|receiver|fifo_rx|overrun~59_combout\ # \regs|receiver|fifo_rx|overrun~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|overrun~59_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|receiver|fifo_rx|overrun~regout\,
	datad => \regs|lsr_mask~combout\,
	combout => \regs|receiver|fifo_rx|overrun~60_combout\);

\regs|receiver|fifo_rx|overrun\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|overrun~60_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|overrun~regout\);

\regs|lsr1_d~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr1_d~feeder_combout\ = \regs|receiver|fifo_rx|overrun~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \regs|receiver|fifo_rx|overrun~regout\,
	combout => \regs|lsr1_d~feeder_combout\);

\regs|lsr1_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr1_d~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr1_d~regout\);

\regs|lsr1r~34\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr1r~34_combout\ = \regs|lsr_mask~combout\ & (\regs|lsr1r~regout\ # \regs|receiver|fifo_rx|overrun~regout\ & !\regs|lsr1_d~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|overrun~regout\,
	datab => \regs|lsr1_d~regout\,
	datac => \regs|lsr1r~regout\,
	datad => \regs|lsr_mask~combout\,
	combout => \regs|lsr1r~34_combout\);

\regs|lsr1r\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr1r~34_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr1r~regout\);

\wb_interface|Mux30~199\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux30~199_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|transmitter|tstate\(1)) # !\wb_interface|wb_adr_is\(2) & \regs|lsr1r~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_is\(2),
	datab => \regs|lsr1r~regout\,
	datac => \regs|transmitter|tstate\(1),
	datad => \dbg|Equal0~38_combout\,
	combout => \wb_interface|Mux30~199_combout\);

\regs|scratch[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux38~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always8~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|scratch\(1));

\dsr_pad_i~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_dsr_pad_i,
	combout => \dsr_pad_i~combout\);

\regs|delayed_modem_signals[1]~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|delayed_modem_signals[1]~9_combout\ = !\dsr_pad_i~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \dsr_pad_i~combout\,
	combout => \regs|delayed_modem_signals[1]~9_combout\);

\regs|delayed_modem_signals[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|delayed_modem_signals[1]~9_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|delayed_modem_signals\(1));

\regs|msr~173\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|msr~173_combout\ = \regs|msi_reset~regout\ & (\regs|msr\(1) # \dsr_pad_i~combout\ $ !\regs|delayed_modem_signals\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100100011000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \dsr_pad_i~combout\,
	datab => \regs|msi_reset~regout\,
	datac => \regs|msr\(1),
	datad => \regs|delayed_modem_signals\(1),
	combout => \regs|msr~173_combout\);

\regs|msr[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|msr~173_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|msr\(1));

\regs|Mux7~341\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~341_combout\ = \wb_interface|wb_adr_int[1]~63_combout\ # \regs|lcr\(7) & !\wb_interface|wb_adr_is\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111011001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(7),
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \wb_interface|wb_adr_is\(2),
	combout => \regs|Mux7~341_combout\);

\regs|Mux6~101\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux6~101_combout\ = \regs|Mux6~100_combout\ & (!\regs|Mux7~341_combout\ # !\regs|lcr\(1)) # !\regs|Mux6~100_combout\ & (\regs|dl\(9) & \regs|Mux7~341_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111001010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux6~100_combout\,
	datab => \regs|lcr\(1),
	datac => \regs|dl\(9),
	datad => \regs|Mux7~341_combout\,
	combout => \regs|Mux6~101_combout\);

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|top\(0),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(1));

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|top\(2),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(5));

\regs|Mux7~334\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~334_combout\ = \regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(1) $ \regs|receiver|fifo_rx|bottom\(0) # !\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(5)) # !\regs|receiver|fifo_rx|bottom\(2) & 
-- (\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(5) # \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(1) $ \regs|receiver|fifo_rx|bottom\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111101111011110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(2),
	datab => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(1),
	datac => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(5),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|Mux7~334_combout\);

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_push_pulse~combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(0));

\regs|Mux7~335\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~335_combout\ = !\regs|lcr\(7) & (\regs|Mux7~333_combout\ # \regs|Mux7~334_combout\ # !\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~333_combout\,
	datab => \regs|Mux7~334_combout\,
	datac => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(0),
	datad => \regs|lcr\(7),
	combout => \regs|Mux7~335_combout\);

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(4),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(10));

\regs|Mux6~97\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux6~97_combout\ = \regs|lcr\(7) & \regs|dl\(1) # !\regs|lcr\(7) & (\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(10))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(1),
	datac => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(10),
	datad => \regs|lcr\(7),
	combout => \regs|Mux6~97_combout\);

\regs|Mux6~98\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux6~98_combout\ = \regs|Mux7~335_combout\ & (\regs|lcr\(7) # \regs|receiver|fifo_rx|rfifo|ram~15_regout\) # !\regs|Mux7~335_combout\ & (\regs|Mux6~97_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111111100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(7),
	datab => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	datac => \regs|Mux7~335_combout\,
	datad => \regs|Mux6~97_combout\,
	combout => \regs|Mux6~98_combout\);

\regs|receiver|fifo_rx|rfifo|ram~18\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(4),
	sload => VCC,
	ena => \regs|receiver|fifo_rx|rfifo|ram~145_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram~18_regout\);

\regs|Mux6~99\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux6~99_combout\ = \regs|Mux7~335_combout\ & (\regs|Mux6~98_combout\ & (\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(1)) # !\regs|Mux6~98_combout\ & \regs|receiver|fifo_rx|rfifo|ram~18_regout\) # !\regs|Mux7~335_combout\ & 
-- \regs|Mux6~98_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~335_combout\,
	datab => \regs|Mux6~98_combout\,
	datac => \regs|receiver|fifo_rx|rfifo|ram~18_regout\,
	datad => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(1),
	combout => \regs|Mux6~99_combout\);

\regs|Mux6~102\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux6~102_combout\ = \regs|Mux7~345_combout\ & (\regs|Mux6~101_combout\ # !\regs|Mux7~344_combout\) # !\regs|Mux7~345_combout\ & \regs|Mux7~344_combout\ & (\regs|Mux6~99_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110011010100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~345_combout\,
	datab => \regs|Mux7~344_combout\,
	datac => \regs|Mux6~101_combout\,
	datad => \regs|Mux6~99_combout\,
	combout => \regs|Mux6~102_combout\);

\regs|Mux6~103\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux6~103_combout\ = \regs|msr_read~19_combout\ & (\regs|Mux6~102_combout\ & (\regs|msr\(1)) # !\regs|Mux6~102_combout\ & \regs|iir\(1)) # !\regs|msr_read~19_combout\ & (\regs|Mux6~102_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|iir\(1),
	datab => \regs|msr\(1),
	datac => \regs|msr_read~19_combout\,
	datad => \regs|Mux6~102_combout\,
	combout => \regs|Mux6~103_combout\);

\regs|Mux6~104\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux6~104_combout\ = \regs|always4~27_combout\ & (\wb_interface|wb_adr_is\(2) & \regs|scratch\(1) # !\wb_interface|wb_adr_is\(2) & (\regs|Mux6~103_combout\)) # !\regs|always4~27_combout\ & (\regs|Mux6~103_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111011110000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|always4~27_combout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|scratch\(1),
	datad => \regs|Mux6~103_combout\,
	combout => \regs|Mux6~104_combout\);

\wb_interface|Mux30~200\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux30~200_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux30~199_combout\ # \wb_interface|Mux31~219_combout\ & \regs|Mux6~104_combout\) # !\wb_interface|Mux31~216_combout\ & (\wb_interface|Mux31~219_combout\ & 
-- \regs|Mux6~104_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux30~199_combout\,
	datac => \wb_interface|Mux31~219_combout\,
	datad => \regs|Mux6~104_combout\,
	combout => \wb_interface|Mux30~200_combout\);

\wb_interface|wb_dat_o[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux30~200_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(1));

\wb_interface|Mux29~199\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux29~199_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|transmitter|tstate\(2)) # !\wb_interface|wb_adr_is\(2) & \regs|lsr2r~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr2r~regout\,
	datab => \regs|transmitter|tstate\(2),
	datac => \dbg|Equal0~38_combout\,
	datad => \wb_interface|wb_adr_is\(2),
	combout => \wb_interface|Mux29~199_combout\);

\regs|ier[0]~62\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ier[0]~62_combout\ = !\regs|lcr\(7) & !\wb_interface|wb_adr_int[1]~63_combout\ & \regs|always4~29_combout\ & \wb_interface|wb_adr_int[0]~64_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(7),
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \regs|always4~29_combout\,
	datad => \wb_interface|wb_adr_int[0]~64_combout\,
	combout => \regs|ier[0]~62_combout\);

\regs|ier[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux39~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|ier[0]~62_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|ier\(0));

\regs|receiver|counter_t[0]~271\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_t[0]~271_combout\ = !\regs|receiver|counter_t\(0)
-- \regs|receiver|counter_t[0]~272\ = CARRY(!\regs|receiver|counter_t\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|counter_t\(0),
	combout => \regs|receiver|counter_t[0]~271_combout\,
	cout => \regs|receiver|counter_t[0]~272\);

\regs|receiver|always4~1\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|always4~1_combout\ = \regs|rf_pop~regout\ # \regs|lsr0~14_combout\ # \regs|receiver|rf_push~regout\ & !\regs|receiver|rf_push_q~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rf_push~regout\,
	datab => \regs|rf_pop~regout\,
	datac => \regs|receiver|rf_push_q~regout\,
	datad => \regs|lsr0~14_combout\,
	combout => \regs|receiver|always4~1_combout\);

\regs|receiver|counter_t[1]~273\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_t[1]~273_combout\ = \regs|receiver|always4~1_combout\ # !\regs|ti_int~101_combout\ & \regs|enable~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111101010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|ti_int~101_combout\,
	datac => \regs|enable~regout\,
	datad => \regs|receiver|always4~1_combout\,
	combout => \regs|receiver|counter_t[1]~273_combout\);

\regs|receiver|counter_t[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_t[0]~271_combout\,
	sdata => \~GND~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|receiver|always4~1_combout\,
	ena => \regs|receiver|counter_t[1]~273_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_t\(0));

\regs|receiver|counter_t[1]~274\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_t[1]~274_combout\ = \regs|receiver|counter_t\(1) & (\regs|receiver|counter_t[0]~272\ $ GND) # !\regs|receiver|counter_t\(1) & !\regs|receiver|counter_t[0]~272\ & VCC
-- \regs|receiver|counter_t[1]~275\ = CARRY(\regs|receiver|counter_t\(1) & !\regs|receiver|counter_t[0]~272\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|counter_t\(1),
	datad => VCC,
	cin => \regs|receiver|counter_t[0]~272\,
	combout => \regs|receiver|counter_t[1]~274_combout\,
	cout => \regs|receiver|counter_t[1]~275\);

\regs|receiver|counter_t[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_t[1]~274_combout\,
	sdata => \~GND~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|receiver|always4~1_combout\,
	ena => \regs|receiver|counter_t[1]~273_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_t\(1));

\regs|receiver|counter_t[2]~276\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_t[2]~276_combout\ = \regs|receiver|counter_t\(2) & !\regs|receiver|counter_t[1]~275\ # !\regs|receiver|counter_t\(2) & (\regs|receiver|counter_t[1]~275\ # GND)
-- \regs|receiver|counter_t[2]~277\ = CARRY(!\regs|receiver|counter_t[1]~275\ # !\regs|receiver|counter_t\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|counter_t\(2),
	datad => VCC,
	cin => \regs|receiver|counter_t[1]~275\,
	combout => \regs|receiver|counter_t[2]~276_combout\,
	cout => \regs|receiver|counter_t[2]~277\);

\regs|receiver|counter_t[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_t[2]~276_combout\,
	sdata => \~GND~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|receiver|always4~1_combout\,
	ena => \regs|receiver|counter_t[1]~273_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_t\(2));

\regs|receiver|counter_t[4]~280\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_t[4]~280_combout\ = \regs|receiver|counter_t\(4) & !\regs|receiver|counter_t[3]~279\ # !\regs|receiver|counter_t\(4) & (\regs|receiver|counter_t[3]~279\ # GND)
-- \regs|receiver|counter_t[4]~281\ = CARRY(!\regs|receiver|counter_t[3]~279\ # !\regs|receiver|counter_t\(4))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|counter_t\(4),
	datad => VCC,
	cin => \regs|receiver|counter_t[3]~279\,
	combout => \regs|receiver|counter_t[4]~280_combout\,
	cout => \regs|receiver|counter_t[4]~281\);

\regs|receiver|counter_t[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_t[4]~280_combout\,
	sdata => \~GND~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|receiver|always4~1_combout\,
	ena => \regs|receiver|counter_t[1]~273_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_t\(4));

\regs|receiver|counter_t[5]~282\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_t[5]~282_combout\ = \regs|receiver|counter_t\(5) & (\regs|receiver|counter_t[4]~281\ $ GND) # !\regs|receiver|counter_t\(5) & !\regs|receiver|counter_t[4]~281\ & VCC
-- \regs|receiver|counter_t[5]~283\ = CARRY(\regs|receiver|counter_t\(5) & !\regs|receiver|counter_t[4]~281\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_t\(5),
	datad => VCC,
	cin => \regs|receiver|counter_t[4]~281\,
	combout => \regs|receiver|counter_t[5]~282_combout\,
	cout => \regs|receiver|counter_t[5]~283\);

\regs|receiver|counter_t[6]~284\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_t[6]~284_combout\ = \regs|receiver|counter_t\(6) & !\regs|receiver|counter_t[5]~283\ # !\regs|receiver|counter_t\(6) & (\regs|receiver|counter_t[5]~283\ # GND)
-- \regs|receiver|counter_t[6]~285\ = CARRY(!\regs|receiver|counter_t[5]~283\ # !\regs|receiver|counter_t\(6))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_t\(6),
	datad => VCC,
	cin => \regs|receiver|counter_t[5]~283\,
	combout => \regs|receiver|counter_t[6]~284_combout\,
	cout => \regs|receiver|counter_t[6]~285\);

\regs|receiver|counter_t[7]~286\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_t[7]~286_combout\ = \regs|receiver|counter_t\(7) & \regs|receiver|counter_t[6]~285\ & VCC # !\regs|receiver|counter_t\(7) & !\regs|receiver|counter_t[6]~285\
-- \regs|receiver|counter_t[7]~287\ = CARRY(!\regs|receiver|counter_t\(7) & !\regs|receiver|counter_t[6]~285\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100000011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|counter_t\(7),
	datad => VCC,
	cin => \regs|receiver|counter_t[6]~285\,
	combout => \regs|receiver|counter_t[7]~286_combout\,
	cout => \regs|receiver|counter_t[7]~287\);

\regs|receiver|counter_t[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_t[7]~286_combout\,
	sdata => \regs|receiver|WideOr6~23_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|receiver|always4~1_combout\,
	ena => \regs|receiver|counter_t[1]~273_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_t\(7));

\regs|receiver|counter_t[8]~288\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_t[8]~288_combout\ = \regs|receiver|counter_t\(8) & (GND # !\regs|receiver|counter_t[7]~287\) # !\regs|receiver|counter_t\(8) & (\regs|receiver|counter_t[7]~287\ $ GND)
-- \regs|receiver|counter_t[8]~289\ = CARRY(\regs|receiver|counter_t\(8) # !\regs|receiver|counter_t[7]~287\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101010101111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_t\(8),
	datad => VCC,
	cin => \regs|receiver|counter_t[7]~287\,
	combout => \regs|receiver|counter_t[8]~288_combout\,
	cout => \regs|receiver|counter_t[8]~289\);

\regs|receiver|counter_t[9]~290\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|counter_t[9]~290_combout\ = \regs|receiver|counter_t[8]~289\ $ !\regs|receiver|counter_t\(9)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \regs|receiver|counter_t\(9),
	cin => \regs|receiver|counter_t[8]~289\,
	combout => \regs|receiver|counter_t[9]~290_combout\);

\regs|receiver|counter_t[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_t[9]~290_combout\,
	sdata => \regs|receiver|WideOr5~15_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|receiver|always4~1_combout\,
	ena => \regs|receiver|counter_t[1]~273_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_t\(9));

\regs|receiver|counter_t[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_t[5]~282_combout\,
	sdata => \regs|receiver|Decoder4~13_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|receiver|always4~1_combout\,
	ena => \regs|receiver|counter_t[1]~273_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_t\(5));

\regs|receiver|counter_t[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_t[6]~284_combout\,
	sdata => \regs|receiver|WideOr7~30_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|receiver|always4~1_combout\,
	ena => \regs|receiver|counter_t[1]~273_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_t\(6));

\regs|ti_int~100\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ti_int~100_combout\ = \regs|receiver|counter_t\(4) & !\regs|receiver|counter_t\(7) & \regs|receiver|counter_t\(5) & \regs|receiver|counter_t\(6)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|counter_t\(4),
	datab => \regs|receiver|counter_t\(7),
	datac => \regs|receiver|counter_t\(5),
	datad => \regs|receiver|counter_t\(6),
	combout => \regs|ti_int~100_combout\);

\regs|receiver|counter_t[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|counter_t[8]~288_combout\,
	sdata => \regs|receiver|WideOr5~15_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|receiver|always4~1_combout\,
	ena => \regs|receiver|counter_t[1]~273_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|counter_t\(8));

\regs|ti_int~101\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ti_int~101_combout\ = \regs|ti_int~99_combout\ & \regs|receiver|counter_t\(9) & \regs|ti_int~100_combout\ & !\regs|receiver|counter_t\(8)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|ti_int~99_combout\,
	datab => \regs|receiver|counter_t\(9),
	datac => \regs|ti_int~100_combout\,
	datad => \regs|receiver|counter_t\(8),
	combout => \regs|ti_int~101_combout\);

\regs|ti_int\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ti_int~combout\ = \regs|ier\(0) & \regs|ti_int~101_combout\ & !\regs|lsr0~14_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|ier\(0),
	datac => \regs|ti_int~101_combout\,
	datad => \regs|lsr0~14_combout\,
	combout => \regs|ti_int~combout\);

\regs|ti_int_pnd~87\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ti_int_pnd~87_combout\ = \regs|ier\(0) & \regs|ti_int_pnd~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|ier\(0),
	datad => \regs|ti_int_pnd~regout\,
	combout => \regs|ti_int_pnd~87_combout\);

\regs|ti_int_pnd~88\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ti_int_pnd~88_combout\ = \regs|fifo_read~combout\ & (\regs|ti_int_pnd~87_combout\ # !\regs|ti_int_d~regout\ & \regs|ti_int~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|ti_int_d~regout\,
	datab => \regs|ti_int~combout\,
	datac => \regs|ti_int_pnd~87_combout\,
	datad => \regs|fifo_read~combout\,
	combout => \regs|ti_int_pnd~88_combout\);

\regs|ti_int_pnd\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|ti_int_pnd~88_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|ti_int_pnd~regout\);

\regs|ier[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux37~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|ier[0]~62_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|ier\(2));

\regs|rls_int_pnd~90\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rls_int_pnd~90_combout\ = \regs|rls_int_pnd~regout\ & \regs|ier\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|rls_int_pnd~regout\,
	datac => \regs|ier\(2),
	combout => \regs|rls_int_pnd~90_combout\);

\regs|rls_int~41\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rls_int~41_combout\ = \regs|rls_int~40_combout\ & \regs|ier\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|rls_int~40_combout\,
	datac => \regs|ier\(2),
	combout => \regs|rls_int~41_combout\);

\regs|rls_int_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|rls_int~41_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|rls_int_d~regout\);

\regs|rls_int_pnd~91\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rls_int_pnd~91_combout\ = \regs|lsr_mask~combout\ & (\regs|rls_int_pnd~90_combout\ # \regs|rls_int~41_combout\ & !\regs|rls_int_d~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|rls_int~41_combout\,
	datab => \regs|rls_int_pnd~90_combout\,
	datac => \regs|rls_int_d~regout\,
	datad => \regs|lsr_mask~combout\,
	combout => \regs|rls_int_pnd~91_combout\);

\regs|rls_int_pnd\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|rls_int_pnd~91_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|rls_int_pnd~regout\);

\regs|fcr[1]~38\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|fcr[1]~38_combout\ = !\wb_interface|Mux32~228_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|Mux32~228_combout\,
	combout => \regs|fcr[1]~38_combout\);

\regs|fcr[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|fcr[1]~38_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|always6~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|fcr\(1));

\regs|rda_int~269\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rda_int~269_combout\ = !\regs|receiver|fifo_rx|count\(0) & !\regs|receiver|fifo_rx|count\(1) # !\regs|fcr\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101011111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|fcr\(0),
	datac => \regs|receiver|fifo_rx|count\(0),
	datad => \regs|receiver|fifo_rx|count\(1),
	combout => \regs|rda_int~269_combout\);

\regs|rda_int~270\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rda_int~270_combout\ = !\regs|receiver|fifo_rx|count\(3) & (!\regs|receiver|fifo_rx|count\(2) & \regs|rda_int~269_combout\ # !\regs|fcr\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001010100010001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(3),
	datab => \regs|fcr\(1),
	datac => \regs|receiver|fifo_rx|count\(2),
	datad => \regs|rda_int~269_combout\,
	combout => \regs|rda_int~270_combout\);

\regs|rda_int~271\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rda_int~271_combout\ = !\regs|fcr\(0) & !\regs|fcr\(1) & (!\regs|receiver|fifo_rx|count\(1) # !\regs|receiver|fifo_rx|count\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|fcr\(0),
	datab => \regs|receiver|fifo_rx|count\(2),
	datac => \regs|receiver|fifo_rx|count\(1),
	datad => \regs|fcr\(1),
	combout => \regs|rda_int~271_combout\);

\regs|rda_int~272\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|rda_int~272_combout\ = \regs|ier\(0) & (\regs|receiver|fifo_rx|count\(4) # !\regs|rda_int~270_combout\ & !\regs|rda_int~271_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100010001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|ier\(0),
	datac => \regs|rda_int~270_combout\,
	datad => \regs|rda_int~271_combout\,
	combout => \regs|rda_int~272_combout\);

\regs|iir~316\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|iir~316_combout\ = \regs|ti_int_pnd~regout\ # \regs|rls_int_pnd~regout\ # \regs|rda_int~272_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|ti_int_pnd~regout\,
	datac => \regs|rls_int_pnd~regout\,
	datad => \regs|rda_int~272_combout\,
	combout => \regs|iir~316_combout\);

\regs|iir[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|iir~316_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|iir\(2));

\regs|receiver|Selector9~42\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector9~42_combout\ = \regs|receiver|rparity_error~regout\ & \regs|receiver|rstate\(1) & (!\regs|receiver|Equal0~133_combout\ # !\regs|receiver|Equal0~134_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rparity_error~regout\,
	datab => \regs|receiver|Equal0~134_combout\,
	datac => \regs|receiver|Equal0~133_combout\,
	datad => \regs|receiver|rstate\(1),
	combout => \regs|receiver|Selector9~42_combout\);

\regs|receiver|rf_data_in[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|Selector9~42_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|rf_data_in[3]~631_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_data_in\(1));

\regs|lsr0r~133\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr0r~133_combout\ = \regs|rf_pop~regout\ & (\regs|receiver|rf_push_q~regout\ # !\regs|receiver|rf_push~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|rf_pop~regout\,
	datac => \regs|receiver|rf_push_q~regout\,
	datad => \regs|receiver|rf_push~regout\,
	combout => \regs|lsr0r~133_combout\);

\regs|receiver|fifo_rx|fifo~6639\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo~6639_combout\ = \regs|receiver|rf_data_in\(1) & !\regs|lsr0r~133_combout\ & !\regs|rx_reset~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rf_data_in\(1),
	datac => \regs|lsr0r~133_combout\,
	datad => \regs|rx_reset~regout\,
	combout => \regs|receiver|fifo_rx|fifo~6639_combout\);

\regs|receiver|fifo_rx|fifo[15][0]~6686\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[15][0]~6686_combout\ = !\regs|receiver|fifo_rx|count\(0) & !\regs|receiver|fifo_rx|count\(4) & \regs|lsr0r~131_combout\ # !\regs|receiver|fifo_rx|Decoder0~287_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101011101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder0~287_combout\,
	datab => \regs|receiver|fifo_rx|count\(0),
	datac => \regs|receiver|fifo_rx|count\(4),
	datad => \regs|lsr0r~131_combout\,
	combout => \regs|receiver|fifo_rx|fifo[15][0]~6686_combout\);

\regs|receiver|fifo_rx|Decoder1~287\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~287_combout\ = \regs|receiver|fifo_rx|top\(2) & \regs|receiver|fifo_rx|top\(0) & \regs|receiver|fifo_rx|top\(3) & \regs|receiver|fifo_rx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(2),
	datab => \regs|receiver|fifo_rx|top\(0),
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Decoder1~287_combout\);

\regs|receiver|fifo_rx|fifo[15][0]~6685\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[15][0]~6685_combout\ = \regs|receiver|rf_push_pulse~combout\ & (\regs|receiver|fifo_rx|count\(4) & !\regs|rf_pop~regout\ # !\regs|receiver|fifo_rx|Decoder1~287_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011101100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|receiver|fifo_rx|Decoder1~287_combout\,
	datac => \regs|rf_pop~regout\,
	datad => \regs|receiver|rf_push_pulse~combout\,
	combout => \regs|receiver|fifo_rx|fifo[15][0]~6685_combout\);

\regs|receiver|fifo_rx|fifo[15][0]~6687\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[15][0]~6687_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[15][0]~6685_combout\ & (!\regs|receiver|fifo_rx|fifo[15][0]~6686_combout\ # !\regs|lsr0r~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0r~133_combout\,
	datab => \regs|receiver|fifo_rx|fifo[15][0]~6686_combout\,
	datac => \regs|receiver|fifo_rx|fifo[15][0]~6685_combout\,
	datad => \regs|rx_reset~regout\,
	combout => \regs|receiver|fifo_rx|fifo[15][0]~6687_combout\);

\regs|receiver|fifo_rx|fifo[15][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[15][0]~6687_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[15][1]~regout\);

\regs|receiver|fifo_rx|Decoder1~285\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~285_combout\ = \regs|receiver|fifo_rx|top\(3) & \regs|receiver|fifo_rx|top\(0) & !\regs|receiver|fifo_rx|top\(2) & \regs|receiver|fifo_rx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(3),
	datab => \regs|receiver|fifo_rx|top\(0),
	datac => \regs|receiver|fifo_rx|top\(2),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Decoder1~285_combout\);

\regs|receiver|fifo_rx|fifo[11][0]~6679\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[11][0]~6679_combout\ = \regs|receiver|rf_push_pulse~combout\ & (\regs|receiver|fifo_rx|count\(4) & !\regs|rf_pop~regout\ # !\regs|receiver|fifo_rx|Decoder1~285_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011101100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|receiver|fifo_rx|Decoder1~285_combout\,
	datac => \regs|rf_pop~regout\,
	datad => \regs|receiver|rf_push_pulse~combout\,
	combout => \regs|receiver|fifo_rx|fifo[11][0]~6679_combout\);

\regs|receiver|fifo_rx|fifo[11][0]~6681\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[11][0]~6681_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[11][0]~6679_combout\ & (!\regs|lsr0r~133_combout\ # !\regs|receiver|fifo_rx|fifo[11][0]~6680_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[11][0]~6680_combout\,
	datab => \regs|lsr0r~133_combout\,
	datac => \regs|receiver|fifo_rx|fifo[11][0]~6679_combout\,
	datad => \regs|rx_reset~regout\,
	combout => \regs|receiver|fifo_rx|fifo[11][0]~6681_combout\);

\regs|receiver|fifo_rx|fifo[11][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[11][0]~6681_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[11][1]~regout\);

\regs|receiver|fifo_rx|Decoder0~286\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~286_combout\ = !\regs|receiver|fifo_rx|bottom\(3) & \regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(0) & !\regs|receiver|fifo_rx|bottom\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(3),
	datab => \regs|receiver|fifo_rx|bottom\(1),
	datac => \regs|receiver|fifo_rx|bottom\(0),
	datad => \regs|receiver|fifo_rx|bottom\(2),
	combout => \regs|receiver|fifo_rx|Decoder0~286_combout\);

\regs|receiver|fifo_rx|fifo[3][2]~6683\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[3][2]~6683_combout\ = !\regs|receiver|fifo_rx|count\(4) & \regs|lsr0r~131_combout\ & !\regs|receiver|fifo_rx|count\(0) # !\regs|receiver|fifo_rx|Decoder0~286_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001101110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|receiver|fifo_rx|Decoder0~286_combout\,
	datac => \regs|lsr0r~131_combout\,
	datad => \regs|receiver|fifo_rx|count\(0),
	combout => \regs|receiver|fifo_rx|fifo[3][2]~6683_combout\);

\regs|receiver|fifo_rx|fifo[3][2]~6682\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[3][2]~6682_combout\ = \regs|receiver|rf_push_pulse~combout\ & (!\regs|rf_pop~regout\ & \regs|receiver|fifo_rx|count\(4) # !\regs|receiver|fifo_rx|Decoder1~286_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111010100110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder1~286_combout\,
	datab => \regs|rf_pop~regout\,
	datac => \regs|receiver|fifo_rx|count\(4),
	datad => \regs|receiver|rf_push_pulse~combout\,
	combout => \regs|receiver|fifo_rx|fifo[3][2]~6682_combout\);

\regs|receiver|fifo_rx|fifo[3][2]~6684\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[3][2]~6684_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[3][2]~6682_combout\ & (!\regs|receiver|fifo_rx|fifo[3][2]~6683_combout\ # !\regs|lsr0r~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0r~133_combout\,
	datab => \regs|receiver|fifo_rx|fifo[3][2]~6683_combout\,
	datac => \regs|receiver|fifo_rx|fifo[3][2]~6682_combout\,
	datad => \regs|rx_reset~regout\,
	combout => \regs|receiver|fifo_rx|fifo[3][2]~6684_combout\);

\regs|receiver|fifo_rx|fifo[3][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[3][2]~6684_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[3][1]~regout\);

\regs|receiver|fifo_rx|Mux62~68\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux62~68_combout\ = \regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|bottom\(3) # !\regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|bottom\(3) & \regs|receiver|fifo_rx|fifo[11][1]~regout\ # 
-- !\regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|fifo[3][1]~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100111001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(2),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|fifo[11][1]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[3][1]~regout\,
	combout => \regs|receiver|fifo_rx|Mux62~68_combout\);

\regs|receiver|fifo_rx|Mux62~69\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux62~69_combout\ = \regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|Mux62~68_combout\ & (\regs|receiver|fifo_rx|fifo[15][1]~regout\) # !\regs|receiver|fifo_rx|Mux62~68_combout\ & 
-- \regs|receiver|fifo_rx|fifo[7][1]~regout\) # !\regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|Mux62~68_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[7][1]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[15][1]~regout\,
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|Mux62~68_combout\,
	combout => \regs|receiver|fifo_rx|Mux62~69_combout\);

\regs|receiver|fifo_rx|Decoder0~277\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~277_combout\ = \regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(3) & !\regs|receiver|fifo_rx|bottom\(2) & !\regs|receiver|fifo_rx|bottom\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|receiver|fifo_rx|Decoder0~277_combout\);

\regs|receiver|fifo_rx|fifo[10][2]~6656\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[10][2]~6656_combout\ = !\regs|receiver|fifo_rx|count\(4) & \regs|lsr0r~131_combout\ & !\regs|receiver|fifo_rx|count\(0) # !\regs|receiver|fifo_rx|Decoder0~277_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111101001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|lsr0r~131_combout\,
	datac => \regs|receiver|fifo_rx|Decoder0~277_combout\,
	datad => \regs|receiver|fifo_rx|count\(0),
	combout => \regs|receiver|fifo_rx|fifo[10][2]~6656_combout\);

\regs|receiver|fifo_rx|Decoder1~277\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~277_combout\ = \regs|receiver|fifo_rx|top\(1) & \regs|receiver|fifo_rx|top\(3) & !\regs|receiver|fifo_rx|top\(2) & !\regs|receiver|fifo_rx|top\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(1),
	datab => \regs|receiver|fifo_rx|top\(3),
	datac => \regs|receiver|fifo_rx|top\(2),
	datad => \regs|receiver|fifo_rx|top\(0),
	combout => \regs|receiver|fifo_rx|Decoder1~277_combout\);

\regs|receiver|fifo_rx|fifo[10][2]~6655\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[10][2]~6655_combout\ = \regs|receiver|rf_push_pulse~combout\ & (\regs|receiver|fifo_rx|count\(4) & !\regs|rf_pop~regout\ # !\regs|receiver|fifo_rx|Decoder1~277_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011101100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|receiver|fifo_rx|Decoder1~277_combout\,
	datac => \regs|rf_pop~regout\,
	datad => \regs|receiver|rf_push_pulse~combout\,
	combout => \regs|receiver|fifo_rx|fifo[10][2]~6655_combout\);

\regs|receiver|fifo_rx|fifo[10][2]~6657\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[10][2]~6657_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[10][2]~6655_combout\ & (!\regs|receiver|fifo_rx|fifo[10][2]~6656_combout\ # !\regs|lsr0r~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011011111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0r~133_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|receiver|fifo_rx|fifo[10][2]~6656_combout\,
	datad => \regs|receiver|fifo_rx|fifo[10][2]~6655_combout\,
	combout => \regs|receiver|fifo_rx|fifo[10][2]~6657_combout\);

\regs|receiver|fifo_rx|fifo[10][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[10][2]~6657_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[10][1]~regout\);

\regs|receiver|fifo_rx|fifo[2][2]~6658\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[2][2]~6658_combout\ = \regs|receiver|rf_push_pulse~combout\ & (\regs|receiver|fifo_rx|count\(4) & !\regs|rf_pop~regout\ # !\regs|receiver|fifo_rx|Decoder1~278_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101110100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder1~278_combout\,
	datab => \regs|receiver|fifo_rx|count\(4),
	datac => \regs|rf_pop~regout\,
	datad => \regs|receiver|rf_push_pulse~combout\,
	combout => \regs|receiver|fifo_rx|fifo[2][2]~6658_combout\);

\regs|receiver|fifo_rx|fifo[2][2]~6660\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[2][2]~6660_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[2][2]~6658_combout\ & (!\regs|lsr0r~133_combout\ # !\regs|receiver|fifo_rx|fifo[2][2]~6659_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011011111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[2][2]~6659_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|lsr0r~133_combout\,
	datad => \regs|receiver|fifo_rx|fifo[2][2]~6658_combout\,
	combout => \regs|receiver|fifo_rx|fifo[2][2]~6660_combout\);

\regs|receiver|fifo_rx|fifo[2][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|fifo_rx|fifo[2][2]~6660_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[2][1]~regout\);

\regs|receiver|fifo_rx|Mux62~63\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux62~63_combout\ = \regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|bottom\(2) # \regs|receiver|fifo_rx|fifo[10][1]~regout\) # !\regs|receiver|fifo_rx|bottom\(3) & !\regs|receiver|fifo_rx|bottom\(2) & 
-- (\regs|receiver|fifo_rx|fifo[2][1]~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100110101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(3),
	datab => \regs|receiver|fifo_rx|bottom\(2),
	datac => \regs|receiver|fifo_rx|fifo[10][1]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[2][1]~regout\,
	combout => \regs|receiver|fifo_rx|Mux62~63_combout\);

\regs|receiver|fifo_rx|Decoder1~276\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~276_combout\ = !\regs|receiver|fifo_rx|top\(0) & \regs|receiver|fifo_rx|top\(2) & !\regs|receiver|fifo_rx|top\(3) & \regs|receiver|fifo_rx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(0),
	datab => \regs|receiver|fifo_rx|top\(2),
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Decoder1~276_combout\);

\regs|receiver|fifo_rx|fifo[6][1]~6652\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[6][1]~6652_combout\ = \regs|receiver|rf_push_pulse~combout\ & (!\regs|rf_pop~regout\ & \regs|receiver|fifo_rx|count\(4) # !\regs|receiver|fifo_rx|Decoder1~276_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- !\regs|rf_pop~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000111011101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|rf_pop~regout\,
	datab => \regs|receiver|rf_push_pulse~combout\,
	datac => \regs|receiver|fifo_rx|count\(4),
	datad => \regs|receiver|fifo_rx|Decoder1~276_combout\,
	combout => \regs|receiver|fifo_rx|fifo[6][1]~6652_combout\);

\regs|receiver|fifo_rx|Decoder0~276\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~276_combout\ = \regs|receiver|fifo_rx|bottom\(1) & !\regs|receiver|fifo_rx|bottom\(3) & \regs|receiver|fifo_rx|bottom\(2) & !\regs|receiver|fifo_rx|bottom\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|receiver|fifo_rx|Decoder0~276_combout\);

\regs|receiver|fifo_rx|fifo[6][1]~6653\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[6][1]~6653_combout\ = !\regs|receiver|fifo_rx|count\(4) & !\regs|receiver|fifo_rx|count\(0) & \regs|lsr0r~131_combout\ # !\regs|receiver|fifo_rx|Decoder0~276_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|receiver|fifo_rx|count\(0),
	datac => \regs|lsr0r~131_combout\,
	datad => \regs|receiver|fifo_rx|Decoder0~276_combout\,
	combout => \regs|receiver|fifo_rx|fifo[6][1]~6653_combout\);

\regs|receiver|fifo_rx|fifo[6][1]~6654\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[6][1]~6654_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[6][1]~6652_combout\ & (!\regs|receiver|fifo_rx|fifo[6][1]~6653_combout\ # !\regs|lsr0r~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110111001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0r~133_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|receiver|fifo_rx|fifo[6][1]~6652_combout\,
	datad => \regs|receiver|fifo_rx|fifo[6][1]~6653_combout\,
	combout => \regs|receiver|fifo_rx|fifo[6][1]~6654_combout\);

\regs|receiver|fifo_rx|fifo[6][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[6][1]~6654_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[6][1]~regout\);

\regs|receiver|fifo_rx|fifo[14][2]~6662\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[14][2]~6662_combout\ = !\regs|receiver|fifo_rx|count\(0) & \regs|lsr0r~131_combout\ & !\regs|receiver|fifo_rx|count\(4) # !\regs|receiver|fifo_rx|Decoder0~279_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101110101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder0~279_combout\,
	datab => \regs|receiver|fifo_rx|count\(0),
	datac => \regs|lsr0r~131_combout\,
	datad => \regs|receiver|fifo_rx|count\(4),
	combout => \regs|receiver|fifo_rx|fifo[14][2]~6662_combout\);

\regs|receiver|fifo_rx|Decoder1~279\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~279_combout\ = !\regs|receiver|fifo_rx|top\(0) & \regs|receiver|fifo_rx|top\(2) & \regs|receiver|fifo_rx|top\(3) & \regs|receiver|fifo_rx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(0),
	datab => \regs|receiver|fifo_rx|top\(2),
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(1),
	combout => \regs|receiver|fifo_rx|Decoder1~279_combout\);

\regs|receiver|fifo_rx|fifo[14][2]~6661\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[14][2]~6661_combout\ = \regs|receiver|rf_push_pulse~combout\ & (!\regs|rf_pop~regout\ & \regs|receiver|fifo_rx|count\(4) # !\regs|receiver|fifo_rx|Decoder1~279_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- !\regs|rf_pop~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101110100011101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|rf_pop~regout\,
	datab => \regs|receiver|rf_push_pulse~combout\,
	datac => \regs|receiver|fifo_rx|Decoder1~279_combout\,
	datad => \regs|receiver|fifo_rx|count\(4),
	combout => \regs|receiver|fifo_rx|fifo[14][2]~6661_combout\);

\regs|receiver|fifo_rx|fifo[14][2]~6663\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[14][2]~6663_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[14][2]~6661_combout\ & (!\regs|receiver|fifo_rx|fifo[14][2]~6662_combout\ # !\regs|lsr0r~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0r~133_combout\,
	datab => \regs|receiver|fifo_rx|fifo[14][2]~6662_combout\,
	datac => \regs|receiver|fifo_rx|fifo[14][2]~6661_combout\,
	datad => \regs|rx_reset~regout\,
	combout => \regs|receiver|fifo_rx|fifo[14][2]~6663_combout\);

\regs|receiver|fifo_rx|fifo[14][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[14][2]~6663_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[14][1]~regout\);

\regs|receiver|fifo_rx|Mux62~64\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux62~64_combout\ = \regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|Mux62~63_combout\ & (\regs|receiver|fifo_rx|fifo[14][1]~regout\) # !\regs|receiver|fifo_rx|Mux62~63_combout\ & 
-- \regs|receiver|fifo_rx|fifo[6][1]~regout\) # !\regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|Mux62~63_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(2),
	datab => \regs|receiver|fifo_rx|Mux62~63_combout\,
	datac => \regs|receiver|fifo_rx|fifo[6][1]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[14][1]~regout\,
	combout => \regs|receiver|fifo_rx|Mux62~64_combout\);

\regs|receiver|fifo_rx|fifo[8][0]~6665\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[8][0]~6665_combout\ = !\regs|receiver|fifo_rx|count\(4) & !\regs|receiver|fifo_rx|count\(0) & \regs|lsr0r~131_combout\ # !\regs|receiver|fifo_rx|Decoder0~280_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101011101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder0~280_combout\,
	datab => \regs|receiver|fifo_rx|count\(4),
	datac => \regs|receiver|fifo_rx|count\(0),
	datad => \regs|lsr0r~131_combout\,
	combout => \regs|receiver|fifo_rx|fifo[8][0]~6665_combout\);

\regs|receiver|fifo_rx|fifo[8][0]~6664\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[8][0]~6664_combout\ = \regs|receiver|rf_push_pulse~combout\ & (\regs|receiver|fifo_rx|count\(4) & !\regs|rf_pop~regout\ # !\regs|receiver|fifo_rx|Decoder1~280_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101110100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder1~280_combout\,
	datab => \regs|receiver|fifo_rx|count\(4),
	datac => \regs|rf_pop~regout\,
	datad => \regs|receiver|rf_push_pulse~combout\,
	combout => \regs|receiver|fifo_rx|fifo[8][0]~6664_combout\);

\regs|receiver|fifo_rx|fifo[8][0]~6666\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[8][0]~6666_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[8][0]~6664_combout\ & (!\regs|receiver|fifo_rx|fifo[8][0]~6665_combout\ # !\regs|lsr0r~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0r~133_combout\,
	datab => \regs|receiver|fifo_rx|fifo[8][0]~6665_combout\,
	datac => \regs|rx_reset~regout\,
	datad => \regs|receiver|fifo_rx|fifo[8][0]~6664_combout\,
	combout => \regs|receiver|fifo_rx|fifo[8][0]~6666_combout\);

\regs|receiver|fifo_rx|fifo[8][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[8][0]~6666_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[8][1]~regout\);

\regs|receiver|fifo_rx|Decoder1~283\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~283_combout\ = !\regs|receiver|fifo_rx|top\(1) & \regs|receiver|fifo_rx|top\(2) & \regs|receiver|fifo_rx|top\(3) & !\regs|receiver|fifo_rx|top\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(1),
	datab => \regs|receiver|fifo_rx|top\(2),
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(0),
	combout => \regs|receiver|fifo_rx|Decoder1~283_combout\);

\regs|receiver|fifo_rx|fifo[12][0]~6673\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[12][0]~6673_combout\ = \regs|receiver|rf_push_pulse~combout\ & (!\regs|rf_pop~regout\ & \regs|receiver|fifo_rx|count\(4) # !\regs|receiver|fifo_rx|Decoder1~283_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010111100100111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rf_push_pulse~combout\,
	datab => \regs|receiver|fifo_rx|Decoder1~283_combout\,
	datac => \regs|rf_pop~regout\,
	datad => \regs|receiver|fifo_rx|count\(4),
	combout => \regs|receiver|fifo_rx|fifo[12][0]~6673_combout\);

\regs|receiver|fifo_rx|fifo[12][0]~6675\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[12][0]~6675_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[12][0]~6673_combout\ & (!\regs|lsr0r~133_combout\ # !\regs|receiver|fifo_rx|fifo[12][0]~6674_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000111110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[12][0]~6674_combout\,
	datab => \regs|receiver|fifo_rx|fifo[12][0]~6673_combout\,
	datac => \regs|rx_reset~regout\,
	datad => \regs|lsr0r~133_combout\,
	combout => \regs|receiver|fifo_rx|fifo[12][0]~6675_combout\);

\regs|receiver|fifo_rx|fifo[12][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[12][0]~6675_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[12][1]~regout\);

\regs|receiver|fifo_rx|Mux62~66\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux62~66_combout\ = \regs|receiver|fifo_rx|Mux62~65_combout\ & (\regs|receiver|fifo_rx|fifo[12][1]~regout\ # !\regs|receiver|fifo_rx|bottom\(3)) # !\regs|receiver|fifo_rx|Mux62~65_combout\ & \regs|receiver|fifo_rx|fifo[8][1]~regout\ 
-- & (\regs|receiver|fifo_rx|bottom\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110010010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Mux62~65_combout\,
	datab => \regs|receiver|fifo_rx|fifo[8][1]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[12][1]~regout\,
	datad => \regs|receiver|fifo_rx|bottom\(3),
	combout => \regs|receiver|fifo_rx|Mux62~66_combout\);

\regs|receiver|fifo_rx|Mux62~67\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux62~67_combout\ = \regs|receiver|fifo_rx|bottom\(1) & (\regs|receiver|fifo_rx|bottom\(0) # \regs|receiver|fifo_rx|Mux62~64_combout\) # !\regs|receiver|fifo_rx|bottom\(1) & !\regs|receiver|fifo_rx|bottom\(0) & 
-- (\regs|receiver|fifo_rx|Mux62~66_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100110101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(0),
	datac => \regs|receiver|fifo_rx|Mux62~64_combout\,
	datad => \regs|receiver|fifo_rx|Mux62~66_combout\,
	combout => \regs|receiver|fifo_rx|Mux62~67_combout\);

\regs|receiver|fifo_rx|Mux62~70\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux62~70_combout\ = \regs|receiver|fifo_rx|bottom\(0) & (\regs|receiver|fifo_rx|Mux62~67_combout\ & (\regs|receiver|fifo_rx|Mux62~69_combout\) # !\regs|receiver|fifo_rx|Mux62~67_combout\ & \regs|receiver|fifo_rx|Mux62~62_combout\) # 
-- !\regs|receiver|fifo_rx|bottom\(0) & (\regs|receiver|fifo_rx|Mux62~67_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Mux62~62_combout\,
	datab => \regs|receiver|fifo_rx|bottom\(0),
	datac => \regs|receiver|fifo_rx|Mux62~69_combout\,
	datad => \regs|receiver|fifo_rx|Mux62~67_combout\,
	combout => \regs|receiver|fifo_rx|Mux62~70_combout\);

\regs|lsr2r~34\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr2r~34_combout\ = \regs|lsr_mask~combout\ & (\regs|lsr2r~regout\ # !\regs|lsr2_d~regout\ & \regs|receiver|fifo_rx|Mux62~70_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr2_d~regout\,
	datab => \regs|receiver|fifo_rx|Mux62~70_combout\,
	datac => \regs|lsr2r~regout\,
	datad => \regs|lsr_mask~combout\,
	combout => \regs|lsr2r~34_combout\);

\regs|lsr2r\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr2r~34_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr2r~regout\);

\regs|Mux7~340\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~340_combout\ = \wb_interface|wb_adr_is\(2) # \wb_interface|wb_adr_int[1]~63_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|wb_adr_is\(2),
	datad => \wb_interface|wb_adr_int[1]~63_combout\,
	combout => \regs|Mux7~340_combout\);

\regs|Mux5~88\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux5~88_combout\ = \regs|Mux7~341_combout\ & (\regs|dl\(10) # \regs|Mux7~340_combout\) # !\regs|Mux7~341_combout\ & \regs|ier\(2) & (!\regs|Mux7~340_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|ier\(2),
	datab => \regs|Mux7~341_combout\,
	datac => \regs|dl\(10),
	datad => \regs|Mux7~340_combout\,
	combout => \regs|Mux5~88_combout\);

\regs|Mux5~89\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux5~89_combout\ = \regs|Mux7~340_combout\ & (\regs|Mux5~88_combout\ & (\regs|lcr\(2)) # !\regs|Mux5~88_combout\ & \regs|lsr2r~regout\) # !\regs|Mux7~340_combout\ & (\regs|Mux5~88_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~340_combout\,
	datab => \regs|lsr2r~regout\,
	datac => \regs|lcr\(2),
	datad => \regs|Mux5~88_combout\,
	combout => \regs|Mux5~89_combout\);

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(5),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(11));

\regs|receiver|fifo_rx|rfifo|ram~20\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(5),
	sload => VCC,
	ena => \regs|receiver|fifo_rx|rfifo|ram~145_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram~20_regout\);

\regs|Mux5~85\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux5~85_combout\ = \regs|receiver|fifo_rx|rfifo|ram~20_regout\ # \regs|receiver|fifo_rx|rfifo|ram~15_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|receiver|fifo_rx|rfifo|ram~20_regout\,
	datad => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	combout => \regs|Mux5~85_combout\);

\regs|Mux5~86\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux5~86_combout\ = \regs|lcr\(7) & \regs|Mux7~335_combout\ # !\regs|lcr\(7) & (\regs|Mux7~335_combout\ & (\regs|Mux5~85_combout\) # !\regs|Mux7~335_combout\ & \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(11))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(7),
	datab => \regs|Mux7~335_combout\,
	datac => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(11),
	datad => \regs|Mux5~85_combout\,
	combout => \regs|Mux5~86_combout\);

\regs|Mux5~87\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux5~87_combout\ = \regs|Mux7~336_combout\ & (\regs|Mux5~86_combout\ & (\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(2)) # !\regs|Mux5~86_combout\ & \regs|dl\(2)) # !\regs|Mux7~336_combout\ & \regs|Mux5~86_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~336_combout\,
	datab => \regs|Mux5~86_combout\,
	datac => \regs|dl\(2),
	datad => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(2),
	combout => \regs|Mux5~87_combout\);

\regs|Mux5~90\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux5~90_combout\ = \regs|Mux7~344_combout\ & (\regs|Mux7~345_combout\ & \regs|Mux5~89_combout\ # !\regs|Mux7~345_combout\ & (\regs|Mux5~87_combout\)) # !\regs|Mux7~344_combout\ & \regs|Mux7~345_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110011011000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~344_combout\,
	datab => \regs|Mux7~345_combout\,
	datac => \regs|Mux5~89_combout\,
	datad => \regs|Mux5~87_combout\,
	combout => \regs|Mux5~90_combout\);

\regs|Mux5~91\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux5~91_combout\ = \regs|msr_read~19_combout\ & (\regs|Mux5~90_combout\ & \regs|msr\(2) # !\regs|Mux5~90_combout\ & (\regs|iir\(2))) # !\regs|msr_read~19_combout\ & (\regs|Mux5~90_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|msr\(2),
	datab => \regs|iir\(2),
	datac => \regs|msr_read~19_combout\,
	datad => \regs|Mux5~90_combout\,
	combout => \regs|Mux5~91_combout\);

\regs|always4~27\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|always4~27_combout\ = \wb_interface|wb_adr_int[0]~64_combout\ & \wb_interface|wb_adr_int[1]~63_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|wb_adr_int[0]~64_combout\,
	datad => \wb_interface|wb_adr_int[1]~63_combout\,
	combout => \regs|always4~27_combout\);

\regs|Mux5~92\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux5~92_combout\ = \wb_interface|wb_adr_is\(2) & (\regs|always4~27_combout\ & \regs|scratch\(2) # !\regs|always4~27_combout\ & (\regs|Mux5~91_combout\)) # !\wb_interface|wb_adr_is\(2) & (\regs|Mux5~91_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|scratch\(2),
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|Mux5~91_combout\,
	datad => \regs|always4~27_combout\,
	combout => \regs|Mux5~92_combout\);

\wb_interface|Mux29~200\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux29~200_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux29~199_combout\ # \wb_interface|Mux31~219_combout\ & \regs|Mux5~92_combout\) # !\wb_interface|Mux31~216_combout\ & (\wb_interface|Mux31~219_combout\ & 
-- \regs|Mux5~92_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux29~199_combout\,
	datac => \wb_interface|Mux31~219_combout\,
	datad => \regs|Mux5~92_combout\,
	combout => \wb_interface|Mux29~200_combout\);

\wb_interface|wb_dat_o[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux29~200_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(2));

\regs|receiver|rf_data_in[0]~633\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rf_data_in[0]~633_combout\ = !\regs|receiver|Selector10~14_combout\ & \regs|enable~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|Selector10~14_combout\,
	datac => \regs|enable~regout\,
	combout => \regs|receiver|rf_data_in[0]~633_combout\);

\regs|receiver|rf_data_in[0]~634\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rf_data_in[0]~634_combout\ = \regs|receiver|rf_data_in[0]~633_combout\ & \regs|receiver|rf_data_in[0]~632_combout\ & (\regs|receiver|rf_data_in\(0) # \regs|serial_in~34_combout\) # !\regs|receiver|rf_data_in[0]~633_combout\ & 
-- (\regs|receiver|rf_data_in\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100010110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rf_data_in[0]~632_combout\,
	datab => \regs|receiver|rf_data_in[0]~633_combout\,
	datac => \regs|receiver|rf_data_in\(0),
	datad => \regs|serial_in~34_combout\,
	combout => \regs|receiver|rf_data_in[0]~634_combout\);

\regs|receiver|rf_data_in[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rf_data_in[0]~634_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_data_in\(0));

\regs|receiver|fifo_rx|fifo~6688\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo~6688_combout\ = \regs|receiver|rf_data_in\(0) & !\regs|lsr0r~133_combout\ & !\regs|rx_reset~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rf_data_in\(0),
	datac => \regs|lsr0r~133_combout\,
	datad => \regs|rx_reset~regout\,
	combout => \regs|receiver|fifo_rx|fifo~6688_combout\);

\regs|receiver|fifo_rx|fifo[14][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[14][2]~6663_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[14][0]~regout\);

\regs|receiver|fifo_rx|fifo[12][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[12][0]~6675_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[12][0]~regout\);

\regs|receiver|fifo_rx|Mux63~68\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux63~68_combout\ = \regs|receiver|fifo_rx|bottom\(0) & \regs|receiver|fifo_rx|bottom\(1) # !\regs|receiver|fifo_rx|bottom\(0) & (\regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|fifo[14][0]~regout\ # 
-- !\regs|receiver|fifo_rx|bottom\(1) & (\regs|receiver|fifo_rx|fifo[12][0]~regout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100111001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(0),
	datab => \regs|receiver|fifo_rx|bottom\(1),
	datac => \regs|receiver|fifo_rx|fifo[14][0]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[12][0]~regout\,
	combout => \regs|receiver|fifo_rx|Mux63~68_combout\);

\regs|receiver|fifo_rx|fifo[13][2]~6650\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[13][2]~6650_combout\ = !\regs|receiver|fifo_rx|count\(4) & !\regs|receiver|fifo_rx|count\(0) & \regs|lsr0r~131_combout\ # !\regs|receiver|fifo_rx|Decoder0~275_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101011101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder0~275_combout\,
	datab => \regs|receiver|fifo_rx|count\(4),
	datac => \regs|receiver|fifo_rx|count\(0),
	datad => \regs|lsr0r~131_combout\,
	combout => \regs|receiver|fifo_rx|fifo[13][2]~6650_combout\);

\regs|receiver|fifo_rx|Decoder1~275\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~275_combout\ = !\regs|receiver|fifo_rx|top\(1) & \regs|receiver|fifo_rx|top\(2) & \regs|receiver|fifo_rx|top\(3) & \regs|receiver|fifo_rx|top\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(1),
	datab => \regs|receiver|fifo_rx|top\(2),
	datac => \regs|receiver|fifo_rx|top\(3),
	datad => \regs|receiver|fifo_rx|top\(0),
	combout => \regs|receiver|fifo_rx|Decoder1~275_combout\);

\regs|receiver|fifo_rx|fifo[13][2]~6649\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[13][2]~6649_combout\ = \regs|receiver|rf_push_pulse~combout\ & (\regs|receiver|fifo_rx|count\(4) & !\regs|rf_pop~regout\ # !\regs|receiver|fifo_rx|Decoder1~275_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010001111110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|rf_pop~regout\,
	datac => \regs|receiver|rf_push_pulse~combout\,
	datad => \regs|receiver|fifo_rx|Decoder1~275_combout\,
	combout => \regs|receiver|fifo_rx|fifo[13][2]~6649_combout\);

\regs|receiver|fifo_rx|fifo[13][2]~6651\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[13][2]~6651_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[13][2]~6649_combout\ & (!\regs|receiver|fifo_rx|fifo[13][2]~6650_combout\ # !\regs|lsr0r~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011011111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0r~133_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|receiver|fifo_rx|fifo[13][2]~6650_combout\,
	datad => \regs|receiver|fifo_rx|fifo[13][2]~6649_combout\,
	combout => \regs|receiver|fifo_rx|fifo[13][2]~6651_combout\);

\regs|receiver|fifo_rx|fifo[13][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[13][2]~6651_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[13][0]~regout\);

\regs|receiver|fifo_rx|fifo[15][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|fifo_rx|fifo[15][0]~6687_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[15][0]~regout\);

\regs|receiver|fifo_rx|Mux63~69\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux63~69_combout\ = \regs|receiver|fifo_rx|bottom\(0) & (\regs|receiver|fifo_rx|Mux63~68_combout\ & (\regs|receiver|fifo_rx|fifo[15][0]~regout\) # !\regs|receiver|fifo_rx|Mux63~68_combout\ & 
-- \regs|receiver|fifo_rx|fifo[13][0]~regout\) # !\regs|receiver|fifo_rx|bottom\(0) & \regs|receiver|fifo_rx|Mux63~68_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(0),
	datab => \regs|receiver|fifo_rx|Mux63~68_combout\,
	datac => \regs|receiver|fifo_rx|fifo[13][0]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[15][0]~regout\,
	combout => \regs|receiver|fifo_rx|Mux63~69_combout\);

\regs|receiver|fifo_rx|Decoder1~284\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder1~284_combout\ = \regs|receiver|fifo_rx|top\(1) & !\regs|receiver|fifo_rx|top\(3) & \regs|receiver|fifo_rx|top\(2) & \regs|receiver|fifo_rx|top\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|top\(1),
	datab => \regs|receiver|fifo_rx|top\(3),
	datac => \regs|receiver|fifo_rx|top\(2),
	datad => \regs|receiver|fifo_rx|top\(0),
	combout => \regs|receiver|fifo_rx|Decoder1~284_combout\);

\regs|receiver|fifo_rx|fifo[7][0]~6676\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[7][0]~6676_combout\ = \regs|receiver|rf_push_pulse~combout\ & (\regs|receiver|fifo_rx|count\(4) & !\regs|rf_pop~regout\ # !\regs|receiver|fifo_rx|Decoder1~284_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011101100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|receiver|fifo_rx|Decoder1~284_combout\,
	datac => \regs|rf_pop~regout\,
	datad => \regs|receiver|rf_push_pulse~combout\,
	combout => \regs|receiver|fifo_rx|fifo[7][0]~6676_combout\);

\regs|receiver|fifo_rx|Decoder0~284\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~284_combout\ = !\regs|receiver|fifo_rx|bottom\(3) & \regs|receiver|fifo_rx|bottom\(0) & \regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(3),
	datab => \regs|receiver|fifo_rx|bottom\(0),
	datac => \regs|receiver|fifo_rx|bottom\(1),
	datad => \regs|receiver|fifo_rx|bottom\(2),
	combout => \regs|receiver|fifo_rx|Decoder0~284_combout\);

\regs|receiver|fifo_rx|fifo[7][0]~6677\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[7][0]~6677_combout\ = !\regs|receiver|fifo_rx|count\(4) & !\regs|receiver|fifo_rx|count\(0) & \regs|lsr0r~131_combout\ # !\regs|receiver|fifo_rx|Decoder0~284_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|receiver|fifo_rx|count\(0),
	datac => \regs|receiver|fifo_rx|Decoder0~284_combout\,
	datad => \regs|lsr0r~131_combout\,
	combout => \regs|receiver|fifo_rx|fifo[7][0]~6677_combout\);

\regs|receiver|fifo_rx|fifo[7][0]~6678\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[7][0]~6678_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[7][0]~6676_combout\ & (!\regs|receiver|fifo_rx|fifo[7][0]~6677_combout\ # !\regs|lsr0r~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110111001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0r~133_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|receiver|fifo_rx|fifo[7][0]~6676_combout\,
	datad => \regs|receiver|fifo_rx|fifo[7][0]~6677_combout\,
	combout => \regs|receiver|fifo_rx|fifo[7][0]~6678_combout\);

\regs|receiver|fifo_rx|fifo[7][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[7][0]~6678_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[7][0]~regout\);

\regs|receiver|fifo_rx|Decoder0~281\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~281_combout\ = !\regs|receiver|fifo_rx|bottom\(1) & !\regs|receiver|fifo_rx|bottom\(0) & \regs|receiver|fifo_rx|bottom\(2) & !\regs|receiver|fifo_rx|bottom\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(0),
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|bottom\(3),
	combout => \regs|receiver|fifo_rx|Decoder0~281_combout\);

\regs|receiver|fifo_rx|fifo[4][2]~6668\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[4][2]~6668_combout\ = !\regs|receiver|fifo_rx|count\(4) & \regs|lsr0r~131_combout\ & !\regs|receiver|fifo_rx|count\(0) # !\regs|receiver|fifo_rx|Decoder0~281_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111101001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|lsr0r~131_combout\,
	datac => \regs|receiver|fifo_rx|Decoder0~281_combout\,
	datad => \regs|receiver|fifo_rx|count\(0),
	combout => \regs|receiver|fifo_rx|fifo[4][2]~6668_combout\);

\regs|receiver|fifo_rx|fifo[4][2]~6669\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[4][2]~6669_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[4][2]~6667_combout\ & (!\regs|receiver|fifo_rx|fifo[4][2]~6668_combout\ # !\regs|lsr0r~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000111110101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[4][2]~6667_combout\,
	datab => \regs|lsr0r~133_combout\,
	datac => \regs|rx_reset~regout\,
	datad => \regs|receiver|fifo_rx|fifo[4][2]~6668_combout\,
	combout => \regs|receiver|fifo_rx|fifo[4][2]~6669_combout\);

\regs|receiver|fifo_rx|fifo[4][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[4][2]~6669_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[4][0]~regout\);

\regs|receiver|fifo_rx|fifo[5][0]~6643\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[5][0]~6643_combout\ = \regs|receiver|rf_push_pulse~combout\ & (!\regs|rf_pop~regout\ & \regs|receiver|fifo_rx|count\(4) # !\regs|receiver|fifo_rx|Decoder1~273_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111001101010011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder1~273_combout\,
	datab => \regs|rf_pop~regout\,
	datac => \regs|receiver|rf_push_pulse~combout\,
	datad => \regs|receiver|fifo_rx|count\(4),
	combout => \regs|receiver|fifo_rx|fifo[5][0]~6643_combout\);

\regs|receiver|fifo_rx|fifo[5][0]~6645\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[5][0]~6645_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[5][0]~6643_combout\ & (!\regs|lsr0r~133_combout\ # !\regs|receiver|fifo_rx|fifo[5][0]~6644_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110111001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[5][0]~6644_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|receiver|fifo_rx|fifo[5][0]~6643_combout\,
	datad => \regs|lsr0r~133_combout\,
	combout => \regs|receiver|fifo_rx|fifo[5][0]~6645_combout\);

\regs|receiver|fifo_rx|fifo[5][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[5][0]~6645_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[5][0]~regout\);

\regs|receiver|fifo_rx|Mux63~63\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux63~63_combout\ = \regs|receiver|fifo_rx|bottom\(0) & (\regs|receiver|fifo_rx|bottom\(1) # \regs|receiver|fifo_rx|fifo[5][0]~regout\) # !\regs|receiver|fifo_rx|bottom\(0) & !\regs|receiver|fifo_rx|bottom\(1) & 
-- \regs|receiver|fifo_rx|fifo[4][0]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(0),
	datab => \regs|receiver|fifo_rx|bottom\(1),
	datac => \regs|receiver|fifo_rx|fifo[4][0]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[5][0]~regout\,
	combout => \regs|receiver|fifo_rx|Mux63~63_combout\);

\regs|receiver|fifo_rx|Mux63~64\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux63~64_combout\ = \regs|receiver|fifo_rx|bottom\(1) & (\regs|receiver|fifo_rx|Mux63~63_combout\ & (\regs|receiver|fifo_rx|fifo[7][0]~regout\) # !\regs|receiver|fifo_rx|Mux63~63_combout\ & \regs|receiver|fifo_rx|fifo[6][0]~regout\) 
-- # !\regs|receiver|fifo_rx|bottom\(1) & (\regs|receiver|fifo_rx|Mux63~63_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[6][0]~regout\,
	datab => \regs|receiver|fifo_rx|bottom\(1),
	datac => \regs|receiver|fifo_rx|fifo[7][0]~regout\,
	datad => \regs|receiver|fifo_rx|Mux63~63_combout\,
	combout => \regs|receiver|fifo_rx|Mux63~64_combout\);

\regs|receiver|fifo_rx|fifo[0][1]~6670\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[0][1]~6670_combout\ = \regs|receiver|rf_push_pulse~combout\ & (!\regs|rf_pop~regout\ & \regs|receiver|fifo_rx|count\(4) # !\regs|receiver|fifo_rx|Decoder1~282_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111010100110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder1~282_combout\,
	datab => \regs|rf_pop~regout\,
	datac => \regs|receiver|fifo_rx|count\(4),
	datad => \regs|receiver|rf_push_pulse~combout\,
	combout => \regs|receiver|fifo_rx|fifo[0][1]~6670_combout\);

\regs|receiver|fifo_rx|fifo[0][1]~6671\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[0][1]~6671_combout\ = !\regs|receiver|fifo_rx|count\(0) & !\regs|receiver|fifo_rx|count\(4) & \regs|lsr0r~131_combout\ # !\regs|receiver|fifo_rx|Decoder0~282_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101011101010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder0~282_combout\,
	datab => \regs|receiver|fifo_rx|count\(0),
	datac => \regs|receiver|fifo_rx|count\(4),
	datad => \regs|lsr0r~131_combout\,
	combout => \regs|receiver|fifo_rx|fifo[0][1]~6671_combout\);

\regs|receiver|fifo_rx|fifo[0][1]~6672\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[0][1]~6672_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[0][1]~6670_combout\ & (!\regs|receiver|fifo_rx|fifo[0][1]~6671_combout\ # !\regs|lsr0r~133_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110111001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr0r~133_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|receiver|fifo_rx|fifo[0][1]~6670_combout\,
	datad => \regs|receiver|fifo_rx|fifo[0][1]~6671_combout\,
	combout => \regs|receiver|fifo_rx|fifo[0][1]~6672_combout\);

\regs|receiver|fifo_rx|fifo[0][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[0][1]~6672_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[0][0]~regout\);

\regs|receiver|fifo_rx|fifo[1][1]~6646\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[1][1]~6646_combout\ = \regs|receiver|rf_push_pulse~combout\ & (!\regs|rf_pop~regout\ & \regs|receiver|fifo_rx|count\(4) # !\regs|receiver|fifo_rx|Decoder1~274_combout\) # !\regs|receiver|rf_push_pulse~combout\ & 
-- (!\regs|rf_pop~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111001101010011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Decoder1~274_combout\,
	datab => \regs|rf_pop~regout\,
	datac => \regs|receiver|rf_push_pulse~combout\,
	datad => \regs|receiver|fifo_rx|count\(4),
	combout => \regs|receiver|fifo_rx|fifo[1][1]~6646_combout\);

\regs|receiver|fifo_rx|fifo[1][1]~6648\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[1][1]~6648_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[1][1]~6646_combout\ & (!\regs|lsr0r~133_combout\ # !\regs|receiver|fifo_rx|fifo[1][1]~6647_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011011111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[1][1]~6647_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|lsr0r~133_combout\,
	datad => \regs|receiver|fifo_rx|fifo[1][1]~6646_combout\,
	combout => \regs|receiver|fifo_rx|fifo[1][1]~6648_combout\);

\regs|receiver|fifo_rx|fifo[1][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[1][1]~6648_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[1][0]~regout\);

\regs|receiver|fifo_rx|Mux63~65\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux63~65_combout\ = \regs|receiver|fifo_rx|bottom\(0) & (\regs|receiver|fifo_rx|bottom\(1) # \regs|receiver|fifo_rx|fifo[1][0]~regout\) # !\regs|receiver|fifo_rx|bottom\(0) & !\regs|receiver|fifo_rx|bottom\(1) & 
-- \regs|receiver|fifo_rx|fifo[0][0]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(0),
	datab => \regs|receiver|fifo_rx|bottom\(1),
	datac => \regs|receiver|fifo_rx|fifo[0][0]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[1][0]~regout\,
	combout => \regs|receiver|fifo_rx|Mux63~65_combout\);

\regs|receiver|fifo_rx|fifo[2][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[2][2]~6660_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[2][0]~regout\);

\regs|receiver|fifo_rx|Mux63~66\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux63~66_combout\ = \regs|receiver|fifo_rx|Mux63~65_combout\ & (\regs|receiver|fifo_rx|fifo[3][0]~regout\ # !\regs|receiver|fifo_rx|bottom\(1)) # !\regs|receiver|fifo_rx|Mux63~65_combout\ & (\regs|receiver|fifo_rx|fifo[2][0]~regout\ 
-- & \regs|receiver|fifo_rx|bottom\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[3][0]~regout\,
	datab => \regs|receiver|fifo_rx|Mux63~65_combout\,
	datac => \regs|receiver|fifo_rx|fifo[2][0]~regout\,
	datad => \regs|receiver|fifo_rx|bottom\(1),
	combout => \regs|receiver|fifo_rx|Mux63~66_combout\);

\regs|receiver|fifo_rx|Mux63~67\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux63~67_combout\ = \regs|receiver|fifo_rx|bottom\(2) & (\regs|receiver|fifo_rx|bottom\(3) # \regs|receiver|fifo_rx|Mux63~64_combout\) # !\regs|receiver|fifo_rx|bottom\(2) & !\regs|receiver|fifo_rx|bottom\(3) & 
-- (\regs|receiver|fifo_rx|Mux63~66_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100110101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(2),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|Mux63~64_combout\,
	datad => \regs|receiver|fifo_rx|Mux63~66_combout\,
	combout => \regs|receiver|fifo_rx|Mux63~67_combout\);

\regs|receiver|fifo_rx|Decoder0~272\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Decoder0~272_combout\ = !\regs|receiver|fifo_rx|bottom\(1) & \regs|receiver|fifo_rx|bottom\(3) & !\regs|receiver|fifo_rx|bottom\(2) & \regs|receiver|fifo_rx|bottom\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(3),
	datac => \regs|receiver|fifo_rx|bottom\(2),
	datad => \regs|receiver|fifo_rx|bottom\(0),
	combout => \regs|receiver|fifo_rx|Decoder0~272_combout\);

\regs|receiver|fifo_rx|fifo[9][2]~6641\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[9][2]~6641_combout\ = !\regs|receiver|fifo_rx|count\(4) & !\regs|receiver|fifo_rx|count\(0) & \regs|lsr0r~131_combout\ # !\regs|receiver|fifo_rx|Decoder0~272_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011011100110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|count\(4),
	datab => \regs|receiver|fifo_rx|Decoder0~272_combout\,
	datac => \regs|receiver|fifo_rx|count\(0),
	datad => \regs|lsr0r~131_combout\,
	combout => \regs|receiver|fifo_rx|fifo[9][2]~6641_combout\);

\regs|receiver|fifo_rx|fifo[9][2]~6642\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[9][2]~6642_combout\ = \regs|rx_reset~regout\ # !\regs|receiver|fifo_rx|fifo[9][2]~6640_combout\ & (!\regs|lsr0r~133_combout\ # !\regs|receiver|fifo_rx|fifo[9][2]~6641_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110111011101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[9][2]~6640_combout\,
	datab => \regs|rx_reset~regout\,
	datac => \regs|receiver|fifo_rx|fifo[9][2]~6641_combout\,
	datad => \regs|lsr0r~133_combout\,
	combout => \regs|receiver|fifo_rx|fifo[9][2]~6642_combout\);

\regs|receiver|fifo_rx|fifo[9][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[9][2]~6642_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[9][0]~regout\);

\regs|receiver|fifo_rx|fifo[8][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6688_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[8][0]~6666_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[8][0]~regout\);

\regs|receiver|fifo_rx|fifo[10][0]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo[10][0]~feeder_combout\ = \regs|receiver|fifo_rx|fifo~6688_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \regs|receiver|fifo_rx|fifo~6688_combout\,
	combout => \regs|receiver|fifo_rx|fifo[10][0]~feeder_combout\);

\regs|receiver|fifo_rx|fifo[10][0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|fifo[10][0]~feeder_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|fifo_rx|fifo[10][2]~6657_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[10][0]~regout\);

\regs|receiver|fifo_rx|Mux63~61\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux63~61_combout\ = \regs|receiver|fifo_rx|bottom\(1) & (\regs|receiver|fifo_rx|bottom\(0) # \regs|receiver|fifo_rx|fifo[10][0]~regout\) # !\regs|receiver|fifo_rx|bottom\(1) & !\regs|receiver|fifo_rx|bottom\(0) & 
-- \regs|receiver|fifo_rx|fifo[8][0]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101010011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(1),
	datab => \regs|receiver|fifo_rx|bottom\(0),
	datac => \regs|receiver|fifo_rx|fifo[8][0]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[10][0]~regout\,
	combout => \regs|receiver|fifo_rx|Mux63~61_combout\);

\regs|receiver|fifo_rx|Mux63~62\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux63~62_combout\ = \regs|receiver|fifo_rx|bottom\(0) & (\regs|receiver|fifo_rx|Mux63~61_combout\ & \regs|receiver|fifo_rx|fifo[11][0]~regout\ # !\regs|receiver|fifo_rx|Mux63~61_combout\ & 
-- (\regs|receiver|fifo_rx|fifo[9][0]~regout\)) # !\regs|receiver|fifo_rx|bottom\(0) & (\regs|receiver|fifo_rx|Mux63~61_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[11][0]~regout\,
	datab => \regs|receiver|fifo_rx|bottom\(0),
	datac => \regs|receiver|fifo_rx|fifo[9][0]~regout\,
	datad => \regs|receiver|fifo_rx|Mux63~61_combout\,
	combout => \regs|receiver|fifo_rx|Mux63~62_combout\);

\regs|receiver|fifo_rx|Mux63~70\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|Mux63~70_combout\ = \regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|Mux63~67_combout\ & \regs|receiver|fifo_rx|Mux63~69_combout\ # !\regs|receiver|fifo_rx|Mux63~67_combout\ & (\regs|receiver|fifo_rx|Mux63~62_combout\)) # 
-- !\regs|receiver|fifo_rx|bottom\(3) & (\regs|receiver|fifo_rx|Mux63~67_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101101011010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|bottom\(3),
	datab => \regs|receiver|fifo_rx|Mux63~69_combout\,
	datac => \regs|receiver|fifo_rx|Mux63~67_combout\,
	datad => \regs|receiver|fifo_rx|Mux63~62_combout\,
	combout => \regs|receiver|fifo_rx|Mux63~70_combout\);

\regs|lsr3_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|Mux63~70_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr3_d~regout\);

\regs|lsr3r~34\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr3r~34_combout\ = \regs|lsr_mask~combout\ & (\regs|lsr3r~regout\ # \regs|receiver|fifo_rx|Mux63~70_combout\ & !\regs|lsr3_d~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|Mux63~70_combout\,
	datab => \regs|lsr3_d~regout\,
	datac => \regs|lsr3r~regout\,
	datad => \regs|lsr_mask~combout\,
	combout => \regs|lsr3r~34_combout\);

\regs|lsr3r\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr3r~34_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr3r~regout\);

\regs|transmitter|fifo_tx|count[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|count[0]~330_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|tx_reset~regout\,
	ena => \regs|transmitter|fifo_tx|count[3]~332_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|count\(0));

\wb_interface|Mux28~199\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux28~199_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|transmitter|fifo_tx|count\(0)) # !\wb_interface|wb_adr_is\(2) & \regs|lsr3r~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100100001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_is\(2),
	datab => \dbg|Equal0~38_combout\,
	datac => \regs|lsr3r~regout\,
	datad => \regs|transmitter|fifo_tx|count\(0),
	combout => \wb_interface|Mux28~199_combout\);

\regs|scratch[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux36~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always8~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|scratch\(3));

\regs|iir~319\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|iir~319_combout\ = \regs|ti_int_pnd~regout\ & !\regs|rls_int_pnd~regout\ & !\regs|rda_int~272_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|ti_int_pnd~regout\,
	datac => \regs|rls_int_pnd~regout\,
	datad => \regs|rda_int~272_combout\,
	combout => \regs|iir~319_combout\);

\regs|iir[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|iir~319_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|iir\(3));

\regs|ier[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux36~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|ier[0]~62_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|ier\(3));

\regs|Mux4~91\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux4~91_combout\ = \regs|Mux7~340_combout\ & (\regs|lsr3r~regout\ # \regs|Mux7~341_combout\) # !\regs|Mux7~340_combout\ & (\regs|ier\(3) & !\regs|Mux7~341_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110010111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr3r~regout\,
	datab => \regs|Mux7~340_combout\,
	datac => \regs|ier\(3),
	datad => \regs|Mux7~341_combout\,
	combout => \regs|Mux4~91_combout\);

\regs|Mux4~92\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux4~92_combout\ = \regs|Mux7~341_combout\ & (\regs|Mux4~91_combout\ & \regs|lcr\(3) # !\regs|Mux4~91_combout\ & (\regs|dl\(11))) # !\regs|Mux7~341_combout\ & (\regs|Mux4~91_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(3),
	datab => \regs|Mux7~341_combout\,
	datac => \regs|dl\(11),
	datad => \regs|Mux4~91_combout\,
	combout => \regs|Mux4~92_combout\);

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(6),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(12));

\regs|Mux4~88\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux4~88_combout\ = \regs|lcr\(7) & \regs|dl\(3) # !\regs|lcr\(7) & (\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(12))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(3),
	datac => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(12),
	datad => \regs|lcr\(7),
	combout => \regs|Mux4~88_combout\);

\regs|Mux4~89\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux4~89_combout\ = \regs|Mux7~335_combout\ & (\regs|lcr\(7) # \regs|receiver|fifo_rx|rfifo|ram~15_regout\) # !\regs|Mux7~335_combout\ & (\regs|Mux4~88_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111111100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(7),
	datab => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	datac => \regs|Mux7~335_combout\,
	datad => \regs|Mux4~88_combout\,
	combout => \regs|Mux4~89_combout\);

\regs|receiver|fifo_rx|rfifo|ram~22\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(6),
	sload => VCC,
	ena => \regs|receiver|fifo_rx|rfifo|ram~145_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram~22_regout\);

\regs|Mux4~90\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux4~90_combout\ = \regs|Mux7~335_combout\ & (\regs|Mux4~89_combout\ & (\regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(3)) # !\regs|Mux4~89_combout\ & \regs|receiver|fifo_rx|rfifo|ram~22_regout\) # !\regs|Mux7~335_combout\ & 
-- \regs|Mux4~89_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110001100100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~335_combout\,
	datab => \regs|Mux4~89_combout\,
	datac => \regs|receiver|fifo_rx|rfifo|ram~22_regout\,
	datad => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(3),
	combout => \regs|Mux4~90_combout\);

\regs|Mux4~93\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux4~93_combout\ = \regs|Mux7~344_combout\ & (\regs|Mux7~345_combout\ & \regs|Mux4~92_combout\ # !\regs|Mux7~345_combout\ & (\regs|Mux4~90_combout\)) # !\regs|Mux7~344_combout\ & (\regs|Mux7~345_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101101011010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~344_combout\,
	datab => \regs|Mux4~92_combout\,
	datac => \regs|Mux7~345_combout\,
	datad => \regs|Mux4~90_combout\,
	combout => \regs|Mux4~93_combout\);

\regs|Mux4~94\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux4~94_combout\ = \regs|msr_read~19_combout\ & (\regs|Mux4~93_combout\ & \regs|msr\(3) # !\regs|Mux4~93_combout\ & (\regs|iir\(3))) # !\regs|msr_read~19_combout\ & (\regs|Mux4~93_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|msr\(3),
	datab => \regs|msr_read~19_combout\,
	datac => \regs|iir\(3),
	datad => \regs|Mux4~93_combout\,
	combout => \regs|Mux4~94_combout\);

\regs|Mux4~95\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux4~95_combout\ = \wb_interface|wb_adr_is\(2) & (\regs|always4~27_combout\ & \regs|scratch\(3) # !\regs|always4~27_combout\ & (\regs|Mux4~94_combout\)) # !\wb_interface|wb_adr_is\(2) & (\regs|Mux4~94_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111011110000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_is\(2),
	datab => \regs|always4~27_combout\,
	datac => \regs|scratch\(3),
	datad => \regs|Mux4~94_combout\,
	combout => \regs|Mux4~95_combout\);

\wb_interface|Mux28~200\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux28~200_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux28~199_combout\ # \wb_interface|Mux31~219_combout\ & \regs|Mux4~95_combout\) # !\wb_interface|Mux31~216_combout\ & \wb_interface|Mux31~219_combout\ & 
-- (\regs|Mux4~95_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux31~219_combout\,
	datac => \wb_interface|Mux28~199_combout\,
	datad => \regs|Mux4~95_combout\,
	combout => \wb_interface|Mux28~200_combout\);

\wb_interface|wb_dat_o[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux28~200_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(3));

\regs|transmitter|fifo_tx|count[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|count[1]~333_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sclr => \regs|tx_reset~regout\,
	ena => \regs|transmitter|fifo_tx|count[3]~332_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|count\(1));

\wb_interface|Mux27~250\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux27~250_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|transmitter|fifo_tx|count\(1)) # !\wb_interface|wb_adr_is\(2) & \regs|lsr4r~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr4r~regout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|transmitter|fifo_tx|count\(1),
	datad => \dbg|Equal0~38_combout\,
	combout => \wb_interface|Mux27~250_combout\);

\regs|Mux3~112\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux3~112_combout\ = !\wb_interface|wb_adr_int[0]~64_combout\ & (\wb_interface|wb_adr_is\(2) $ !\wb_interface|wb_adr_int[1]~63_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000000000011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \wb_interface|wb_adr_int[0]~64_combout\,
	datac => \wb_interface|wb_adr_is\(2),
	datad => \wb_interface|wb_adr_int[1]~63_combout\,
	combout => \regs|Mux3~112_combout\);

\regs|cts_c~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|cts_c~9_combout\ = \regs|mcr\(4) & \regs|mcr\(1) # !\regs|mcr\(4) & (\cts_pad_i~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|mcr\(1),
	datab => \cts_pad_i~combout\,
	datad => \regs|mcr\(4),
	combout => \regs|cts_c~9_combout\);

\regs|msr[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|cts_c~9_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|msr\(4));

\regs|Mux3~106\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux3~106_combout\ = \wb_interface|wb_adr_is\(2) & \wb_interface|wb_adr_int[1]~63_combout\ & !\wb_interface|wb_adr_int[0]~64_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_is\(2),
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datad => \wb_interface|wb_adr_int[0]~64_combout\,
	combout => \regs|Mux3~106_combout\);

\regs|Mux3~109\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux3~109_combout\ = \regs|Mux3~108_combout\ & (\wb_interface|wb_adr_int[0]~64_combout\ # \regs|msr\(4) & \regs|Mux3~106_combout\) # !\regs|Mux3~108_combout\ & (\regs|msr\(4) & \regs|Mux3~106_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux3~108_combout\,
	datab => \wb_interface|wb_adr_int[0]~64_combout\,
	datac => \regs|msr\(4),
	datad => \regs|Mux3~106_combout\,
	combout => \regs|Mux3~109_combout\);

\regs|receiver|fifo_rx|rfifo|ram~24\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(7),
	sload => VCC,
	ena => \regs|receiver|fifo_rx|rfifo|ram~145_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram~24_regout\);

\regs|Mux7~336\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux7~336_combout\ = \regs|lcr\(7) # \regs|Mux7~335_combout\ & \regs|receiver|fifo_rx|rfifo|ram~15_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|lcr\(7),
	datac => \regs|Mux7~335_combout\,
	datad => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	combout => \regs|Mux7~336_combout\);

\regs|Mux3~110\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux3~110_combout\ = \regs|Mux7~335_combout\ & (\regs|receiver|fifo_rx|rfifo|ram~24_regout\ # \regs|Mux7~336_combout\) # !\regs|Mux7~335_combout\ & \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(13) & (!\regs|Mux7~336_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(13),
	datab => \regs|Mux7~335_combout\,
	datac => \regs|receiver|fifo_rx|rfifo|ram~24_regout\,
	datad => \regs|Mux7~336_combout\,
	combout => \regs|Mux3~110_combout\);

\regs|Mux3~111\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux3~111_combout\ = \regs|Mux7~336_combout\ & (\regs|Mux3~110_combout\ & \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(4) # !\regs|Mux3~110_combout\ & (\regs|dl\(4))) # !\regs|Mux7~336_combout\ & (\regs|Mux3~110_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~336_combout\,
	datab => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(4),
	datac => \regs|dl\(4),
	datad => \regs|Mux3~110_combout\,
	combout => \regs|Mux3~111_combout\);

\regs|Mux3~113\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux3~113_combout\ = \regs|Mux3~109_combout\ # !\wb_interface|wb_adr_int[1]~63_combout\ & \regs|Mux3~112_combout\ & \regs|Mux3~111_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_int[1]~63_combout\,
	datab => \regs|Mux3~112_combout\,
	datac => \regs|Mux3~109_combout\,
	datad => \regs|Mux3~111_combout\,
	combout => \regs|Mux3~113_combout\);

\wb_interface|Mux27~251\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux27~251_combout\ = \wb_interface|wb_sel_is\(1) & (\wb_interface|Mux27~250_combout\) # !\wb_interface|wb_sel_is\(1) & \regs|always7~19_combout\ & (\regs|Mux3~113_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100101011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|always7~19_combout\,
	datab => \wb_interface|Mux27~250_combout\,
	datac => \wb_interface|wb_sel_is\(1),
	datad => \regs|Mux3~113_combout\,
	combout => \wb_interface|Mux27~251_combout\);

\wb_interface|Mux27~252\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux27~252_combout\ = !\wb_interface|wb_dat_o[2]~538_combout\ & \wb_interface|Mux27~251_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|wb_dat_o[2]~538_combout\,
	datad => \wb_interface|Mux27~251_combout\,
	combout => \wb_interface|Mux27~252_combout\);

\wb_interface|wb_dat_o[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux27~252_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(4));

\wb_interface|Mux26~251\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux26~251_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|transmitter|fifo_tx|count\(2)) # !\wb_interface|wb_adr_is\(2) & !\regs|lsr5r~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr5r~regout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \dbg|Equal0~38_combout\,
	datad => \regs|transmitter|fifo_tx|count\(2),
	combout => \wb_interface|Mux26~251_combout\);

\regs|dsr_c~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dsr_c~9_combout\ = \regs|mcr\(4) & \regs|dtr_pad_o~regout\ # !\regs|mcr\(4) & (\dsr_pad_i~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dtr_pad_o~regout\,
	datab => \dsr_pad_i~combout\,
	datad => \regs|mcr\(4),
	combout => \regs|dsr_c~9_combout\);

\regs|msr[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dsr_c~9_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|msr\(5));

\regs|lcr[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux34~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lcr\(5));

\regs|scratch[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux34~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always8~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|scratch\(5));

\regs|dl[13]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux34~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[8]~299_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(13));

\regs|Mux0~211\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux0~211_combout\ = !\wb_interface|wb_adr_int[1]~63_combout\ & (\regs|lcr\(7) # \wb_interface|wb_adr_is\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \regs|lcr\(7),
	datad => \wb_interface|wb_adr_is\(2),
	combout => \regs|Mux0~211_combout\);

\regs|Mux2~100\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux2~100_combout\ = \wb_interface|wb_adr_is\(2) & (!\regs|Mux0~211_combout\ # !\regs|lsr5r~regout\) # !\wb_interface|wb_adr_is\(2) & (\regs|dl\(13) & \regs|Mux0~211_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111010011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr5r~regout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|dl\(13),
	datad => \regs|Mux0~211_combout\,
	combout => \regs|Mux2~100_combout\);

\regs|Mux2~101\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux2~101_combout\ = \wb_interface|wb_adr_int[1]~63_combout\ & (\regs|Mux2~100_combout\ & (\regs|scratch\(5)) # !\regs|Mux2~100_combout\ & \regs|lcr\(5)) # !\wb_interface|wb_adr_int[1]~63_combout\ & (\regs|Mux2~100_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_int[1]~63_combout\,
	datab => \regs|lcr\(5),
	datac => \regs|scratch\(5),
	datad => \regs|Mux2~100_combout\,
	combout => \regs|Mux2~101_combout\);

\regs|Mux2~102\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux2~102_combout\ = \wb_interface|wb_adr_int[0]~64_combout\ & (\regs|Mux2~101_combout\ # \regs|msr\(5) & \regs|Mux3~106_combout\) # !\wb_interface|wb_adr_int[0]~64_combout\ & \regs|msr\(5) & (\regs|Mux3~106_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_int[0]~64_combout\,
	datab => \regs|msr\(5),
	datac => \regs|Mux2~101_combout\,
	datad => \regs|Mux3~106_combout\,
	combout => \regs|Mux2~102_combout\);

\regs|receiver|fifo_rx|rfifo|ram~26\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(8),
	sload => VCC,
	ena => \regs|receiver|fifo_rx|rfifo|ram~145_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram~26_regout\);

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[14]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(8),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(14));

\regs|Mux2~103\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux2~103_combout\ = \regs|Mux7~335_combout\ & (\regs|Mux7~336_combout\) # !\regs|Mux7~335_combout\ & (\regs|Mux7~336_combout\ & \regs|dl\(5) # !\regs|Mux7~336_combout\ & (\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(14)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(5),
	datab => \regs|Mux7~335_combout\,
	datac => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(14),
	datad => \regs|Mux7~336_combout\,
	combout => \regs|Mux2~103_combout\);

\regs|Mux2~104\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux2~104_combout\ = \regs|Mux7~335_combout\ & (\regs|Mux2~103_combout\ & \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(5) # !\regs|Mux2~103_combout\ & (\regs|receiver|fifo_rx|rfifo|ram~26_regout\)) # !\regs|Mux7~335_combout\ & 
-- (\regs|Mux2~103_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~335_combout\,
	datab => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(5),
	datac => \regs|receiver|fifo_rx|rfifo|ram~26_regout\,
	datad => \regs|Mux2~103_combout\,
	combout => \regs|Mux2~104_combout\);

\regs|Mux2~105\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux2~105_combout\ = \regs|Mux2~102_combout\ # \regs|Mux3~112_combout\ & !\wb_interface|wb_adr_int[1]~63_combout\ & \regs|Mux2~104_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux3~112_combout\,
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \regs|Mux2~102_combout\,
	datad => \regs|Mux2~104_combout\,
	combout => \regs|Mux2~105_combout\);

\wb_interface|Mux26~253\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux26~253_combout\ = !\wb_interface|wb_adr_is\(4) & !\wb_interface|wb_sel_is\(1) & \regs|Mux2~105_combout\ & !\wb_interface|wb_adr_is\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_is\(4),
	datab => \wb_interface|wb_sel_is\(1),
	datac => \regs|Mux2~105_combout\,
	datad => \wb_interface|wb_adr_is\(3),
	combout => \wb_interface|Mux26~253_combout\);

\wb_interface|Mux26~252\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux26~252_combout\ = !\wb_interface|wb_dat_o[2]~538_combout\ & (\wb_interface|Mux26~253_combout\ # \wb_interface|wb_sel_is\(1) & \wb_interface|Mux26~251_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_o[2]~538_combout\,
	datab => \wb_interface|wb_sel_is\(1),
	datac => \wb_interface|Mux26~251_combout\,
	datad => \wb_interface|Mux26~253_combout\,
	combout => \wb_interface|Mux26~252_combout\);

\wb_interface|wb_dat_o[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux26~252_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(5));

\wb_interface|Mux31~216\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux31~216_combout\ = \wb_interface|wb_sel_is\(0) & \wb_interface|wb_sel_is\(1) & \wb_interface|wb_sel_is\(2) & \wb_interface|wb_sel_is\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_sel_is\(0),
	datab => \wb_interface|wb_sel_is\(1),
	datac => \wb_interface|wb_sel_is\(2),
	datad => \wb_interface|wb_sel_is\(3),
	combout => \wb_interface|Mux31~216_combout\);

\regs|scratch[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux33~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always8~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|scratch\(6));

\regs|dl[14]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux33~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|dl[8]~299_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dl\(14));

\regs|Mux1~160\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux1~160_combout\ = \wb_interface|wb_adr_is\(2) & (!\regs|Mux0~211_combout\ # !\regs|lsr6r~regout\) # !\wb_interface|wb_adr_is\(2) & (\regs|dl\(14) & \regs|Mux0~211_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111010011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr6r~regout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|dl\(14),
	datad => \regs|Mux0~211_combout\,
	combout => \regs|Mux1~160_combout\);

\regs|Mux1~161\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux1~161_combout\ = \wb_interface|wb_adr_int[1]~63_combout\ & (\regs|Mux1~160_combout\ & (\regs|scratch\(6)) # !\regs|Mux1~160_combout\ & \regs|lcr\(6)) # !\wb_interface|wb_adr_int[1]~63_combout\ & (\regs|Mux1~160_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(6),
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \regs|scratch\(6),
	datad => \regs|Mux1~160_combout\,
	combout => \regs|Mux1~161_combout\);

\ri_pad_i~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_ri_pad_i,
	combout => \ri_pad_i~combout\);

\regs|mcr[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux37~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always7~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|mcr\(2));

\regs|ri_c~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ri_c~9_combout\ = \regs|mcr\(4) & (\regs|mcr\(2)) # !\regs|mcr\(4) & \ri_pad_i~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \ri_pad_i~combout\,
	datac => \regs|mcr\(4),
	datad => \regs|mcr\(2),
	combout => \regs|ri_c~9_combout\);

\regs|msr[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|ri_c~9_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|msr\(6));

\regs|receiver|fifo_rx|rfifo|ram~28feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|rfifo|ram~28feeder_combout\ = \regs|receiver|rf_data_in\(9)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \regs|receiver|rf_data_in\(9),
	combout => \regs|receiver|fifo_rx|rfifo|ram~28feeder_combout\);

\regs|receiver|fifo_rx|rfifo|ram~28\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|rfifo|ram~28feeder_combout\,
	ena => \regs|receiver|fifo_rx|rfifo|ram~145_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram~28_regout\);

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[15]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(9),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(15));

\regs|Mux1~162\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux1~162_combout\ = \regs|Mux7~335_combout\ & (\regs|receiver|fifo_rx|rfifo|ram~28_regout\ # \regs|Mux7~336_combout\) # !\regs|Mux7~335_combout\ & (\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(15) & !\regs|Mux7~336_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011011000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~335_combout\,
	datab => \regs|receiver|fifo_rx|rfifo|ram~28_regout\,
	datac => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(15),
	datad => \regs|Mux7~336_combout\,
	combout => \regs|Mux1~162_combout\);

\regs|Mux1~163\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux1~163_combout\ = \regs|Mux7~336_combout\ & (\regs|Mux1~162_combout\ & \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(6) # !\regs|Mux1~162_combout\ & (\regs|dl\(6))) # !\regs|Mux7~336_combout\ & (\regs|Mux1~162_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|Mux7~336_combout\,
	datab => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(6),
	datac => \regs|dl\(6),
	datad => \regs|Mux1~162_combout\,
	combout => \regs|Mux1~163_combout\);

\regs|Mux1~164\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux1~164_combout\ = \wb_interface|wb_adr_is\(2) & \wb_interface|wb_adr_int[1]~63_combout\ & \regs|msr\(6) # !\wb_interface|wb_adr_is\(2) & (\wb_interface|wb_adr_int[1]~63_combout\ # \regs|Mux1~163_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101010111000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_is\(2),
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \regs|msr\(6),
	datad => \regs|Mux1~163_combout\,
	combout => \regs|Mux1~164_combout\);

\regs|Mux1~165\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux1~165_combout\ = \wb_interface|wb_adr_int[0]~64_combout\ & \regs|Mux1~161_combout\ # !\wb_interface|wb_adr_int[0]~64_combout\ & (\regs|Mux1~164_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \wb_interface|wb_adr_int[0]~64_combout\,
	datac => \regs|Mux1~161_combout\,
	datad => \regs|Mux1~164_combout\,
	combout => \regs|Mux1~165_combout\);

\wb_interface|Mux25~212\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux25~212_combout\ = \wb_interface|Mux25~211_combout\ & (\wb_interface|Mux31~216_combout\ # \wb_interface|Mux31~219_combout\ & \regs|Mux1~165_combout\) # !\wb_interface|Mux25~211_combout\ & \wb_interface|Mux31~219_combout\ & 
-- (\regs|Mux1~165_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux25~211_combout\,
	datab => \wb_interface|Mux31~219_combout\,
	datac => \wb_interface|Mux31~216_combout\,
	datad => \regs|Mux1~165_combout\,
	combout => \wb_interface|Mux25~212_combout\);

\wb_interface|wb_dat_o[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux25~212_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(6));

\regs|receiver|fifo_rx|fifo[9][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[9][2]~6642_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[9][1]~regout\);

\regs|receiver|fifo_rx|fifo[5][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[5][0]~6645_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[5][1]~regout\);

\regs|lsr7~552\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~552_combout\ = \regs|receiver|fifo_rx|fifo[1][1]~regout\ # \regs|receiver|fifo_rx|overrun~regout\ # \regs|receiver|fifo_rx|fifo[9][1]~regout\ # \regs|receiver|fifo_rx|fifo[5][1]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[1][1]~regout\,
	datab => \regs|receiver|fifo_rx|overrun~regout\,
	datac => \regs|receiver|fifo_rx|fifo[9][1]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[5][1]~regout\,
	combout => \regs|lsr7~552_combout\);

\regs|receiver|fifo_rx|fifo[7][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[7][0]~6678_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[7][1]~regout\);

\regs|lsr7~555\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~555_combout\ = \regs|receiver|fifo_rx|fifo[12][1]~regout\ # \regs|receiver|fifo_rx|fifo[3][1]~regout\ # \regs|receiver|fifo_rx|fifo[7][1]~regout\ # \regs|receiver|fifo_rx|fifo[11][1]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[12][1]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[3][1]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[7][1]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[11][1]~regout\,
	combout => \regs|lsr7~555_combout\);

\regs|receiver|fifo_rx|fifo[4][1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6639_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[4][2]~6669_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[4][1]~regout\);

\regs|lsr7~554\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~554_combout\ = \regs|receiver|fifo_rx|fifo[0][1]~regout\ # \regs|receiver|fifo_rx|fifo[4][1]~regout\ # \regs|receiver|fifo_rx|fifo[14][1]~regout\ # \regs|receiver|fifo_rx|fifo[8][1]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[0][1]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[4][1]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[14][1]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[8][1]~regout\,
	combout => \regs|lsr7~554_combout\);

\regs|lsr7~556\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~556_combout\ = \regs|lsr7~553_combout\ # \regs|lsr7~552_combout\ # \regs|lsr7~555_combout\ # \regs|lsr7~554_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr7~553_combout\,
	datab => \regs|lsr7~552_combout\,
	datac => \regs|lsr7~555_combout\,
	datad => \regs|lsr7~554_combout\,
	combout => \regs|lsr7~556_combout\);

\regs|receiver|Selector11~33\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Selector11~33_combout\ = \regs|receiver|rstate\(1) & !\regs|receiver|rstate\(0) & !\regs|receiver|rstate\(2) & \regs|receiver|rstate\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rstate\(1),
	datab => \regs|receiver|rstate\(0),
	datac => \regs|receiver|rstate\(2),
	datad => \regs|receiver|rstate\(3),
	combout => \regs|receiver|Selector11~33_combout\);

\regs|receiver|rf_data_in[2]~636\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rf_data_in[2]~636_combout\ = \regs|receiver|rframing_error~regout\ & \regs|receiver|Selector11~33_combout\ & !\regs|serial_in~34_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rframing_error~regout\,
	datac => \regs|receiver|Selector11~33_combout\,
	datad => \regs|serial_in~34_combout\,
	combout => \regs|receiver|rf_data_in[2]~636_combout\);

\regs|receiver|rf_data_in[2]~637\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|rf_data_in[2]~637_combout\ = \regs|receiver|rf_data_in[2]~635_combout\ # \regs|receiver|rf_data_in\(2) & (\regs|receiver|rf_data_in[2]~636_combout\ # !\regs|receiver|rf_data_in[0]~633_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101010111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|rf_data_in[2]~635_combout\,
	datab => \regs|receiver|rf_data_in[0]~633_combout\,
	datac => \regs|receiver|rf_data_in\(2),
	datad => \regs|receiver|rf_data_in[2]~636_combout\,
	combout => \regs|receiver|rf_data_in[2]~637_combout\);

\regs|receiver|rf_data_in[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|rf_data_in[2]~637_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|rf_data_in\(2));

\regs|receiver|fifo_rx|fifo~6689\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|fifo_rx|fifo~6689_combout\ = \regs|receiver|rf_data_in\(2) & !\regs|lsr0r~133_combout\ & !\regs|rx_reset~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|rf_data_in\(2),
	datac => \regs|lsr0r~133_combout\,
	datad => \regs|rx_reset~regout\,
	combout => \regs|receiver|fifo_rx|fifo~6689_combout\);

\regs|receiver|fifo_rx|fifo[15][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|receiver|fifo_rx|fifo[15][0]~6687_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[15][2]~regout\);

\regs|receiver|fifo_rx|fifo[1][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[1][1]~6648_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[1][2]~regout\);

\regs|receiver|fifo_rx|fifo[5][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[5][0]~6645_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[5][2]~regout\);

\regs|receiver|fifo_rx|fifo[9][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[9][2]~6642_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[9][2]~regout\);

\regs|lsr7~563\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~563_combout\ = \regs|receiver|fifo_rx|fifo[14][2]~regout\ # \regs|receiver|fifo_rx|fifo[1][2]~regout\ # \regs|receiver|fifo_rx|fifo[5][2]~regout\ # \regs|receiver|fifo_rx|fifo[9][2]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[14][2]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[1][2]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[5][2]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[9][2]~regout\,
	combout => \regs|lsr7~563_combout\);

\regs|receiver|fifo_rx|fifo[6][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[6][1]~6654_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[6][2]~regout\);

\regs|receiver|fifo_rx|fifo[2][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[2][2]~6660_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[2][2]~regout\);

\regs|receiver|fifo_rx|fifo[10][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[10][2]~6657_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[10][2]~regout\);

\regs|lsr7~562\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~562_combout\ = \regs|receiver|fifo_rx|fifo[15][0]~regout\ # \regs|receiver|fifo_rx|fifo[6][2]~regout\ # \regs|receiver|fifo_rx|fifo[2][2]~regout\ # \regs|receiver|fifo_rx|fifo[10][2]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[15][0]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[6][2]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[2][2]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[10][2]~regout\,
	combout => \regs|lsr7~562_combout\);

\regs|receiver|fifo_rx|fifo[7][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[7][0]~6678_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[7][2]~regout\);

\regs|receiver|fifo_rx|fifo[11][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[11][0]~6681_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[11][2]~regout\);

\regs|receiver|fifo_rx|fifo[3][2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|fifo_rx|fifo~6689_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|receiver|fifo_rx|fifo[3][2]~6684_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|fifo[3][2]~regout\);

\regs|lsr7~565\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~565_combout\ = \regs|receiver|fifo_rx|fifo[12][2]~regout\ # \regs|receiver|fifo_rx|fifo[7][2]~regout\ # \regs|receiver|fifo_rx|fifo[11][2]~regout\ # \regs|receiver|fifo_rx|fifo[3][2]~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|fifo[12][2]~regout\,
	datab => \regs|receiver|fifo_rx|fifo[7][2]~regout\,
	datac => \regs|receiver|fifo_rx|fifo[11][2]~regout\,
	datad => \regs|receiver|fifo_rx|fifo[3][2]~regout\,
	combout => \regs|lsr7~565_combout\);

\regs|lsr7~566\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~566_combout\ = \regs|lsr7~564_combout\ # \regs|lsr7~563_combout\ # \regs|lsr7~562_combout\ # \regs|lsr7~565_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr7~564_combout\,
	datab => \regs|lsr7~563_combout\,
	datac => \regs|lsr7~562_combout\,
	datad => \regs|lsr7~565_combout\,
	combout => \regs|lsr7~566_combout\);

\regs|lsr7~567\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7~567_combout\ = \regs|lsr7~561_combout\ # \regs|lsr7~556_combout\ # \regs|receiver|fifo_rx|fifo[15][2]~regout\ # \regs|lsr7~566_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr7~561_combout\,
	datab => \regs|lsr7~556_combout\,
	datac => \regs|receiver|fifo_rx|fifo[15][2]~regout\,
	datad => \regs|lsr7~566_combout\,
	combout => \regs|lsr7~567_combout\);

\regs|lsr7_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr7~567_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr7_d~regout\);

\regs|lsr7r~29\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr7r~29_combout\ = \regs|lsr_mask~combout\ & (\regs|lsr7r~regout\ # \regs|lsr7~567_combout\ & !\regs|lsr7_d~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr7~567_combout\,
	datab => \regs|lsr7_d~regout\,
	datac => \regs|lsr7r~regout\,
	datad => \regs|lsr_mask~combout\,
	combout => \regs|lsr7r~29_combout\);

\regs|lsr7r\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr7r~29_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr7r~regout\);

\wb_interface|Mux24~211\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux24~211_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|transmitter|fifo_tx|count\(4)) # !\wb_interface|wb_adr_is\(2) & \regs|lsr7r~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100100001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_is\(2),
	datab => \dbg|Equal0~38_combout\,
	datac => \regs|lsr7r~regout\,
	datad => \regs|transmitter|fifo_tx|count\(4),
	combout => \wb_interface|Mux24~211_combout\);

\regs|scratch[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux32~228_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always8~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|scratch\(7));

\regs|Mux0~212\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux0~212_combout\ = \wb_interface|wb_adr_is\(2) & (\regs|lsr7r~regout\ # !\regs|Mux0~211_combout\) # !\wb_interface|wb_adr_is\(2) & (\regs|dl\(15) & \regs|Mux0~211_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011100011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr7r~regout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|dl\(15),
	datad => \regs|Mux0~211_combout\,
	combout => \regs|Mux0~212_combout\);

\regs|Mux0~213\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux0~213_combout\ = \wb_interface|wb_adr_int[1]~63_combout\ & (\regs|Mux0~212_combout\ & (\regs|scratch\(7)) # !\regs|Mux0~212_combout\ & \regs|lcr\(7)) # !\wb_interface|wb_adr_int[1]~63_combout\ & (\regs|Mux0~212_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(7),
	datab => \wb_interface|wb_adr_int[1]~63_combout\,
	datac => \regs|scratch\(7),
	datad => \regs|Mux0~212_combout\,
	combout => \regs|Mux0~213_combout\);

\regs|mcr[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux36~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always7~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|mcr\(3));

\dcd_pad_i~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_dcd_pad_i,
	combout => \dcd_pad_i~combout\);

\regs|dcd_c~9\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|dcd_c~9_combout\ = \regs|mcr\(4) & \regs|mcr\(3) # !\regs|mcr\(4) & (\dcd_pad_i~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|mcr\(4),
	datac => \regs|mcr\(3),
	datad => \dcd_pad_i~combout\,
	combout => \regs|dcd_c~9_combout\);

\regs|msr[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|dcd_c~9_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|msr\(7));

\regs|receiver|fifo_rx|rfifo|ram~30\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(10),
	sload => VCC,
	ena => \regs|receiver|fifo_rx|rfifo|ram~145_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram~30_regout\);

\regs|receiver|fifo_rx|rfifo|ram_0_bypass[16]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|receiver|rf_data_in\(10),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(16));

\regs|Mux0~214\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux0~214_combout\ = \regs|Mux7~335_combout\ & (\regs|Mux7~336_combout\) # !\regs|Mux7~335_combout\ & (\regs|Mux7~336_combout\ & \regs|dl\(7) # !\regs|Mux7~336_combout\ & (\regs|receiver|fifo_rx|rfifo|ram_0_bypass\(16)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|dl\(7),
	datab => \regs|Mux7~335_combout\,
	datac => \regs|receiver|fifo_rx|rfifo|ram_0_bypass\(16),
	datad => \regs|Mux7~336_combout\,
	combout => \regs|Mux0~214_combout\);

\regs|Mux0~215\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux0~215_combout\ = \regs|Mux7~335_combout\ & (\regs|Mux0~214_combout\ & \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(7) # !\regs|Mux0~214_combout\ & (\regs|receiver|fifo_rx|rfifo|ram~30_regout\)) # !\regs|Mux7~335_combout\ & 
-- (\regs|Mux0~214_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011101111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|receiver|fifo_rx|rfifo|ram_rtl_0|auto_generated|q_b\(7),
	datab => \regs|Mux7~335_combout\,
	datac => \regs|receiver|fifo_rx|rfifo|ram~30_regout\,
	datad => \regs|Mux0~214_combout\,
	combout => \regs|Mux0~215_combout\);

\regs|Mux0~216\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux0~216_combout\ = \wb_interface|wb_adr_int[1]~63_combout\ & (\regs|msr\(7) # !\wb_interface|wb_adr_is\(2)) # !\wb_interface|wb_adr_int[1]~63_combout\ & (!\wb_interface|wb_adr_is\(2) & \regs|Mux0~215_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000111110001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_int[1]~63_combout\,
	datab => \regs|msr\(7),
	datac => \wb_interface|wb_adr_is\(2),
	datad => \regs|Mux0~215_combout\,
	combout => \regs|Mux0~216_combout\);

\regs|Mux0~217\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|Mux0~217_combout\ = \wb_interface|wb_adr_int[0]~64_combout\ & \regs|Mux0~213_combout\ # !\wb_interface|wb_adr_int[0]~64_combout\ & (\regs|Mux0~216_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001111000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \wb_interface|wb_adr_int[0]~64_combout\,
	datac => \regs|Mux0~213_combout\,
	datad => \regs|Mux0~216_combout\,
	combout => \regs|Mux0~217_combout\);

\wb_interface|Mux24~212\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux24~212_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux24~211_combout\ # \regs|Mux0~217_combout\ & \wb_interface|Mux31~219_combout\) # !\wb_interface|Mux31~216_combout\ & (\regs|Mux0~217_combout\ & 
-- \wb_interface|Mux31~219_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux24~211_combout\,
	datac => \regs|Mux0~217_combout\,
	datad => \wb_interface|Mux31~219_combout\,
	combout => \wb_interface|Mux24~212_combout\);

\wb_interface|wb_dat_o[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux24~212_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(7));

\wb_interface|Mux31~218\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux31~218_combout\ = \wb_interface|wb_adr_is\(3) # \wb_interface|wb_sel_is\(0) # \wb_interface|wb_adr_is\(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \wb_interface|wb_adr_is\(3),
	datac => \wb_interface|wb_sel_is\(0),
	datad => \wb_interface|wb_adr_is\(4),
	combout => \wb_interface|Mux31~218_combout\);

\wb_interface|Mux23~214\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux23~214_combout\ = !\wb_interface|wb_dat_o[10]~539_combout\ & !\wb_interface|Mux31~218_combout\ & !\wb_interface|wb_sel_is\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_o[10]~539_combout\,
	datab => \wb_interface|Mux31~218_combout\,
	datac => \wb_interface|wb_sel_is\(2),
	combout => \wb_interface|Mux23~214_combout\);

\wb_interface|Mux23~213\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux23~213_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|receiver|rstate\(0)) # !\wb_interface|wb_adr_is\(2) & \regs|ier\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \dbg|Equal0~38_combout\,
	datab => \regs|ier\(0),
	datac => \regs|receiver|rstate\(0),
	datad => \wb_interface|wb_adr_is\(2),
	combout => \wb_interface|Mux23~213_combout\);

\wb_interface|Mux23~215\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux23~215_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux23~213_combout\ # \wb_interface|Mux23~214_combout\ & \regs|Mux7~348_combout\) # !\wb_interface|Mux31~216_combout\ & \wb_interface|Mux23~214_combout\ & 
-- (\regs|Mux7~348_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux23~214_combout\,
	datac => \wb_interface|Mux23~213_combout\,
	datad => \regs|Mux7~348_combout\,
	combout => \wb_interface|Mux23~215_combout\);

\wb_interface|wb_dat_o[8]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux23~215_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(8));

\regs|ier[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux38~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|ier[0]~62_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|ier\(1));

\wb_interface|Mux22~209\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux22~209_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & \regs|receiver|rstate\(1) # !\wb_interface|wb_adr_is\(2) & (\regs|ier\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_is\(2),
	datab => \regs|receiver|rstate\(1),
	datac => \regs|ier\(1),
	datad => \dbg|Equal0~38_combout\,
	combout => \wb_interface|Mux22~209_combout\);

\wb_interface|Mux22~210\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux22~210_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux22~209_combout\ # \wb_interface|Mux23~214_combout\ & \regs|Mux6~104_combout\) # !\wb_interface|Mux31~216_combout\ & \wb_interface|Mux23~214_combout\ & 
-- (\regs|Mux6~104_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux23~214_combout\,
	datac => \wb_interface|Mux22~209_combout\,
	datad => \regs|Mux6~104_combout\,
	combout => \wb_interface|Mux22~210_combout\);

\wb_interface|wb_dat_o[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux22~210_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(9));

\wb_interface|Mux21~209\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux21~209_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|receiver|rstate\(2)) # !\wb_interface|wb_adr_is\(2) & \regs|ier\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100100001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_is\(2),
	datab => \dbg|Equal0~38_combout\,
	datac => \regs|ier\(2),
	datad => \regs|receiver|rstate\(2),
	combout => \wb_interface|Mux21~209_combout\);

\wb_interface|Mux21~210\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux21~210_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux21~209_combout\ # \wb_interface|Mux23~214_combout\ & \regs|Mux5~92_combout\) # !\wb_interface|Mux31~216_combout\ & \wb_interface|Mux23~214_combout\ & 
-- (\regs|Mux5~92_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux23~214_combout\,
	datac => \wb_interface|Mux21~209_combout\,
	datad => \regs|Mux5~92_combout\,
	combout => \wb_interface|Mux21~210_combout\);

\wb_interface|wb_dat_o[10]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux21~210_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(10));

\wb_interface|Mux20~209\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux20~209_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|receiver|rstate\(3)) # !\wb_interface|wb_adr_is\(2) & \regs|ier\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|ier\(3),
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|receiver|rstate\(3),
	datad => \dbg|Equal0~38_combout\,
	combout => \wb_interface|Mux20~209_combout\);

\wb_interface|Mux20~210\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux20~210_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux20~209_combout\ # \wb_interface|Mux23~214_combout\ & \regs|Mux4~95_combout\) # !\wb_interface|Mux31~216_combout\ & (\wb_interface|Mux23~214_combout\ & 
-- \regs|Mux4~95_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux20~209_combout\,
	datac => \wb_interface|Mux23~214_combout\,
	datad => \regs|Mux4~95_combout\,
	combout => \wb_interface|Mux20~210_combout\);

\wb_interface|wb_dat_o[11]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux20~210_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(11));

\wb_interface|wb_dat_o[10]~539\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_o[10]~539_combout\ = \wb_interface|wb_sel_is\(2) & (!\wb_interface|wb_sel_is\(3) # !\wb_interface|wb_sel_is\(0)) # !\wb_interface|wb_sel_is\(2) & (\wb_interface|wb_sel_is\(3)) # !\wb_interface|wb_sel_is\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111111110111011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_sel_is\(2),
	datab => \wb_interface|wb_sel_is\(1),
	datac => \wb_interface|wb_sel_is\(0),
	datad => \wb_interface|wb_sel_is\(3),
	combout => \wb_interface|wb_dat_o[10]~539_combout\);

\regs|delayed_modem_signals[2]~10\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|delayed_modem_signals[2]~10_combout\ = !\ri_pad_i~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \ri_pad_i~combout\,
	combout => \regs|delayed_modem_signals[2]~10_combout\);

\regs|delayed_modem_signals[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|delayed_modem_signals[2]~10_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|delayed_modem_signals\(2));

\regs|msr~174\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|msr~174_combout\ = \regs|msi_reset~regout\ & (\regs|msr\(2) # \ri_pad_i~combout\ $ !\regs|delayed_modem_signals\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100100011000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ri_pad_i~combout\,
	datab => \regs|msi_reset~regout\,
	datac => \regs|msr\(2),
	datad => \regs|delayed_modem_signals\(2),
	combout => \regs|msr~174_combout\);

\regs|msr[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|msr~174_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|msr\(2));

\regs|delayed_modem_signals[3]~11\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|delayed_modem_signals[3]~11_combout\ = !\dcd_pad_i~combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \dcd_pad_i~combout\,
	combout => \regs|delayed_modem_signals[3]~11_combout\);

\regs|delayed_modem_signals[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|delayed_modem_signals[3]~11_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|delayed_modem_signals\(3));

\regs|msr~175\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|msr~175_combout\ = \regs|msi_reset~regout\ & (\regs|msr\(3) # \dcd_pad_i~combout\ $ !\regs|delayed_modem_signals\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100100011000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \dcd_pad_i~combout\,
	datab => \regs|msi_reset~regout\,
	datac => \regs|msr\(3),
	datad => \regs|delayed_modem_signals\(3),
	combout => \regs|msr~175_combout\);

\regs|msr[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|msr~175_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|msr\(3));

\regs|ms_int~35\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ms_int~35_combout\ = \regs|msr\(0) # \regs|msr\(2) # \regs|msr\(3) # \regs|msr\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|msr\(0),
	datab => \regs|msr\(2),
	datac => \regs|msr\(3),
	datad => \regs|msr\(1),
	combout => \regs|ms_int~35_combout\);

\regs|ms_int~36\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ms_int~36_combout\ = \regs|ms_int~35_combout\ & \regs|ier\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|ms_int~35_combout\,
	datac => \regs|ier\(3),
	combout => \regs|ms_int~36_combout\);

\regs|ms_int_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|ms_int~36_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|ms_int_d~regout\);

\regs|ms_int_pnd~82\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ms_int_pnd~82_combout\ = \regs|ier\(3) & (\regs|ms_int_pnd~regout\ # \regs|ms_int~35_combout\ & !\regs|ms_int_d~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|ier\(3),
	datab => \regs|ms_int~35_combout\,
	datac => \regs|ms_int_pnd~regout\,
	datad => \regs|ms_int_d~regout\,
	combout => \regs|ms_int_pnd~82_combout\);

\regs|ms_int_pnd~83\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|ms_int_pnd~83_combout\ = \regs|ms_int_pnd~82_combout\ & (\wb_interface|wb_adr_int[0]~64_combout\ # !\regs|lsr_mask_condition~35_combout\ # !\wb_interface|wb_adr_int[1]~63_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_adr_int[1]~63_combout\,
	datab => \wb_interface|wb_adr_int[0]~64_combout\,
	datac => \regs|lsr_mask_condition~35_combout\,
	datad => \regs|ms_int_pnd~82_combout\,
	combout => \regs|ms_int_pnd~83_combout\);

\regs|ms_int_pnd\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|ms_int_pnd~83_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|ms_int_pnd~regout\);

\regs|iir~317\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|iir~317_combout\ = \regs|thre_int_pnd~regout\ # \regs|iir~316_combout\ # \regs|ms_int_pnd~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111011111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|thre_int_pnd~regout\,
	datab => \regs|iir~316_combout\,
	datac => \regs|ms_int_pnd~regout\,
	combout => \regs|iir~317_combout\);

\regs|iir[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|iir~317_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|iir\(0));

\wb_interface|Mux19~256\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux19~256_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & \regs|receiver|fifo_rx|count\(0) # !\wb_interface|wb_adr_is\(2) & (!\regs|iir\(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000010100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \dbg|Equal0~38_combout\,
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|receiver|fifo_rx|count\(0),
	datad => \regs|iir\(0),
	combout => \wb_interface|Mux19~256_combout\);

\wb_interface|Mux19~257\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux19~257_combout\ = \wb_interface|wb_sel_is\(2) & (\wb_interface|Mux19~256_combout\) # !\wb_interface|wb_sel_is\(2) & !\wb_interface|Mux31~218_combout\ & (\regs|Mux3~113_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011000110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_sel_is\(2),
	datab => \wb_interface|Mux31~218_combout\,
	datac => \wb_interface|Mux19~256_combout\,
	datad => \regs|Mux3~113_combout\,
	combout => \wb_interface|Mux19~257_combout\);

\wb_interface|Mux19~258\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux19~258_combout\ = !\wb_interface|wb_dat_o[10]~539_combout\ & \wb_interface|Mux19~257_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|wb_dat_o[10]~539_combout\,
	datad => \wb_interface|Mux19~257_combout\,
	combout => \wb_interface|Mux19~258_combout\);

\wb_interface|wb_dat_o[12]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux19~258_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(12));

\wb_interface|Mux18~255\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux18~255_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|receiver|fifo_rx|count\(1)) # !\wb_interface|wb_adr_is\(2) & \regs|iir\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|iir\(1),
	datab => \wb_interface|wb_adr_is\(2),
	datac => \dbg|Equal0~38_combout\,
	datad => \regs|receiver|fifo_rx|count\(1),
	combout => \wb_interface|Mux18~255_combout\);

\wb_interface|Mux18~256\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux18~256_combout\ = \wb_interface|wb_sel_is\(2) & (\wb_interface|Mux18~255_combout\) # !\wb_interface|wb_sel_is\(2) & !\wb_interface|Mux31~218_combout\ & \regs|Mux2~105_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~218_combout\,
	datab => \wb_interface|wb_sel_is\(2),
	datac => \regs|Mux2~105_combout\,
	datad => \wb_interface|Mux18~255_combout\,
	combout => \wb_interface|Mux18~256_combout\);

\wb_interface|Mux18~257\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux18~257_combout\ = !\wb_interface|wb_dat_o[10]~539_combout\ & \wb_interface|Mux18~256_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|wb_dat_o[10]~539_combout\,
	datad => \wb_interface|Mux18~256_combout\,
	combout => \wb_interface|Mux18~257_combout\);

\wb_interface|wb_dat_o[13]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux18~257_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(13));

\wb_interface|Mux17~217\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux17~217_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|receiver|fifo_rx|count\(2)) # !\wb_interface|wb_adr_is\(2) & \regs|iir\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|iir\(2),
	datab => \wb_interface|wb_adr_is\(2),
	datac => \regs|receiver|fifo_rx|count\(2),
	datad => \dbg|Equal0~38_combout\,
	combout => \wb_interface|Mux17~217_combout\);

\wb_interface|Mux17~218\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux17~218_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux17~217_combout\ # \wb_interface|Mux23~214_combout\ & \regs|Mux1~165_combout\) # !\wb_interface|Mux31~216_combout\ & (\wb_interface|Mux23~214_combout\ & 
-- \regs|Mux1~165_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux17~217_combout\,
	datac => \wb_interface|Mux23~214_combout\,
	datad => \regs|Mux1~165_combout\,
	combout => \wb_interface|Mux17~218_combout\);

\wb_interface|wb_dat_o[14]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux17~218_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(14));

\wb_interface|Mux16~217\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux16~217_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|receiver|fifo_rx|count\(3)) # !\wb_interface|wb_adr_is\(2) & \regs|iir\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|iir\(3),
	datab => \wb_interface|wb_adr_is\(2),
	datac => \dbg|Equal0~38_combout\,
	datad => \regs|receiver|fifo_rx|count\(3),
	combout => \wb_interface|Mux16~217_combout\);

\wb_interface|Mux16~218\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux16~218_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux16~217_combout\ # \regs|Mux0~217_combout\ & \wb_interface|Mux23~214_combout\) # !\wb_interface|Mux31~216_combout\ & (\regs|Mux0~217_combout\ & 
-- \wb_interface|Mux23~214_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux16~217_combout\,
	datac => \regs|Mux0~217_combout\,
	datad => \wb_interface|Mux23~214_combout\,
	combout => \wb_interface|Mux16~218_combout\);

\wb_interface|wb_dat_o[15]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux16~218_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(15));

\wb_interface|Mux23~216\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux23~216_combout\ = \wb_interface|wb_sel_is\(1) # \wb_interface|wb_adr_is\(3) # \wb_interface|wb_sel_is\(0) # \wb_interface|wb_adr_is\(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_sel_is\(1),
	datab => \wb_interface|wb_adr_is\(3),
	datac => \wb_interface|wb_sel_is\(0),
	datad => \wb_interface|wb_adr_is\(4),
	combout => \wb_interface|Mux23~216_combout\);

\wb_interface|Mux15~193\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux15~193_combout\ = !\wb_interface|Mux23~216_combout\ & \wb_interface|wb_sel_is\(2) & !\wb_interface|wb_sel_is\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \wb_interface|Mux23~216_combout\,
	datac => \wb_interface|wb_sel_is\(2),
	datad => \wb_interface|wb_sel_is\(3),
	combout => \wb_interface|Mux15~193_combout\);

\wb_interface|Mux15~192\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux15~192_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|receiver|fifo_rx|count\(4)) # !\wb_interface|wb_adr_is\(2) & !\regs|lcr\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(0),
	datab => \wb_interface|wb_adr_is\(2),
	datac => \dbg|Equal0~38_combout\,
	datad => \regs|receiver|fifo_rx|count\(4),
	combout => \wb_interface|Mux15~192_combout\);

\wb_interface|Mux15~194\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux15~194_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux15~192_combout\ # \wb_interface|Mux15~193_combout\ & \regs|Mux7~348_combout\) # !\wb_interface|Mux31~216_combout\ & \wb_interface|Mux15~193_combout\ & 
-- (\regs|Mux7~348_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux15~193_combout\,
	datac => \wb_interface|Mux15~192_combout\,
	datad => \regs|Mux7~348_combout\,
	combout => \wb_interface|Mux15~194_combout\);

\wb_interface|wb_dat_o[16]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux15~194_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(16));

\regs|dtr_pad_o\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux39~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always7~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|dtr_pad_o~regout\);

\wb_interface|Mux14~194\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux14~194_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|dtr_pad_o~regout\) # !\wb_interface|wb_adr_is\(2) & !\regs|lcr\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \dbg|Equal0~38_combout\,
	datab => \regs|lcr\(1),
	datac => \regs|dtr_pad_o~regout\,
	datad => \wb_interface|wb_adr_is\(2),
	combout => \wb_interface|Mux14~194_combout\);

\wb_interface|Mux14~195\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux14~195_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux14~194_combout\ # \wb_interface|Mux15~193_combout\ & \regs|Mux6~104_combout\) # !\wb_interface|Mux31~216_combout\ & \wb_interface|Mux15~193_combout\ & 
-- (\regs|Mux6~104_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux15~193_combout\,
	datac => \wb_interface|Mux14~194_combout\,
	datad => \regs|Mux6~104_combout\,
	combout => \wb_interface|Mux14~195_combout\);

\wb_interface|wb_dat_o[17]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux14~195_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(17));

\regs|mcr[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux38~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always7~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|mcr\(1));

\wb_interface|Mux13~190\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux13~190_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|mcr\(1)) # !\wb_interface|wb_adr_is\(2) & \regs|lcr\(2))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \dbg|Equal0~38_combout\,
	datab => \regs|lcr\(2),
	datac => \regs|mcr\(1),
	datad => \wb_interface|wb_adr_is\(2),
	combout => \wb_interface|Mux13~190_combout\);

\wb_interface|Mux13~191\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux13~191_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux13~190_combout\ # \wb_interface|Mux15~193_combout\ & \regs|Mux5~92_combout\) # !\wb_interface|Mux31~216_combout\ & (\wb_interface|Mux15~193_combout\ & 
-- \regs|Mux5~92_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux13~190_combout\,
	datac => \wb_interface|Mux15~193_combout\,
	datad => \regs|Mux5~92_combout\,
	combout => \wb_interface|Mux13~191_combout\);

\wb_interface|wb_dat_o[18]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux13~191_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(18));

\wb_interface|Mux12~194\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux12~194_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|mcr\(2)) # !\wb_interface|wb_adr_is\(2) & \regs|lcr\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \dbg|Equal0~38_combout\,
	datab => \regs|lcr\(3),
	datac => \regs|mcr\(2),
	datad => \wb_interface|wb_adr_is\(2),
	combout => \wb_interface|Mux12~194_combout\);

\wb_interface|Mux12~195\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux12~195_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux12~194_combout\ # \wb_interface|Mux15~193_combout\ & \regs|Mux4~95_combout\) # !\wb_interface|Mux31~216_combout\ & (\wb_interface|Mux15~193_combout\ & 
-- \regs|Mux4~95_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux12~194_combout\,
	datac => \wb_interface|Mux15~193_combout\,
	datad => \regs|Mux4~95_combout\,
	combout => \wb_interface|Mux12~195_combout\);

\wb_interface|wb_dat_o[19]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux12~195_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(19));

\regs|lcr[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux35~26_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => VCC,
	ena => \regs|always4~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lcr\(4));

\wb_interface|Mux11~241\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux11~241_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|mcr\(3)) # !\wb_interface|wb_adr_is\(2) & \regs|lcr\(4))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \dbg|Equal0~38_combout\,
	datab => \regs|lcr\(4),
	datac => \regs|mcr\(3),
	datad => \wb_interface|wb_adr_is\(2),
	combout => \wb_interface|Mux11~241_combout\);

\wb_interface|Mux11~242\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux11~242_combout\ = \wb_interface|wb_sel_is\(3) & (\wb_interface|Mux11~241_combout\) # !\wb_interface|wb_sel_is\(3) & !\wb_interface|Mux23~216_combout\ & \regs|Mux3~113_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101110000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux23~216_combout\,
	datab => \wb_interface|wb_sel_is\(3),
	datac => \regs|Mux3~113_combout\,
	datad => \wb_interface|Mux11~241_combout\,
	combout => \wb_interface|Mux11~242_combout\);

\wb_interface|Mux11~243\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux11~243_combout\ = \wb_interface|wb_sel_is\(2) & \wb_interface|Mux11~242_combout\ & (\wb_interface|wb_dat_o[18]~540_combout\ # !\wb_interface|wb_sel_is\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_o[18]~540_combout\,
	datab => \wb_interface|wb_sel_is\(3),
	datac => \wb_interface|wb_sel_is\(2),
	datad => \wb_interface|Mux11~242_combout\,
	combout => \wb_interface|Mux11~243_combout\);

\wb_interface|wb_dat_o[20]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux11~243_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(20));

\wb_interface|Mux10~240\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux10~240_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (\regs|mcr\(4)) # !\wb_interface|wb_adr_is\(2) & \regs|lcr\(5))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \dbg|Equal0~38_combout\,
	datab => \regs|lcr\(5),
	datac => \regs|mcr\(4),
	datad => \wb_interface|wb_adr_is\(2),
	combout => \wb_interface|Mux10~240_combout\);

\wb_interface|Mux10~241\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux10~241_combout\ = \wb_interface|wb_sel_is\(3) & (\wb_interface|Mux10~240_combout\) # !\wb_interface|wb_sel_is\(3) & !\wb_interface|Mux23~216_combout\ & (\regs|Mux2~105_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux23~216_combout\,
	datab => \wb_interface|Mux10~240_combout\,
	datac => \regs|Mux2~105_combout\,
	datad => \wb_interface|wb_sel_is\(3),
	combout => \wb_interface|Mux10~241_combout\);

\wb_interface|Mux10~242\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux10~242_combout\ = \wb_interface|wb_sel_is\(2) & \wb_interface|Mux10~241_combout\ & (\wb_interface|wb_dat_o[18]~540_combout\ # !\wb_interface|wb_sel_is\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1011000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|wb_dat_o[18]~540_combout\,
	datab => \wb_interface|wb_sel_is\(3),
	datac => \wb_interface|wb_sel_is\(2),
	datad => \wb_interface|Mux10~241_combout\,
	combout => \wb_interface|Mux10~242_combout\);

\wb_interface|wb_dat_o[21]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux10~242_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(21));

\wb_interface|Mux9~202\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux9~202_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & !\regs|fcr\(0) # !\wb_interface|wb_adr_is\(2) & (\regs|lcr\(6)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|fcr\(0),
	datab => \wb_interface|wb_adr_is\(2),
	datac => \dbg|Equal0~38_combout\,
	datad => \regs|lcr\(6),
	combout => \wb_interface|Mux9~202_combout\);

\wb_interface|Mux9~203\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux9~203_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux9~202_combout\ # \wb_interface|Mux15~193_combout\ & \regs|Mux1~165_combout\) # !\wb_interface|Mux31~216_combout\ & (\wb_interface|Mux15~193_combout\ & 
-- \regs|Mux1~165_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux9~202_combout\,
	datac => \wb_interface|Mux15~193_combout\,
	datad => \regs|Mux1~165_combout\,
	combout => \wb_interface|Mux9~203_combout\);

\wb_interface|wb_dat_o[22]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux9~203_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(22));

\wb_interface|Mux8~202\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux8~202_combout\ = \dbg|Equal0~38_combout\ & (\wb_interface|wb_adr_is\(2) & (!\regs|fcr\(1)) # !\wb_interface|wb_adr_is\(2) & \regs|lcr\(7))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(7),
	datab => \regs|fcr\(1),
	datac => \wb_interface|wb_adr_is\(2),
	datad => \dbg|Equal0~38_combout\,
	combout => \wb_interface|Mux8~202_combout\);

\wb_interface|Mux8~203\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux8~203_combout\ = \wb_interface|Mux31~216_combout\ & (\wb_interface|Mux8~202_combout\ # \wb_interface|Mux15~193_combout\ & \regs|Mux0~217_combout\) # !\wb_interface|Mux31~216_combout\ & \wb_interface|Mux15~193_combout\ & 
-- \regs|Mux0~217_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux31~216_combout\,
	datab => \wb_interface|Mux15~193_combout\,
	datac => \regs|Mux0~217_combout\,
	datad => \wb_interface|Mux8~202_combout\,
	combout => \wb_interface|Mux8~203_combout\);

\wb_interface|wb_dat_o[23]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux8~203_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(23));

\wb_interface|wb_dat_o[18]~540\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|wb_dat_o[18]~540_combout\ = \wb_interface|wb_sel_is\(0) & \wb_interface|wb_sel_is\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \wb_interface|wb_sel_is\(0),
	datad => \wb_interface|wb_sel_is\(1),
	combout => \wb_interface|wb_dat_o[18]~540_combout\);

\wb_interface|Mux7~107\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux7~107_combout\ = \dbg|Equal0~39_combout\ & \wb_interface|wb_dat_o[18]~540_combout\ & \wb_interface|wb_sel_is\(2) & \wb_interface|wb_sel_is\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \dbg|Equal0~39_combout\,
	datab => \wb_interface|wb_dat_o[18]~540_combout\,
	datac => \wb_interface|wb_sel_is\(2),
	datad => \wb_interface|wb_sel_is\(3),
	combout => \wb_interface|Mux7~107_combout\);

\wb_interface|Mux7~108\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux7~108_combout\ = \wb_interface|Mux7~109_combout\ & (\regs|Mux7~348_combout\ # \regs|msr\(0) & \wb_interface|Mux7~107_combout\) # !\wb_interface|Mux7~109_combout\ & \regs|msr\(0) & (\wb_interface|Mux7~107_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux7~109_combout\,
	datab => \regs|msr\(0),
	datac => \regs|Mux7~348_combout\,
	datad => \wb_interface|Mux7~107_combout\,
	combout => \wb_interface|Mux7~108_combout\);

\wb_interface|wb_dat_o[24]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux7~108_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(24));

\wb_interface|Mux6~92\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux6~92_combout\ = \wb_interface|Mux7~109_combout\ & (\regs|Mux6~104_combout\ # \regs|msr\(1) & \wb_interface|Mux7~107_combout\) # !\wb_interface|Mux7~109_combout\ & \regs|msr\(1) & \wb_interface|Mux7~107_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux7~109_combout\,
	datab => \regs|msr\(1),
	datac => \wb_interface|Mux7~107_combout\,
	datad => \regs|Mux6~104_combout\,
	combout => \wb_interface|Mux6~92_combout\);

\wb_interface|wb_dat_o[25]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux6~92_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(25));

\wb_interface|Mux7~109\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux7~109_combout\ = !\wb_interface|Mux23~216_combout\ & !\wb_interface|wb_sel_is\(2) & \wb_interface|wb_sel_is\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \wb_interface|Mux23~216_combout\,
	datac => \wb_interface|wb_sel_is\(2),
	datad => \wb_interface|wb_sel_is\(3),
	combout => \wb_interface|Mux7~109_combout\);

\wb_interface|Mux5~92\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux5~92_combout\ = \regs|msr\(2) & (\wb_interface|Mux7~107_combout\ # \wb_interface|Mux7~109_combout\ & \regs|Mux5~92_combout\) # !\regs|msr\(2) & (\wb_interface|Mux7~109_combout\ & \regs|Mux5~92_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|msr\(2),
	datab => \wb_interface|Mux7~107_combout\,
	datac => \wb_interface|Mux7~109_combout\,
	datad => \regs|Mux5~92_combout\,
	combout => \wb_interface|Mux5~92_combout\);

\wb_interface|wb_dat_o[26]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux5~92_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(26));

\wb_interface|Mux4~92\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux4~92_combout\ = \regs|msr\(3) & (\wb_interface|Mux7~107_combout\ # \wb_interface|Mux7~109_combout\ & \regs|Mux4~95_combout\) # !\regs|msr\(3) & (\wb_interface|Mux7~109_combout\ & \regs|Mux4~95_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111100010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|msr\(3),
	datab => \wb_interface|Mux7~107_combout\,
	datac => \wb_interface|Mux7~109_combout\,
	datad => \regs|Mux4~95_combout\,
	combout => \wb_interface|Mux4~92_combout\);

\wb_interface|wb_dat_o[27]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux4~92_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(27));

\wb_interface|Mux3~84\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux3~84_combout\ = \wb_interface|Mux7~109_combout\ & (\regs|Mux3~113_combout\ # \regs|msr\(4) & \wb_interface|Mux7~107_combout\) # !\wb_interface|Mux7~109_combout\ & \regs|msr\(4) & \wb_interface|Mux7~107_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux7~109_combout\,
	datab => \regs|msr\(4),
	datac => \wb_interface|Mux7~107_combout\,
	datad => \regs|Mux3~113_combout\,
	combout => \wb_interface|Mux3~84_combout\);

\wb_interface|wb_dat_o[28]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux3~84_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(28));

\wb_interface|Mux2~84\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux2~84_combout\ = \wb_interface|Mux7~109_combout\ & (\regs|Mux2~105_combout\ # \regs|msr\(5) & \wb_interface|Mux7~107_combout\) # !\wb_interface|Mux7~109_combout\ & \regs|msr\(5) & (\wb_interface|Mux7~107_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux7~109_combout\,
	datab => \regs|msr\(5),
	datac => \regs|Mux2~105_combout\,
	datad => \wb_interface|Mux7~107_combout\,
	combout => \wb_interface|Mux2~84_combout\);

\wb_interface|wb_dat_o[29]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux2~84_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(29));

\wb_interface|Mux1~100\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux1~100_combout\ = \wb_interface|Mux7~109_combout\ & (\regs|Mux1~165_combout\ # \wb_interface|Mux7~107_combout\ & \regs|msr\(6)) # !\wb_interface|Mux7~109_combout\ & \wb_interface|Mux7~107_combout\ & \regs|msr\(6)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux7~109_combout\,
	datab => \wb_interface|Mux7~107_combout\,
	datac => \regs|msr\(6),
	datad => \regs|Mux1~165_combout\,
	combout => \wb_interface|Mux1~100_combout\);

\wb_interface|wb_dat_o[30]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux1~100_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(30));

\wb_interface|Mux0~96\ : cycloneii_lcell_comb
-- Equation(s):
-- \wb_interface|Mux0~96_combout\ = \wb_interface|Mux7~109_combout\ & (\regs|Mux0~217_combout\ # \regs|msr\(7) & \wb_interface|Mux7~107_combout\) # !\wb_interface|Mux7~109_combout\ & \regs|msr\(7) & (\wb_interface|Mux7~107_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \wb_interface|Mux7~109_combout\,
	datab => \regs|msr\(7),
	datac => \regs|Mux0~217_combout\,
	datad => \wb_interface|Mux7~107_combout\,
	combout => \wb_interface|Mux0~96_combout\);

\wb_interface|wb_dat_o[31]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux0~96_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \wb_interface|re_o~combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \wb_interface|wb_dat_o\(31));

\regs|block_cnt[0]~188\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|block_cnt[0]~188_combout\ = \regs|block_cnt\(0) $ VCC
-- \regs|block_cnt[0]~189\ = CARRY(\regs|block_cnt\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|block_cnt\(0),
	datad => VCC,
	combout => \regs|block_cnt[0]~188_combout\,
	cout => \regs|block_cnt[0]~189\);

\regs|always31~0\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|always31~0_combout\ = !\regs|lsr5r~regout\ & \regs|fifo_write~23_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|lsr5r~regout\,
	datad => \regs|fifo_write~23_combout\,
	combout => \regs|always31~0_combout\);

\regs|block_cnt[1]~191\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|block_cnt[1]~191_combout\ = \regs|block_cnt\(1) & \regs|block_cnt[0]~189\ & VCC # !\regs|block_cnt\(1) & !\regs|block_cnt[0]~189\
-- \regs|block_cnt[1]~192\ = CARRY(!\regs|block_cnt\(1) & !\regs|block_cnt[0]~189\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|block_cnt\(1),
	datad => VCC,
	cin => \regs|block_cnt[0]~189\,
	combout => \regs|block_cnt[1]~191_combout\,
	cout => \regs|block_cnt[1]~192\);

\regs|block_cnt[2]~193\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|block_cnt[2]~193_combout\ = \regs|block_cnt\(2) & (GND # !\regs|block_cnt[1]~192\) # !\regs|block_cnt\(2) & (\regs|block_cnt[1]~192\ $ GND)
-- \regs|block_cnt[2]~194\ = CARRY(\regs|block_cnt\(2) # !\regs|block_cnt[1]~192\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|block_cnt\(2),
	datad => VCC,
	cin => \regs|block_cnt[1]~192\,
	combout => \regs|block_cnt[2]~193_combout\,
	cout => \regs|block_cnt[2]~194\);

\regs|block_cnt[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|block_cnt[2]~193_combout\,
	sdata => VCC,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|always31~0_combout\,
	ena => \regs|block_cnt[7]~190_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|block_cnt\(2));

\regs|block_cnt[3]~195\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|block_cnt[3]~195_combout\ = \regs|block_cnt\(3) & \regs|block_cnt[2]~194\ & VCC # !\regs|block_cnt\(3) & !\regs|block_cnt[2]~194\
-- \regs|block_cnt[3]~196\ = CARRY(!\regs|block_cnt\(3) & !\regs|block_cnt[2]~194\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|block_cnt\(3),
	datad => VCC,
	cin => \regs|block_cnt[2]~194\,
	combout => \regs|block_cnt[3]~195_combout\,
	cout => \regs|block_cnt[3]~196\);

\regs|block_cnt[4]~197\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|block_cnt[4]~197_combout\ = \regs|block_cnt\(4) & (GND # !\regs|block_cnt[3]~196\) # !\regs|block_cnt\(4) & (\regs|block_cnt[3]~196\ $ GND)
-- \regs|block_cnt[4]~198\ = CARRY(\regs|block_cnt\(4) # !\regs|block_cnt[3]~196\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|block_cnt\(4),
	datad => VCC,
	cin => \regs|block_cnt[3]~196\,
	combout => \regs|block_cnt[4]~197_combout\,
	cout => \regs|block_cnt[4]~198\);

\regs|block_cnt[4]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|block_cnt[4]~197_combout\,
	sdata => \regs|receiver|WideOr7~30_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|always31~0_combout\,
	ena => \regs|block_cnt[7]~190_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|block_cnt\(4));

\regs|block_cnt[5]~199\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|block_cnt[5]~199_combout\ = \regs|block_cnt\(5) & \regs|block_cnt[4]~198\ & VCC # !\regs|block_cnt\(5) & !\regs|block_cnt[4]~198\
-- \regs|block_cnt[5]~200\ = CARRY(!\regs|block_cnt\(5) & !\regs|block_cnt[4]~198\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \regs|block_cnt\(5),
	datad => VCC,
	cin => \regs|block_cnt[4]~198\,
	combout => \regs|block_cnt[5]~199_combout\,
	cout => \regs|block_cnt[5]~200\);

\regs|block_cnt[6]~201\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|block_cnt[6]~201_combout\ = \regs|block_cnt\(6) & (GND # !\regs|block_cnt[5]~200\) # !\regs|block_cnt\(6) & (\regs|block_cnt[5]~200\ $ GND)
-- \regs|block_cnt[6]~202\ = CARRY(\regs|block_cnt\(6) # !\regs|block_cnt[5]~200\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110011001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \regs|block_cnt\(6),
	datad => VCC,
	cin => \regs|block_cnt[5]~200\,
	combout => \regs|block_cnt[6]~201_combout\,
	cout => \regs|block_cnt[6]~202\);

\regs|WideOr2~23\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr2~23_combout\ = \regs|lcr\(1) & \regs|lcr\(3) & \regs|lcr\(2) & !\regs|lcr\(0) # !\regs|lcr\(1) & (\regs|lcr\(3) # \regs|lcr\(2) # !\regs|lcr\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010011010101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(1),
	datab => \regs|lcr\(3),
	datac => \regs|lcr\(2),
	datad => \regs|lcr\(0),
	combout => \regs|WideOr2~23_combout\);

\regs|WideOr2~23_wirecell\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr2~23_wirecell_combout\ = !\regs|WideOr2~23_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \regs|WideOr2~23_combout\,
	combout => \regs|WideOr2~23_wirecell_combout\);

\regs|block_cnt[6]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|block_cnt[6]~201_combout\,
	sdata => \regs|WideOr2~23_wirecell_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|always31~0_combout\,
	ena => \regs|block_cnt[7]~190_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|block_cnt\(6));

\regs|block_cnt[7]~203\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|block_cnt[7]~203_combout\ = \regs|block_cnt[6]~202\ $ !\regs|block_cnt\(7)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \regs|block_cnt\(7),
	cin => \regs|block_cnt[6]~202\,
	combout => \regs|block_cnt[7]~203_combout\);

\regs|block_cnt[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|block_cnt[7]~203_combout\,
	sdata => \regs|WideOr2~23_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|always31~0_combout\,
	ena => \regs|block_cnt[7]~190_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|block_cnt\(7));

\regs|WideOr3~23\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|WideOr3~23_combout\ = \regs|lcr\(1) $ (\regs|lcr\(3) & \regs|lcr\(2) & !\regs|lcr\(0) # !\regs|lcr\(3) & !\regs|lcr\(2) & \regs|lcr\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010100101101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lcr\(1),
	datab => \regs|lcr\(3),
	datac => \regs|lcr\(2),
	datad => \regs|lcr\(0),
	combout => \regs|WideOr3~23_combout\);

\regs|block_cnt[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|block_cnt[5]~199_combout\,
	sdata => \regs|WideOr3~23_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|always31~0_combout\,
	ena => \regs|block_cnt[7]~190_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|block_cnt\(5));

\regs|lsr5~76\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr5~76_combout\ = !\regs|block_cnt\(6) & !\regs|block_cnt\(7) & !\regs|block_cnt\(4) & !\regs|block_cnt\(5)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|block_cnt\(6),
	datab => \regs|block_cnt\(7),
	datac => \regs|block_cnt\(4),
	datad => \regs|block_cnt\(5),
	combout => \regs|lsr5~76_combout\);

\regs|block_cnt[7]~190\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|block_cnt[7]~190_combout\ = \regs|always31~0_combout\ # \regs|enable~regout\ & (!\regs|lsr5~76_combout\ # !\regs|lsr5~75_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|enable~regout\,
	datab => \regs|lsr5~75_combout\,
	datac => \regs|lsr5~76_combout\,
	datad => \regs|always31~0_combout\,
	combout => \regs|block_cnt[7]~190_combout\);

\regs|block_cnt[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|block_cnt[0]~188_combout\,
	sdata => VCC,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|always31~0_combout\,
	ena => \regs|block_cnt[7]~190_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|block_cnt\(0));

\regs|receiver|Decoder4~13_wirecell\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|receiver|Decoder4~13_wirecell_combout\ = !\regs|receiver|Decoder4~13_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \regs|receiver|Decoder4~13_combout\,
	combout => \regs|receiver|Decoder4~13_wirecell_combout\);

\regs|block_cnt[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|block_cnt[3]~195_combout\,
	sdata => \regs|receiver|Decoder4~13_wirecell_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|always31~0_combout\,
	ena => \regs|block_cnt[7]~190_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|block_cnt\(3));

\regs|block_cnt[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|block_cnt[1]~191_combout\,
	sdata => VCC,
	aclr => \wb_rst_i~clkctrl_outclk\,
	sload => \regs|always31~0_combout\,
	ena => \regs|block_cnt[7]~190_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|block_cnt\(1));

\regs|lsr5~75\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr5~75_combout\ = !\regs|block_cnt\(2) & !\regs|block_cnt\(0) & !\regs|block_cnt\(3) & !\regs|block_cnt\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|block_cnt\(2),
	datab => \regs|block_cnt\(0),
	datac => \regs|block_cnt\(3),
	datad => \regs|block_cnt\(1),
	combout => \regs|lsr5~75_combout\);

\regs|lsr5\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr5~combout\ = !\regs|lsr5~74_combout\ # !\regs|lsr5~76_combout\ # !\regs|lsr5~75_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|lsr5~75_combout\,
	datac => \regs|lsr5~76_combout\,
	datad => \regs|lsr5~74_combout\,
	combout => \regs|lsr5~combout\);

\regs|lsr5r~66\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|lsr5r~66_combout\ = \regs|fifo_write~23_combout\ # \regs|lsr5r~regout\ & (\regs|lsr5~combout\ # !\regs|lsr5_d~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|lsr5_d~regout\,
	datab => \regs|lsr5~combout\,
	datac => \regs|lsr5r~regout\,
	datad => \regs|fifo_write~23_combout\,
	combout => \regs|lsr5r~66_combout\);

\regs|lsr5r\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|lsr5r~66_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|lsr5r~regout\);

\regs|thre_int\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|thre_int~combout\ = !\regs|lsr5r~regout\ & \regs|ier\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|lsr5r~regout\,
	datad => \regs|ier\(1),
	combout => \regs|thre_int~combout\);

\regs|thre_int_d\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|thre_int~combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|thre_int_d~regout\);

\regs|thre_int_pnd~117\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|thre_int_pnd~117_combout\ = \regs|ier\(1) & (\regs|thre_int_pnd~regout\ # !\regs|thre_int_d~regout\ & !\regs|lsr5r~regout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|thre_int_pnd~regout\,
	datab => \regs|thre_int_d~regout\,
	datac => \regs|lsr5r~regout\,
	datad => \regs|ier\(1),
	combout => \regs|thre_int_pnd~117_combout\);

\regs|thre_int_pnd~120\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|thre_int_pnd~120_combout\ = \regs|thre_int_pnd~117_combout\ & !\regs|fifo_write~23_combout\ & (\regs|iir\(3) # !\regs|thre_int_pnd~119_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|thre_int_pnd~119_combout\,
	datab => \regs|thre_int_pnd~117_combout\,
	datac => \regs|iir\(3),
	datad => \regs|fifo_write~23_combout\,
	combout => \regs|thre_int_pnd~120_combout\);

\regs|thre_int_pnd\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|thre_int_pnd~120_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|thre_int_pnd~regout\);

\regs|int_o~460\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|int_o~460_combout\ = \regs|thre_int_pnd~regout\ # \regs|ms_int_pnd~regout\ & (!\regs|msr_read~19_combout\ # !\regs|lsr_mask_condition~35_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100111011101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|ms_int_pnd~regout\,
	datab => \regs|thre_int_pnd~regout\,
	datac => \regs|lsr_mask_condition~35_combout\,
	datad => \regs|msr_read~19_combout\,
	combout => \regs|int_o~460_combout\);

\regs|int_o~461\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|int_o~461_combout\ = \regs|rda_int_pnd~regout\ # \regs|ti_int_pnd~regout\ & (\regs|fifo_read~combout\) # !\regs|ti_int_pnd~regout\ & \regs|int_o~460_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111010111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|rda_int_pnd~regout\,
	datab => \regs|ti_int_pnd~regout\,
	datac => \regs|int_o~460_combout\,
	datad => \regs|fifo_read~combout\,
	combout => \regs|int_o~461_combout\);

\regs|int_o~462\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|int_o~462_combout\ = \regs|rls_int_pnd~regout\ & (\regs|lsr_mask~combout\) # !\regs|rls_int_pnd~regout\ & \regs|int_o~461_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|rls_int_pnd~regout\,
	datac => \regs|int_o~461_combout\,
	datad => \regs|lsr_mask~combout\,
	combout => \regs|int_o~462_combout\);

\regs|int_o\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|int_o~462_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|int_o~regout\);

\regs|transmitter|bit_out~1053\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_out~1053_combout\ = \regs|enable~regout\ & (\regs|transmitter|tstate\(0) & (!\regs|transmitter|tstate\(1)) # !\regs|transmitter|tstate\(0) & \regs|transmitter|counter\(0) & \regs|transmitter|tstate\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|counter\(0),
	datab => \regs|enable~regout\,
	datac => \regs|transmitter|tstate\(0),
	datad => \regs|transmitter|tstate\(1),
	combout => \regs|transmitter|bit_out~1053_combout\);

\regs|transmitter|bit_out~1054\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_out~1054_combout\ = \regs|transmitter|bit_out~1053_combout\ & (\regs|transmitter|tstate\(2) & (!\regs|transmitter|tstate\(1)) # !\regs|transmitter|tstate\(2) & \regs|transmitter|WideNor1~23_combout\ & \regs|transmitter|tstate\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(2),
	datab => \regs|transmitter|WideNor1~23_combout\,
	datac => \regs|transmitter|bit_out~1053_combout\,
	datad => \regs|transmitter|tstate\(1),
	combout => \regs|transmitter|bit_out~1054_combout\);

\regs|transmitter|fifo_tx|bottom~745\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|bottom~745_combout\ = !\regs|tf_push~regout\ & \regs|lsr5~74_combout\ # !\regs|transmitter|tf_pop~regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|tf_push~regout\,
	datac => \regs|lsr5~74_combout\,
	datad => \regs|transmitter|tf_pop~regout\,
	combout => \regs|transmitter|fifo_tx|bottom~745_combout\);

\regs|transmitter|fifo_tx|bottom~746\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|bottom~746_combout\ = !\regs|tx_reset~regout\ & (\regs|transmitter|fifo_tx|bottom\(0) $ !\regs|transmitter|fifo_tx|bottom~745_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000000000101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|tx_reset~regout\,
	datac => \regs|transmitter|fifo_tx|bottom\(0),
	datad => \regs|transmitter|fifo_tx|bottom~745_combout\,
	combout => \regs|transmitter|fifo_tx|bottom~746_combout\);

\regs|transmitter|fifo_tx|bottom[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|bottom~746_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|bottom\(0));

\regs|transmitter|fifo_tx|bottom~747\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|bottom~747_combout\ = !\regs|tx_reset~regout\ & (\regs|transmitter|fifo_tx|bottom\(1) $ (\regs|transmitter|fifo_tx|bottom\(0) & !\regs|transmitter|fifo_tx|bottom~745_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000000010100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|tx_reset~regout\,
	datab => \regs|transmitter|fifo_tx|bottom\(0),
	datac => \regs|transmitter|fifo_tx|bottom\(1),
	datad => \regs|transmitter|fifo_tx|bottom~745_combout\,
	combout => \regs|transmitter|fifo_tx|bottom~747_combout\);

\regs|transmitter|fifo_tx|bottom[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|bottom~747_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|bottom\(1));

\regs|transmitter|fifo_tx|Add3~103\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|Add3~103_combout\ = \regs|transmitter|fifo_tx|bottom\(0) & \regs|transmitter|fifo_tx|bottom\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|fifo_tx|bottom\(0),
	datad => \regs|transmitter|fifo_tx|bottom\(1),
	combout => \regs|transmitter|fifo_tx|Add3~103_combout\);

\regs|transmitter|fifo_tx|bottom~748\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|bottom~748_combout\ = !\regs|tx_reset~regout\ & (\regs|transmitter|fifo_tx|bottom\(2) $ (\regs|transmitter|fifo_tx|Add3~103_combout\ & !\regs|transmitter|fifo_tx|bottom~745_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000000010100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|tx_reset~regout\,
	datab => \regs|transmitter|fifo_tx|Add3~103_combout\,
	datac => \regs|transmitter|fifo_tx|bottom\(2),
	datad => \regs|transmitter|fifo_tx|bottom~745_combout\,
	combout => \regs|transmitter|fifo_tx|bottom~748_combout\);

\regs|transmitter|fifo_tx|bottom[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|bottom~748_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|bottom\(2));

\regs|transmitter|fifo_tx|Add3~104\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|Add3~104_combout\ = \regs|transmitter|fifo_tx|bottom\(0) & \regs|transmitter|fifo_tx|bottom\(2) & \regs|transmitter|fifo_tx|bottom\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|fifo_tx|bottom\(0),
	datac => \regs|transmitter|fifo_tx|bottom\(2),
	datad => \regs|transmitter|fifo_tx|bottom\(1),
	combout => \regs|transmitter|fifo_tx|Add3~104_combout\);

\regs|transmitter|fifo_tx|bottom~749\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|bottom~749_combout\ = !\regs|tx_reset~regout\ & (\regs|transmitter|fifo_tx|bottom\(3) $ (\regs|transmitter|fifo_tx|Add3~104_combout\ & !\regs|transmitter|fifo_tx|bottom~745_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000000010100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|tx_reset~regout\,
	datab => \regs|transmitter|fifo_tx|Add3~104_combout\,
	datac => \regs|transmitter|fifo_tx|bottom\(3),
	datad => \regs|transmitter|fifo_tx|bottom~745_combout\,
	combout => \regs|transmitter|fifo_tx|bottom~749_combout\);

\regs|transmitter|fifo_tx|bottom[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|bottom~749_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|bottom\(3));

\regs|transmitter|fifo_tx|top~179\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|top~179_combout\ = !\regs|tx_reset~regout\ & !\regs|transmitter|fifo_tx|top\(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010100000101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|tx_reset~regout\,
	datac => \regs|transmitter|fifo_tx|top\(0),
	combout => \regs|transmitter|fifo_tx|top~179_combout\);

\regs|transmitter|fifo_tx|top[3]~180\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|top[3]~180_combout\ = \regs|tx_reset~regout\ # \regs|tf_push~regout\ & (\regs|transmitter|tf_pop~regout\ # !\regs|transmitter|fifo_tx|count\(4))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101010111010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|tx_reset~regout\,
	datab => \regs|transmitter|fifo_tx|count\(4),
	datac => \regs|tf_push~regout\,
	datad => \regs|transmitter|tf_pop~regout\,
	combout => \regs|transmitter|fifo_tx|top[3]~180_combout\);

\regs|transmitter|fifo_tx|top[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|top~179_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|transmitter|fifo_tx|top[3]~180_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|top\(0));

\regs|transmitter|fifo_tx|top~181\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|top~181_combout\ = !\regs|tx_reset~regout\ & (\regs|transmitter|fifo_tx|top\(1) $ \regs|transmitter|fifo_tx|top\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010101010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|tx_reset~regout\,
	datac => \regs|transmitter|fifo_tx|top\(1),
	datad => \regs|transmitter|fifo_tx|top\(0),
	combout => \regs|transmitter|fifo_tx|top~181_combout\);

\regs|transmitter|fifo_tx|top[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|top~181_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|transmitter|fifo_tx|top[3]~180_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|top\(1));

\regs|transmitter|fifo_tx|top~182\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|top~182_combout\ = !\regs|tx_reset~regout\ & (\regs|transmitter|fifo_tx|top\(2) $ (\regs|transmitter|fifo_tx|top\(0) & \regs|transmitter|fifo_tx|top\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001010001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|tx_reset~regout\,
	datab => \regs|transmitter|fifo_tx|top\(0),
	datac => \regs|transmitter|fifo_tx|top\(2),
	datad => \regs|transmitter|fifo_tx|top\(1),
	combout => \regs|transmitter|fifo_tx|top~182_combout\);

\regs|transmitter|fifo_tx|top[2]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|top~182_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|transmitter|fifo_tx|top[3]~180_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|top\(2));

\regs|transmitter|fifo_tx|Add0~103\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|Add0~103_combout\ = \regs|transmitter|fifo_tx|top\(0) & \regs|transmitter|fifo_tx|top\(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|fifo_tx|top\(0),
	datad => \regs|transmitter|fifo_tx|top\(1),
	combout => \regs|transmitter|fifo_tx|Add0~103_combout\);

\regs|transmitter|fifo_tx|top~183\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|top~183_combout\ = !\regs|tx_reset~regout\ & (\regs|transmitter|fifo_tx|top\(3) $ (\regs|transmitter|fifo_tx|top\(2) & \regs|transmitter|fifo_tx|Add0~103_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001010001010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|tx_reset~regout\,
	datab => \regs|transmitter|fifo_tx|top\(2),
	datac => \regs|transmitter|fifo_tx|top\(3),
	datad => \regs|transmitter|fifo_tx|Add0~103_combout\,
	combout => \regs|transmitter|fifo_tx|top~183_combout\);

\regs|transmitter|fifo_tx|top[3]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|top~183_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|transmitter|fifo_tx|top[3]~180_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|top\(3));

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[7]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|transmitter|fifo_tx|top\(3),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(7));

\regs|transmitter|fifo_tx|tfifo|ram~818\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~818_combout\ = \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(3) & \regs|transmitter|fifo_tx|bottom\(1) & (\regs|transmitter|fifo_tx|bottom\(3) $ !\regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(7)) # 
-- !\regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(3) & !\regs|transmitter|fifo_tx|bottom\(1) & (\regs|transmitter|fifo_tx|bottom\(3) $ !\regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(7))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000001001000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(3),
	datab => \regs|transmitter|fifo_tx|bottom\(3),
	datac => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(7),
	datad => \regs|transmitter|fifo_tx|bottom\(1),
	combout => \regs|transmitter|fifo_tx|tfifo|ram~818_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[0]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|tf_push~regout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(0));

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[1]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \regs|transmitter|fifo_tx|top\(0),
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(1));

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[5]~feeder\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[5]~feeder_combout\ = \regs|transmitter|fifo_tx|top\(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \regs|transmitter|fifo_tx|top\(2),
	combout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[5]~feeder_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[5]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass[5]~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(5));

\regs|transmitter|fifo_tx|tfifo|ram~819\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~819_combout\ = \regs|transmitter|fifo_tx|bottom\(2) & \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(5) & (\regs|transmitter|fifo_tx|bottom\(0) $ !\regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(1)) # 
-- !\regs|transmitter|fifo_tx|bottom\(2) & !\regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(5) & (\regs|transmitter|fifo_tx|bottom\(0) $ !\regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000001001000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|bottom\(2),
	datab => \regs|transmitter|fifo_tx|bottom\(0),
	datac => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(1),
	datad => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(5),
	combout => \regs|transmitter|fifo_tx|tfifo|ram~819_combout\);

\regs|transmitter|fifo_tx|tfifo|ram~820\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~820_combout\ = \regs|transmitter|fifo_tx|tfifo|ram~818_combout\ & \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(0) & \regs|transmitter|fifo_tx|tfifo|ram~819_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|fifo_tx|tfifo|ram~818_combout\,
	datac => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(0),
	datad => \regs|transmitter|fifo_tx|tfifo|ram~819_combout\,
	combout => \regs|transmitter|fifo_tx|tfifo|ram~820_combout\);

\regs|transmitter|fifo_tx|tfifo|ram~822\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~822_combout\ = \regs|tf_push~regout\ & !\regs|transmitter|fifo_tx|top\(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \regs|tf_push~regout\,
	datad => \regs|transmitter|fifo_tx|top\(3),
	combout => \regs|transmitter|fifo_tx|tfifo|ram~822_combout\);

\regs|transmitter|fifo_tx|tfifo|ram~823\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~823_combout\ = !\regs|transmitter|fifo_tx|top\(1) & !\regs|transmitter|fifo_tx|top\(0) & !\regs|transmitter|fifo_tx|top\(2) & \regs|transmitter|fifo_tx|tfifo|ram~822_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|fifo_tx|top\(1),
	datab => \regs|transmitter|fifo_tx|top\(0),
	datac => \regs|transmitter|fifo_tx|top\(2),
	datad => \regs|transmitter|fifo_tx|tfifo|ram~822_combout\,
	combout => \regs|transmitter|fifo_tx|tfifo|ram~823_combout\);

\regs|transmitter|fifo_tx|tfifo|ram~16\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	sdata => \wb_interface|Mux39~26_combout\,
	sload => VCC,
	ena => \regs|transmitter|fifo_tx|tfifo|ram~823_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram~16_regout\);

\regs|transmitter|fifo_tx|tfifo|ram~817\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~817_combout\ = \regs|receiver|fifo_rx|rfifo|ram~15_regout\ & (\regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(0)) # !\regs|receiver|fifo_rx|rfifo|ram~15_regout\ & 
-- \regs|transmitter|fifo_tx|tfifo|ram~16_regout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|receiver|fifo_rx|rfifo|ram~15_regout\,
	datac => \regs|transmitter|fifo_tx|tfifo|ram~16_regout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram_rtl_1|auto_generated|q_b\(0),
	combout => \regs|transmitter|fifo_tx|tfifo|ram~817_combout\);

\regs|transmitter|fifo_tx|tfifo|ram_0_bypass[9]\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \wb_interface|Mux39~26_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(9));

\regs|transmitter|fifo_tx|tfifo|ram~821\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|fifo_tx|tfifo|ram~821_combout\ = \regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & (\regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(9)) # !\regs|transmitter|fifo_tx|tfifo|ram~820_combout\ & \regs|transmitter|fifo_tx|tfifo|ram~817_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|fifo_tx|tfifo|ram~820_combout\,
	datac => \regs|transmitter|fifo_tx|tfifo|ram~817_combout\,
	datad => \regs|transmitter|fifo_tx|tfifo|ram_0_bypass\(9),
	combout => \regs|transmitter|fifo_tx|tfifo|ram~821_combout\);

\regs|transmitter|bit_out~1058\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|bit_out~1058_combout\ = \regs|transmitter|bit_out~1054_combout\ & (\regs|transmitter|tstate\(2) & (\regs|transmitter|fifo_tx|tfifo|ram~821_combout\) # !\regs|transmitter|tstate\(2) & \regs|transmitter|bit_out~1057_combout\) # 
-- !\regs|transmitter|bit_out~1054_combout\ & \regs|transmitter|bit_out~1057_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101000101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|bit_out~1057_combout\,
	datab => \regs|transmitter|bit_out~1054_combout\,
	datac => \regs|transmitter|tstate\(2),
	datad => \regs|transmitter|fifo_tx|tfifo|ram~821_combout\,
	combout => \regs|transmitter|bit_out~1058_combout\);

\regs|transmitter|bit_out\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|bit_out~1058_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|bit_out~regout\);

\regs|transmitter|Mux21~148\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux21~148_combout\ = \regs|transmitter|tstate\(2) & !\regs|transmitter|stx_o_tmp~regout\ # !\regs|transmitter|tstate\(2) & (\regs|transmitter|bit_out~regout\ & \regs|transmitter|tstate\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111001000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|tstate\(2),
	datab => \regs|transmitter|stx_o_tmp~regout\,
	datac => \regs|transmitter|bit_out~regout\,
	datad => \regs|transmitter|tstate\(1),
	combout => \regs|transmitter|Mux21~148_combout\);

\regs|transmitter|Mux21~149\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|transmitter|Mux21~149_combout\ = !\regs|transmitter|Mux21~148_combout\ & (\regs|transmitter|tstate\(0) # \regs|transmitter|tstate\(1))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \regs|transmitter|Mux21~148_combout\,
	datac => \regs|transmitter|tstate\(0),
	datad => \regs|transmitter|tstate\(1),
	combout => \regs|transmitter|Mux21~149_combout\);

\regs|transmitter|stx_o_tmp\ : cycloneii_lcell_ff
PORT MAP (
	clk => \wb_clk_i~clkctrl_outclk\,
	datain => \regs|transmitter|Mux21~149_combout\,
	aclr => \wb_rst_i~clkctrl_outclk\,
	ena => \regs|enable~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	regout => \regs|transmitter|stx_o_tmp~regout\);

\regs|stx_pad_o~2\ : cycloneii_lcell_comb
-- Equation(s):
-- \regs|stx_pad_o~2_combout\ = \regs|mcr\(4) # !\regs|transmitter|stx_o_tmp~regout\ & !\regs|lcr\(6)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \regs|transmitter|stx_o_tmp~regout\,
	datac => \regs|lcr\(6),
	datad => \regs|mcr\(4),
	combout => \regs|stx_pad_o~2_combout\);

\wb_adr_i[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_adr_i(0));

\wb_adr_i[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "input",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => GND,
	padio => ww_wb_adr_i(1));

\wb_dat_o[0]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(0),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(0));

\wb_dat_o[1]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(1));

\wb_dat_o[2]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(2),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(2));

\wb_dat_o[3]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(3),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(3));

\wb_dat_o[4]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(4),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(4));

\wb_dat_o[5]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(5),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(5));

\wb_dat_o[6]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(6),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(6));

\wb_dat_o[7]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(7),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(7));

\wb_dat_o[8]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(8),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(8));

\wb_dat_o[9]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(9),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(9));

\wb_dat_o[10]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(10),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(10));

\wb_dat_o[11]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(11),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(11));

\wb_dat_o[12]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(12),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(12));

\wb_dat_o[13]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(13),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(13));

\wb_dat_o[14]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(14),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(14));

\wb_dat_o[15]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(15),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(15));

\wb_dat_o[16]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(16),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(16));

\wb_dat_o[17]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(17),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(17));

\wb_dat_o[18]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(18),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(18));

\wb_dat_o[19]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(19),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(19));

\wb_dat_o[20]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(20),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(20));

\wb_dat_o[21]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(21),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(21));

\wb_dat_o[22]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(22),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(22));

\wb_dat_o[23]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(23),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(23));

\wb_dat_o[24]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(24),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(24));

\wb_dat_o[25]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(25),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(25));

\wb_dat_o[26]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(26),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(26));

\wb_dat_o[27]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(27),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(27));

\wb_dat_o[28]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(28),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(28));

\wb_dat_o[29]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(29),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(29));

\wb_dat_o[30]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(30),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(30));

\wb_dat_o[31]~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_dat_o\(31),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_dat_o(31));

\wb_ack_o~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \wb_interface|wb_ack_o~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_wb_ack_o);

\int_o~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \regs|int_o~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_int_o);

\stx_pad_o~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \regs|stx_pad_o~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_stx_pad_o);

\rts_pad_o~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \regs|mcr\(1),
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_rts_pad_o);

\dtr_pad_o~I\ : cycloneii_io
-- pragma translate_off
GENERIC MAP (
	input_async_reset => "none",
	input_power_up => "low",
	input_register_mode => "none",
	input_sync_reset => "none",
	oe_async_reset => "none",
	oe_power_up => "low",
	oe_register_mode => "none",
	oe_sync_reset => "none",
	operation_mode => "output",
	output_async_reset => "none",
	output_power_up => "low",
	output_register_mode => "none",
	output_sync_reset => "none")
-- pragma translate_on
PORT MAP (
	datain => \regs|dtr_pad_o~regout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	devoe => ww_devoe,
	oe => VCC,
	padio => ww_dtr_pad_o);
END structure;


