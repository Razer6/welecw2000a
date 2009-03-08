ghdl -a ../Global-p.vhd
ghdl -a ../Octave/FastFirCoeff-p.vhd
ghdl -a ../PolyphaseDecimator-p.vhd
ghdl -a ../FastPolyPhaseDecimator-ea.vhd
ghdl -a ../TopFastPolyPhaseDecimator-ea.vhd
ghdl -a ../Octave/InputValues-p.vhd
ghdl -a ../TestbenchFastPolyphaseDecimator-ea.vhd
del test.log
ghdl -r Testbench --vcd=test.vcd 2> test.log
