## Generated SDC file "W2000.sdc"

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
## VERSION "Version 9.0 Build 132 02/25/2009 SJ Web Edition"

## DATE    "Sat Sep 12 12:00:14 2009"

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
create_clock -name {vir1} -period 4.000 -waveform { 0.000 2.000 } 
create_clock -name {vir2} -period 4.000 -waveform { 1.000 3.000 } 
create_clock -name {vir3} -period 4.000 -waveform { 2.000 4.000 } 
create_clock -name {vir4} -period 4.000 -waveform { 3.000 5.000 } 


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

