vcom -quiet -93 -work work ../../grlib-W2000A/designs/leon3-w2000a/config.vhd
vcom -quiet -93 -work DSO  {../../grlib-W2000A/designs/leon3-w2000a/DSOConfig-p.vhd}
vcom -quiet -93 -work DSO {../../Scope/src/Global-p.vhd}
vcom -quiet -93 -work DSO {../../Altera/src/SyncRam1Gs.vhd}
vcom -quiet -93 -work DSO {../../Altera/src/TriggerMemory.vhd}
vcom -quiet -93 -work DSO {../../DownSampler/Octave/FastFirCoeff-p.vhd}
vcom -quiet -93 -work DSO {../../DownSampler/Octave/FirCoeff-p.vhd}
vcom -quiet -93 -work DSO {../../DownSampler/src/PolyphaseDecimator-p.vhd}
vcom -quiet -93 -work DSO {../../DownSampler/src/FastAverage-ea.vhd}
vcom -quiet -work DSO {../../DownSampler/src/AdderTreeFilter-ea.vhd}
vcom -quiet -93 -work DSO {../../DownSampler/src/FastPolyPhaseDecimator-ea.vhd}
vcom -quiet -93 -work DSO {../../DownSampler/src/TopFastPolyPhaseDecimator-ea.vhd}
vcom -quiet -work DSO {../../DownSampler/src/LongFastPolyPhaseDecimator-ea.vhd}
vcom -quiet -work DSO {../../DownSampler/src/TopLongFastPolyPhaseDecimator-ea.vhd}
vcom -quiet -93 -work DSO {../../DownSampler/src/DelayMemory.vhd}
vcom -quiet -93 -work DSO {../../DownSampler/src/TopPolyPhaseDecimator-ea.vhd}
vcom -quiet -93 -work DSO {../../DownSampler/src/DownSampler-ea.vhd}
vcom -quiet -93 -work DSO {../../DownSampler/src/TopDownSampler-ea.vhd}
vcom -quiet -93 -work DSO {../../Trigger/src/Trigger-p.vhd}
vcom -quiet -93 -work DSO {../../LedsKeys/src/LedsKeys-p.vhd}
vcom -quiet -93 -work DSO {../../LedsKeys/src/PWM-ea.vhd}
#vcom -quiet -93 -work DSO {../../Trigger/src/TriggerMemory-ea.vhd}
vcom -quiet -93 -work DSO {../../Trigger/src/NormalTrigger-ea.vhd}
vcom -quiet -93 -work DSO {../../Trigger/src/DigitalTrigger-ea.vhd}
vcom -quiet -93 -work DSO {../../Trigger/src/ExternalTrigger-ea.vhd}
vcom -quiet -93 -work DSO {../../Trigger/src/TopTrigger-ea.vhd}
vcom -quiet -93 -work DSO {../../Trigger/src/ExtTriggerInput-ea.vhd}
vcom -quiet -93 -work DSO {../../LedsKeys/src/StrobeGen-e.vhd}
vcom -quiet -93 -work DSO {../../LedsKeys/src/StrobeGen-Rtl-a.vhd}
vcom -quiet -93 -work DSO {../../LedsKeys/src/LedsKeys-ea.vhd}

# vlog +incdir+../../uart16550/src ../../uart16550/src/uart_regs.v  ../../uart16550/src/uart_top.v ../../uart16550/src/uart_debug_if.v ../../uart16550/src/uart_rfifo.v ../../uart16550/src/uart_transmitter.v ../../uart16550/src/uart_sync_flops.v ../../uart16550/src/uart_wb.v ../../uart16550/src/raminfr.v ../../uart16550/src/uart_receiver.v ../../uart16550/src/uart_tfifo.v

#vcom -quiet -93 -work DSO {../../uart16550/src/Netlist/UartWrapper.vho}
#vcom -quiet -93 -work DSO {../../uart16550/src/Uart-p.vhd}
#vcom -quiet -93 -work DSO {../../uart16550/src/UartWrapper-e.vhd}
#vcom -quiet -93 -work DSO {../../uart16550/src/UartWrapper-Empty-a.vhd}
#vcom -quiet -93 -work DSO {../../uart16550/src/UartWrapper-RTL-a.vhd}
#vcom -quiet -93 -work DSO {../../Altera/src/PLL0.vhd}
#vcom -quiet -93 -work DSO {../../Altera/src/PLL1.vhd}
#vcom -quiet -93 -work DSO {../../Altera/src/PLL2.vhd}
#vcom -quiet -93 -work DSO {../../Altera/src/PLL3.vhd}
vcom -quiet -93 -work DSO {../../SignalCapture/src/PLL0.vhd}
vcom -quiet -93 -work DSO {../../SignalCapture/src/PLL1.vhd}
vcom -quiet -93 -work DSO {../../SignalCapture/src/PLL2.vhd}
vcom -quiet -93 -work DSO {../../SignalCapture/src/PLL3.vhd}
vcom -quiet -93 -work DSO {../../SignalCapture/src/ADC-ea.vhd}
vcom -quiet -93 -work DSO {../../SignalCapture/src/SignalSelector-ea.vhd}
vcom -quiet -93 -work DSO {../../SignalCapture/src/SignalCapture-ea.vhd}
vcom -quiet -93 -work DSO {../../ExtRAM/src/SRamPriorityAccess-p.vhd}
vcom -quiet -93 -work DSO {../../ExtRAM/src/SRamPriorityAccess-ea.vhd}
vcom -quiet -93 -work DSO {../../VGA/src/StrobeGen_var-e.vhd}
vcom -quiet -93 -work DSO {../../VGA/src/StrobeGen_var-a.vhd}
vcom -quiet -93 -work DSO {../../VGA/src/VGA-p.vhd}
vcom -quiet -93 -work DSO {../../VGA/src/SimpleVGA-ea.vhd}
#vcom -quiet -93 -work DSO {../../CPU/src/ZPU/zpu_config.vhd}
#vcom -quiet -93 -work DSO {../../CPU/src/ZPU/zpupkg.vhd}
#vcom -quiet -93 -work DSO {../../CPU/src/ZPU/txt_util.vhd}
#vcom -quiet -93 -work DSO {../../CPU/src/ZPU/trace.vhd}
#vcom -quiet -93 -work DSO {../../CPU/src/ZPU/zpu_core.vhd}
#vcom -quiet -93 -work DSO {../../CPU/src/Devices-p.vhd}
#vcom -quiet -93 -work DSO {../../CPU/src/Arbiter-ea.vhd}
#vcom -quiet -93 -work DSO {../../CPU/src/BootloaderROM-bin-ea.vhd}
vcom -quiet -93 -work DSO {../../CPU/src/SpecialFunctionRegister-p.vhd}
vcom -quiet -93 -work DSO {../../CPU/src/SpecialFunctionRegister-ea.vhd}
#vcom -quiet -93 -work DSO {../../CPU/src/CPUMemoryInterface-ea.vhd}
vcom -quiet -93 -work DSO  ../../grlib-W2000A/lib/DSO/SFR/SFR-p.vhd
vcom -quiet -93 -work DSO  ../../grlib-W2000A/lib/DSO/SFR/SFR-ea.vhd
vcom -quiet -93 -work DSO  ../../grlib-W2000A/lib/DSO/SFR/SignalAccess-p.vhd
vcom -quiet -93 -work DSO  ../../grlib-W2000A/lib/DSO/SFR/SignalAccess-ea.vhd
vcom -quiet -93 -work DSO  ../../grlib-W2000A/lib/DSO/shram/shram-p.vhd
#vcom -quiet -93 -work DSO  ../../grlib-W2000A/lib/DSO/shram/shram-ea.vhd
vcom -quiet -93 -work work ../../grlib-W2000A/designs/leon3-w2000a/ahbrom.vhd
vcom -quiet -93 -work work ../../grlib-W2000A/designs/leon3-w2000a/W2000ROM.vhd
vcom -quiet -93 -work work ../../grlib-W2000A/designs/leon3-w2000a/leon3mini.vhd
#vcom -quiet -93 -work work ../../Scope/src/leon3mini.vhd      # out of date
#vcom -quiet -93 -work DSO {../../Scope/src/TopScope-ea.vhd}  # out of date

# behavional files for testing
vcom -quiet -93 -work work {../../TestFiles/src/Wavefiles-p.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/BhvADC-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/AsyncSRAM-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/BhvDisplay-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/StoP_hc595-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/PtoS_HCT165-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/DeMux_HCT238-ea.vhd}
vcom -quiet -93 -work work {../../TestFiles/src/DAC_LTC2612-ea.vhd}
vcom -quiet -93 -work work ../../grlib-W2000A/designs/leon3-w2000a/Testbench.vhd
#vcom -quiet -93 -work work {../../Scope/src/TestbenchTopScope-ea.vhd} # out of date

#vsim -t ps -suppress 3473 -gdisas=1 Testbench
vsim -t ps -gdisas=1 -suppress 3473 Testbench
do wave.do
run 500 us
