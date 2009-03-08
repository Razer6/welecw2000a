vlib work
vmap work work
vlib altera_mf
vmap altera_mf altera_mf
vlib cycloneii
vmap cycloneii
vlib DSO
vmap DSO

do ../../grlib-W2000A/designs/leon3-w2000a/l3.do
#vcom -quiet -93 {../../Altera/src/altera_mf_components.vhd}
#vcom -quiet -93 {../../Altera/src/altera_mf.vhd}
#vcom -quiet -93 -work cycloneii {../../Altera/src/cycloneii_atoms.vhd}
#vcom -quiet -93 -work cycloneii {../../Altera/src/CYCLONEII_COMPONENTS.VHD}
vcom -quiet -93 -work grlib ../../grlib-W2000A/lib/grlib/stdlib/version.vhd
vcom -quiet -93 -work grlib ../../grlib-W2000A/lib/grlib/stdlib/stdlib.vhd
vcom -quiet -93 -work grlib ../../grlib-W2000A/lib/grlib/stdlib/stdio.vhd
vcom -quiet -work dw02  ../../grlib-w2000A/lib/tech/dw02/comp/DW02_components.vhd
do ../../grlib-W2000A/designs/leon3-w2000a/leon3.do
