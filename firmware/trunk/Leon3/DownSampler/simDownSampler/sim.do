vlib work
vlib DSO
vcom -quiet -work DSO {../../Scope/src/Global-p.vhd}
vcom -quiet -work DSO {../../DownSampler/Octave/FastFirCoeff-p.vhd}
vcom -quiet -work DSO {../../DownSampler/Octave/FirCoeff-p.vhd}
vcom -quiet -work DSO {../../DownSampler/Octave/ShortInputValues-p.vhd}
vcom -quiet -work DSO {../../DownSampler/src/PolyphaseDecimator-p.vhd}
vcom -quiet -work DSO {../../DownSampler/src/FastAverage-ea.vhd}
vcom -quiet -work DSO {../../DownSampler/src/FastPolyPhaseDecimator-ea.vhd}
vcom -quiet -work DSO {../../DownSampler/src/TopFastPolyPhaseDecimator-ea.vhd}
vcom -quiet -work DSO {../../DownSampler/src/DelayMemory.vhd}
vcom -quiet -work DSO {../../DownSampler/src/PolyPhaseDecimator-ea.vhd}
vcom -quiet -work DSO {../../DownSampler/src/TopPolyPhaseDecimator-ea.vhd}
vcom -quiet -work DSO {../../DownSampler/src/DownSampler-ea.vhd}
vcom -quiet -work DSO {../../DownSampler/src/TopDownSampler-ea.vhd}
vcom -quiet -work work {../../TestFiles/src/Wavefiles-p.vhd}
vcom -quiet -work work {../../DownSampler/src/TestbenchTopDownSampler-ea.vhd}
vsim work.Testbench
do wave.do
run -all
