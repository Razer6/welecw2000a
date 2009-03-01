vlib work
vlib DSO
vcom -quiet -93 -work DSO {../../Scope/src/Global-p.vhd}
vcom -quiet -93 -work DSO ../../DownSampler/Octave/ShortInputValues-p.vhd
vcom -quiet -93 -work DSO ../../DownSampler/src/PolyphaseDecimator-p.vhd
vcom -quiet -93 -work DSO ../../DownSampler/src/FastAverage-ea.vhd
vcom -quiet -93 -work work ../../DownSampler/src/TestbenchFastAverage-ea.vhd

vsim Testbench
do wave.do
run -all

