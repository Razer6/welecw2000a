vlib work
vmap work work
vlib DSO
vmap DSO DSO

vcom -quiet -93 -work DSO {../../Scope/src/Global-p.vhd}
vcom -quiet -93 -work DSO {../../ExtRAM/src/SRamPriorityAccess-p.vhd}
vcom -quiet -93 -work DSO {../../ExtRAM/src/SRamPriorityAccess-ea.vhd}
vcom -quiet -93 -work DSO {../../VGA/src/StrobeGen_var-e.vhd}
vcom -quiet -93 -work DSO {../../VGA/src/StrobeGen_var-a.vhd}
vcom -quiet -93 -work DSO {../../VGA/src/VGA-p.vhd}
vcom -quiet -93 -work DSO {../../VGA/src/SimpleVGA-ea.vhd}


# behavional files for testing
vcom -quiet -93 -work work {../../TestFiles/src/AsyncSRAM-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/BhvDisplay-ea.vhd}
vcom -quiet -93 -work work {../../VGA/src/TestbenchSimpleVGA-ea.vhd}

vsim -suppress 3473 TestbenchSimpleVGA
do wave.do
#run 2 us
