## Generated SDC file "W2000A.sdc"

## Copyright (C) 1991-2009 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 9.1 Build 222 10/21/2009 SJ Web Edition"

## DATE    "Thu Jan 28 20:40:46 2010"

##
## DEVICE  "EP2C35F484C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {iclk25_2} -period 40.000 -waveform { 0.000 20.000 } [get_ports {iclk25_2}]
create_clock -name {iclk25_7} -period 40.000 -waveform { 0.000 20.000 } [get_ports {iclk25_7}]
create_clock -name {iclk25_10} -period 40.000 -waveform { 0.000 20.000 } [get_ports {iclk25_10}]
create_clock -name {iclk25_15} -period 40.000 -waveform { 0.000 20.000 } [get_ports {iclk25_15}]


#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[0]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[1]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[2]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[3]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[4]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[5]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[6]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[7]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[8]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[9]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[10]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[11]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[12]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[13]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[14]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[15]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[16]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[17]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[18]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[19]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[20]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[21]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[22]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[23]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[24]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[25]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[26]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[27]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[28]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[29]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[30]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[31]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[0]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[0](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[1]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[1](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[2]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[2](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[3]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[3](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[4]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[4](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[5]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[5](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[6]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[6](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[7]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC1[7](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[0]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[0](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[1]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[1](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[2]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[2](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[3]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[3](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[4]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[4](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[5]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[5](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[6]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[6](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[7]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC2[7](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[0]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[0](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[1]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[1](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[2]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[2](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[3]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[3](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[4]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[4](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[5]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[5](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[6]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[6](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[7]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC3[7](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[0]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[0](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[1]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[1](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[2]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[2](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[3]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[3](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[4]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[4](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[5]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[5](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[6]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[6](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[7]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh1ADC4[7](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[0]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[0](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[1]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[1](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[2]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[2](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[3]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[3](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[4]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[4](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[5]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[5](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[6]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[6](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[7]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC1[7](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[0]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[0](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[1]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[1](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[2]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[2](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[3]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[3](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[4]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[4](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[5]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[5](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[6]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[6](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[7]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC2[7](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[0]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[0](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[1]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[1](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[2]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[2](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[3]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[3](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[4]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[4](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[5]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[5](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[6]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[6](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[7]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC3[7](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[0]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[0](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[1]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[1](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[2]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[2](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[3]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[3](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[4]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[4](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[5]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[5](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[6]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[6](n)}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[7]}]
set_input_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0]}]  2.000 [get_ports {iCh2ADC4[7](n)}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[0]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[1]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[2]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[3]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[4]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[5]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[6]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[7]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[8]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[9]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[10]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[11]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[12]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[13]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[14]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[15]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[16]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[17]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[18]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[19]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[20]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[21]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[22]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[23]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[24]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[25]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[26]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[27]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[28]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[29]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[30]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {bD_SRAM[31]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[0]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[1]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[2]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[3]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[4]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[5]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[6]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[7]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[8]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[9]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[10]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[11]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[12]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[13]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[14]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[15]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[16]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[17]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oA_SRAM[18]}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oCE_SRAM}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oLB1_SRAM}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oLB2_SRAM}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oOE_SRAM}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oUB1_SRAM}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oUB2_SRAM}]
set_output_delay -add_delay  -clock [get_clocks {CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}]  6.000 [get_ports {oWE_SRAM}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {iclk25_2 iclk25_7 iclk25_10 iclk25_15}] 
set_clock_groups -exclusive -group [get_clocks {CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[0] CaptureSignals|ADCs|PLL0|altpll_component|pll|clk[1] CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[0] CaptureSignals|ADCs|PLL1|altpll_component|pll|clk[1] CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[0] CaptureSignals|ADCs|PLL2|altpll_component|pll|clk[1] CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[0] CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[1] CaptureSignals|ADCs|PLL3|altpll_component|pll|clk[2]}] 


#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

