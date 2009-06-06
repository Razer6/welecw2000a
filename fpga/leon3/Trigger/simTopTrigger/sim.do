vcom -quiet -work DSO  {../../grlib-W2000A/designs/leon3-w2000a/DSOConfig-p.vhd}
#vcom -quiet -work DSO  {../../grlib-W2000A/designs/leon3-sandboxx/DSOConfig-p.vhd}
vcom -quiet -work DSO  {../../Scope/src/Global-p.vhd}
vcom -quiet -work DSO  {../../Trigger/src/Trigger-p.vhd}
vcom -quiet -work DSO  {../../Trigger/src/TriggerMemory-ea.vhd}
vcom -quiet -work DSO  {../../Trigger/src/NormalTrigger-ea.vhd}
vcom -quiet -work DSO  {../../Trigger/src/DigitalTrigger-ea.vhd}
vcom -quiet -work DSO  {../../Trigger/src/ExternalTrigger-ea.vhd}
vcom -quiet -work DSO  {../../Trigger/src/TopTrigger-ea.vhd}
vcom -quiet -work work  {../../TestFiles/src/Wavefiles-p.vhd}
vcom -quiet -work work  {../../Trigger/src/TestbenchTopTrigger-ea.vhd}
vsim Testbench
do wave.do
run -all
