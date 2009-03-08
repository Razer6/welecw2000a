ghdl -a ../../DownSampler/Global-p.vhd
ghdl -a ../../DownSampler/Octave/FastFirCoeff-p.vhd
ghdl -a ../../DownSampler/Octave/InputValues-p.vhd
ghdl -a ../../DownSampler/PolyphaseDecimator-p.vhd
ghdl -a ../../DownSampler/FastAverage-ea.vhd
ghdl -a ../../DownSampler/FastPolyPhaseDecimator-ea.vhd
ghdl -a ../../DownSampler/TopFastPolyPhaseDecimator-ea.vhd
ghdl -a ../../DownSampler/DownSampler-ea.vhd
ghdl -a ../../DownSampler/TopDownSampler-ea.vhd
ghdl -a ../../../TestFiles/Wavefiles-p.vhd
ghdl -a ../Trigger-p.vhd
ghdl -a ../ExternalTrigger-ea.vhd
ghdl -a ../NormalTrigger-ea.vhd
ghdl -a ../../Altera/altera_mf.vhd
ghdl -a ../../Altera/altera_mf_components.vhd
ghdl -a ../../Altera/cycloneii_atoms.vhd
ghdl -a ../../Altera/cycloneii_components.vhd
ghdl -a ../../Altera/TriggerMemory4CH.vhd
ghdl -a ../TopTrigger-ea.vhd
ghdl -a ../TestbenchTopTrigger-ea.vhd
del test.log
ghdl -r Testbench --vcd=test.vcd 2> test.log
