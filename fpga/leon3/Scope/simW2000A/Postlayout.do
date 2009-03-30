vlib work
vlib cycloneii

vcom -quiet -work cycloneii ../../Altera/src/cycloneii_atoms.vhd
vcom -quiet -work cycloneii ../../Altera/src/CYCLONEII_COMPONENTS.VHD
vcom -quiet -work work ../../Scope/synW2000A/simulation/modelsim/W2000A.vho
vcom -quiet -93 -work DSO  {../../grlib-W2000A/designs/leon3-w2000a/DSOConfig-p.vhd}
vcom -quiet -93 -work DSO {../../Scope/src/Global-p.vhd}
vcom -quiet -work work ../../Scope/src/NetlistWrapper-ea.vhd

# behavional files for testing
vcom -quiet -93 -work DSO {../../VGA/src/VGA-p.vhd}
vcom -quiet -93 -work work ../../grlib-W2000A/designs/leon3-w2000a/config.vhd
vcom -quiet -93 -work DSO {../../LedsKeys/src/LedsKeys-p.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/Wavefiles-p.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/BhvADC-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/AsyncSRAM-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/BhvDisplay-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/StoP_hc595-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/PtoS_HCT165-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/DeMux_HCT238-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/DAC_LTC2612-ea.vhd}
vcom -quiet -93 -work work ../../grlib-W2000A/designs/leon3-w2000a/Testbench.vhd

vsim -t ps -sdfmax /d3/dut=../../Scope/synW2000A/simulation/modelsim/W2000A_vhd.sdo Testbench
add wave /*
run 20 us
vsim -t ps -sdfmin /d3/dut=../../Scope/synW2000A/simulation/modelsim/W2000A_vhd.sdo Testbench
add wave /*
run 20 us
