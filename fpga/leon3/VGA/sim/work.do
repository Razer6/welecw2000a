vlib work
vmap work work
vlib dso
vmap dso

do ../../grlib-W2000A/designs/leon3-w2000a/l3.do
vcom -quiet -93 -work grlib ../../grlib-W2000A/lib/grlib/stdlib/version.vhd
vcom -quiet -93 -work grlib ../../grlib-W2000A/lib/grlib/stdlib/stdlib.vhd
vcom -quiet -93 -work grlib ../../grlib-W2000A/lib/grlib/stdlib/stdio.vhd
vcom -quiet -work dw02 ../../grlib-W2000A/lib/tech/dw02/comp/DW02_components.vhd
do ../../grlib-W2000A/designs/leon3-w2000a/leon3.do
