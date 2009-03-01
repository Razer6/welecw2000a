#../../grlib-W2000A/designs/W2000A/ghdl.sh
mkdir gnu/DSO
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../grlib-W2000A/designs/W2000A/config.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Scope/src/Global-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Altera/src/PLL012.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Altera/src/pll3Design.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Altera/src/SyncRam1Gs.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Altera/src/TriggerMemory.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../DownSampler/Octave/FastFirCoeff-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../DownSampler/src/PolyphaseDecimator-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../DownSampler/src/FastAverage-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../DownSampler/src/FastPolyPhaseDecimator-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../DownSampler/src/DownSampler-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../DownSampler/src/TopFastPolyPhaseDecimator-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../DownSampler/src/TopDownSampler-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Trigger/src/Trigger-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Trigger/src/TriggerMemory-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Trigger/src/NormalTrigger-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Trigger/src/ExternalTrigger-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Trigger/src/TopTrigger-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../LedsKeys/src/LedsKeys-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../LedsKeys/src/StrobeGen-e.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../LedsKeys/src/StrobeGen-Rtl-a.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../LedsKeys/src/LedsKeys-ea.vhd

# vlog +incdir+../../uart16550/src ../../uart16550/src/uart_regs.v  ../../uart16550/src/uart_top.v ../../uart16550/src/uart_debug_if.v ../../uart16550/src/uart_rfifo.v ../../uart16550/src/uart_transmitter.v ../../uart16550/src/uart_sync_flops.v ../../uart16550/src/uart_wb.v ../../uart16550/src/raminfr.v ../../uart16550/src/uart_receiver.v ../../uart16550/src/uart_tfifo.v

#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../uart16550/src/Netlist/UartWrapper.vho
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../uart16550/src/Uart-p.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../uart16550/src/UartWrapper-e.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../uart16550/src/UartWrapper-Empty-a.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../uart16550/src/UartWrapper-RTL-a.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../SignalCapture/src/SignalSelector-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Altera/src/PLL0.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Altera/src/PLL1.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Altera/src/PLL2.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Altera/src/PLL3.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../SignalCapture/src/ADC-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../SignalCapture/src/SignalCapture-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../ExtRAM/src/SRamPriorityAccess-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../ExtRAM/src/SRamPriorityAccess-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../VGA/src/StrobeGen_var-e.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../VGA/src/StrobeGen_var-a.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../VGA/src/VGA-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../VGA/src/SimpleVGA-ea.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../CPU/src/ZPU/zpu_config.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../CPU/src/ZPU/zpupkg.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../CPU/src/ZPU/txt_util.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../CPU/src/ZPU/trace.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../CPU/src/ZPU/zpu_core.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../CPU/src/Devices-p.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../CPU/src/Arbiter-ea.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../CPU/src/BootloaderROM-bin-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../CPU/src/SpecialFunctionRegister-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../CPU/src/SpecialFunctionRegister-ea.vhd
#ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../CPU/src/CPUMemoryInterface-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf   ../../grlib-W2000A/lib/DSO/SFR/SFR-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf   ../../grlib-W2000A/lib/DSO/SFR/SFR-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf   ../../grlib-W2000A/lib/DSO/SFR/SignalAccess-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf   ../../grlib-W2000A/lib/DSO/SFR/SignalAccess-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf   ../../grlib-W2000A/lib/DSO/shram/shram-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf   ../../grlib-W2000A/lib/DSO/shram/shram-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../grlib-W2000A/designs/W2000A/ahbrom.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../grlib-W2000A/designs/W2000A/leon3mini.vhd
ghdl -a --ieee=synopsys --workdir=gnu/DSO -Pgnu -Pgnu/techmap -Pgnu/altera -Pgnu/altera_mf  ../../Scope/src/TopScope-ea.vhd

# behavional files for testing
ghdl -a --ieee=synopsys --workdir=gnu/work ../../TestFiles/src/Wavefiles-p.vhd
ghdl -a --ieee=synopsys --workdir=gnu/work ../../TestFiles/src/BhvADC-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/work ../../TestFiles/src/AsyncSRAM-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/work ../../TestFiles/src/BhvDisplay-ea.vhd
ghdl -a --ieee=synopsys --workdir=gnu/work ../../Scope/src/TestbenchTopScope-ea.vhd

vsim -t ps TestbenchTopScope
do wave.do
#run 2 us
