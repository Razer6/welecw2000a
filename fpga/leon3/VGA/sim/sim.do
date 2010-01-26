
vcom -quiet -work dso  {../../grlib-W2000A/designs/leon3-w2000a/DSOConfig-p.vhd}
#vcom -quiet -work dso  {../../grlib-W2000A/designs/leon3-sandboxx/DSOConfig-p.vhd}
vcom -quiet -93 -work dso {../../Scope/src/Global-p.vhd}

#SimpleVGA
#vcom -quiet -93 -work dso {../../ExtRAM/src/SRamPriorityAccess-p.vhd}
#vcom -quiet -93 -work dso {../../ExtRAM/src/SRamPriorityAccess-ea.vhd}
#vcom -quiet -93 -work dso {../../VGA/src/StrobeGen_var-e.vhd}
#vcom -quiet -93 -work dso {../../VGA/src/StrobeGen_var-a.vhd}
vcom -quiet -93 -work dso {../../VGA/src/VGA-p.vhd}
#vcom -quiet -93 -work dso {../../VGA/src/SimpleVGA-ea.vhd}

#PlaneVGA
vcom -quiet -93 -work dso {../../VGA/src/PlaneVGActl-ea.vhd}


# behavional files for testing
vcom -quiet -work work {../../TestFiles/src/AsyncSRAM-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/BhvDisplay-ea.vhd}

#SimpleVGA
#vcom -quiet -93 -work work {../../VGA/src/TestbenchSimpleVGA-ea.vhd}
#vsim -suppress 3473 TestbenchSimpleVGA

#PlaneVGA
vcom -quiet -93 -work work {../../VGA/src/TestbenchPlaneVGActl-ea.vhd}
vsim -suppress 3473 Testbench


do wave.do
#run 2 us
run 500 us
run 7 ms
