vlib work
vlib DSO
vcom -quiet -93 -work DSO ../../DownSampler/src/DelayMemory.vhd
vcom -quiet -93 -work DSO {../../Scope/src/Global-p.vhd}
#vcom -quiet -93 -work DSO ../../DownSampler/Octave/FastRampCoeff-p.vhd
#vcom -quiet -93 -work DSO ../../DownSampler/Octave/RampCoeff-p.vhd
vcom -quiet -93 -work DSO ../../DownSampler/Octave/FastFirCoeff-p.vhd
vcom -quiet -93 -work DSO ../../DownSampler/Octave/FirCoeff-p.vhd
vcom -quiet -93 -work work ../../DownSampler/Octave/LongInputValues-p.vhd
vcom -quiet -93 -work DSO ../../DownSampler/src/PolyphaseDecimator-p.vhd
vcom -quiet -93 -work DSO ../../DownSampler/src/PolyPhaseDecimator-ea.vhd
vcom -quiet -93 -work DSO ../../DownSampler/src/TopPolyPhaseDecimator-ea.vhd
vcom -quiet -93 -work work ../../DownSampler/src/TestbenchPolyPhaseDecimator-ea.vhd
vsim work.Testbench
do wave.do
run -all
