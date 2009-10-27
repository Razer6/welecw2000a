vlib DSO
vlib work
vcom -quiet -work DSO ../../LedsKeys/src/DSOConfig-p.vhd
vcom -quiet -work DSO ../../Scope/src/Global-p.vhd
vcom -quiet -work DSO ../../LedsKeys/src/StrobeGen-e.vhd
vcom -quiet -work DSO ../../LedsKeys/src/StrobeGen-Rtl-a.vhd
vcom -quiet -work DSO ../../LedsKeys/src/PWM-ea.vhd
vcom -quiet -work DSO ../../LedsKeys/src/LedsKeys-p.vhd
vcom -quiet -work DSO ../../LedsKeys/src/NobDecoder-ea.vhd
vcom -quiet -work DSO ../../LedsKeys/src/LedsKeys-ea.vhd


vcom -quiet -work work ../../TestFiles/src/StoP_hc595-ea.vhd
vcom -quiet -work work ../../TestFiles/src/PtoS_HCT165-ea.vhd
vcom -quiet -work work ../../TestFiles/src/DeMux_HCT238-ea.vhd
vcom -quiet -work work ../../TestFiles/src/DAC_LTC2612-ea.vhd

vcom -quiet -work work ../../LedsKeys/src/Testbench-ea.vhd

vsim Testbench
do wave.do
run 1000 us

