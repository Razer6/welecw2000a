ghdl -a ../Global-p.vhd
ghdl -a ../Octave/FastFirCoeff-p.vhd
ghdl -a ../Octave/InputValues-p.vhd
ghdl -a ../PolyphaseDecimator-p.vhd
ghdl -a ../FastAverage-ea.vhd
ghdl -a ../FastPolyPhaseDecimator-ea.vhd
ghdl -a ../TopFastPolyPhaseDecimator-ea.vhd
ghdl -a ../DownSampler-ea.vhd
ghdl -a ../TopDownSampler-ea.vhd
ghdl -a ../../Testfiles/Wavefiles-p.vhd
ghdl -a ../TestbenchTopDownSampler-ea.vhd
del test.log
ghdl -r Testbench --vcd=test.vcd 2> test.log
