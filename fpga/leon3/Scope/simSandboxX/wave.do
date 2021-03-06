onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /testbench/d3/ich1adc1
add wave -noupdate -format Logic /testbench/d3/resoutn
add wave -noupdate -format Logic /testbench/d3/clk
add wave -noupdate -format Logic /testbench/d3/errorn
add wave -noupdate -format Literal -radix hexadecimal /testbench/address
add wave -noupdate -format Literal /testbench/d3/address
add wave -noupdate -format Literal /testbench/d3/data
add wave -noupdate -format Literal /testbench/d3/ramsn
add wave -noupdate -format Literal /testbench/d3/ramoen
add wave -noupdate -format Literal /testbench/d3/rben
add wave -noupdate -format Literal /testbench/d3/rwen
add wave -noupdate -format Literal /testbench/d3/romsn
add wave -noupdate -format Logic /testbench/d3/iosn
add wave -noupdate -format Logic /testbench/d3/oen
add wave -noupdate -format Logic /testbench/d3/read
add wave -noupdate -format Logic /testbench/d3/writen
add wave -noupdate -format Literal /testbench/d3/sdcke
add wave -noupdate -format Literal /testbench/d3/sdcsn
add wave -noupdate -format Logic /testbench/d3/sdwen
add wave -noupdate -format Logic /testbench/d3/sdrasn
add wave -noupdate -format Logic /testbench/d3/sdcasn
add wave -noupdate -format Literal /testbench/d3/sddqm
add wave -noupdate -format Logic /testbench/d3/sdclk
add wave -noupdate -format Literal /testbench/d3/sdba
add wave -noupdate -format Logic /testbench/d3/dsuen
add wave -noupdate -format Logic /testbench/d3/dsubre
add wave -noupdate -format Logic /testbench/d3/dsuactn
add wave -noupdate -format Logic /testbench/d3/dsutx
add wave -noupdate -format Logic /testbench/d3/dsurx
add wave -noupdate -format Logic /testbench/d3/rxd1
add wave -noupdate -format Logic /testbench/d3/txd1
add wave -noupdate -format Logic /testbench/d3/emdio
add wave -noupdate -format Logic /testbench/d3/etx_clk
add wave -noupdate -format Logic /testbench/d3/erx_clk
add wave -noupdate -format Literal /testbench/d3/erxd
add wave -noupdate -format Logic /testbench/d3/erx_dv
add wave -noupdate -format Logic /testbench/d3/erx_er
add wave -noupdate -format Logic /testbench/d3/erx_col
add wave -noupdate -format Logic /testbench/d3/erx_crs
add wave -noupdate -format Literal /testbench/d3/etxd
add wave -noupdate -format Logic /testbench/d3/etx_en
add wave -noupdate -format Logic /testbench/d3/etx_er
add wave -noupdate -format Logic /testbench/d3/emdc
add wave -noupdate -format Logic /testbench/d3/vga_vsync
add wave -noupdate -format Logic /testbench/d3/vga_hsync
add wave -noupdate -format Literal /testbench/d3/vga_rd
add wave -noupdate -format Literal /testbench/d3/vga_gr
add wave -noupdate -format Literal /testbench/d3/vga_bl
add wave -noupdate -format Logic /testbench/d3/resetasync
add wave -noupdate -format Logic /testbench/d3/clkcpu
add wave -noupdate -format Literal /testbench/d3/adcin
add wave -noupdate -format Logic /testbench/d3/exttrigger
add wave -noupdate -format Literal /testbench/d3/triggermemtocpu
add wave -noupdate -format Literal /testbench/d3/cputotriggermem
add wave -noupdate -format Literal /testbench/d3/sfrcontroltocpu
add wave -noupdate -format Literal /testbench/d3/sfrcontrolfromcpu
add wave -noupdate -format Logic /testbench/d3/bootromrd
add wave -noupdate -format Logic /testbench/d3/bootack
add wave -noupdate -format Literal /testbench/d3/vcc
add wave -noupdate -format Literal /testbench/d3/gnd
add wave -noupdate -format Literal /testbench/d3/memi
add wave -noupdate -format Literal -expand /testbench/d3/memo
add wave -noupdate -format Literal /testbench/d3/wpo
add wave -noupdate -format Literal /testbench/d3/sdi
add wave -noupdate -format Literal /testbench/d3/sdo
add wave -noupdate -format Literal /testbench/d3/sdo2
add wave -noupdate -format Literal /testbench/d3/sdo3
add wave -noupdate -format Literal /testbench/d3/apbi
add wave -noupdate -format Literal -expand /testbench/d3/apbo
add wave -noupdate -format Literal -expand /testbench/d3/ahbsi
add wave -noupdate -format Literal /testbench/d3/ahbso
add wave -noupdate -format Literal /testbench/d3/ahbmi
add wave -noupdate -format Literal /testbench/d3/ahbmo
add wave -noupdate -format Logic /testbench/d3/clkm
add wave -noupdate -format Logic /testbench/d3/rstn
add wave -noupdate -format Logic /testbench/d3/sdclkl
add wave -noupdate -format Literal /testbench/d3/cgi
add wave -noupdate -format Literal /testbench/d3/cgo
add wave -noupdate -format Literal /testbench/d3/u1i
add wave -noupdate -format Literal /testbench/d3/dui
add wave -noupdate -format Literal /testbench/d3/u1o
add wave -noupdate -format Literal /testbench/d3/duo
add wave -noupdate -format Literal -expand /testbench/d3/irqi
add wave -noupdate -format Literal /testbench/d3/irqo
add wave -noupdate -format Literal /testbench/d3/dbgi
add wave -noupdate -format Literal /testbench/d3/dbgo
add wave -noupdate -format Literal /testbench/d3/dsui
add wave -noupdate -format Literal /testbench/d3/dsuo
add wave -noupdate -format Literal /testbench/d3/ethi
add wave -noupdate -format Literal /testbench/d3/ethi1
add wave -noupdate -format Literal /testbench/d3/ethi2
add wave -noupdate -format Literal /testbench/d3/etho
add wave -noupdate -format Literal /testbench/d3/etho1
add wave -noupdate -format Literal /testbench/d3/etho2
add wave -noupdate -format Literal /testbench/d3/atai
add wave -noupdate -format Literal /testbench/d3/atao
add wave -noupdate -format Literal /testbench/d3/gpti
add wave -noupdate -format Logic /testbench/d3/emddis
add wave -noupdate -format Logic /testbench/d3/ereset
add wave -noupdate -format Logic /testbench/d3/epwrdwn
add wave -noupdate -format Logic /testbench/d3/esleep
add wave -noupdate -format Logic /testbench/d3/epause
add wave -noupdate -format Logic /testbench/d3/tck
add wave -noupdate -format Logic /testbench/d3/tms
add wave -noupdate -format Logic /testbench/d3/tdi
add wave -noupdate -format Logic /testbench/d3/tdo
add wave -noupdate -format Logic /testbench/d3/dsuact
add wave -noupdate -format Logic /testbench/d3/oen_ctrl
add wave -noupdate -format Logic /testbench/d3/sdram_selected
add wave -noupdate -format Logic /testbench/d3/shortcut
add wave -noupdate -format Logic /testbench/d3/rx
add wave -noupdate -format Logic /testbench/d3/tx
add wave -noupdate -format Literal /testbench/d3/dbg_rdata
add wave -noupdate -format Literal /testbench/d3/dbg_wdata
add wave -noupdate -format Literal /testbench/d3/vgao
add wave -noupdate -format Logic /testbench/d3/video_clk
add wave -noupdate -format Literal /testbench/d3/clk_sel
add wave -noupdate -format Logic /testbench/d3/mg2/sr1/rst
add wave -noupdate -format Logic /testbench/d3/mg2/sr1/clk
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/memi
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/memo
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/ahbsi
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/ahbso
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/apbi
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/apbo
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/wpo
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/sdo
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/r
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/ri
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/sdmo
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/sdi
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/lsdo
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/rbdrive
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/ribdrive
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/rrsbdrive
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/rsbdrive
add wave -noupdate -format Literal /testbench/d3/mg2/sr1/risbdrive
add wave -noupdate -format Logic /testbench/d3/mg2/sr1/arst
add wave -noupdate -divider {Trigger Memory}
add wave -noupdate -format Logic /testbench/d3/gendso/triggermem/rst_in
add wave -noupdate -format Logic /testbench/d3/gendso/triggermem/clk_i
add wave -noupdate -format Literal /testbench/d3/gendso/triggermem/ahbsi
add wave -noupdate -format Literal /testbench/d3/gendso/triggermem/ahbso
add wave -noupdate -format Logic /testbench/d3/gendso/triggermem/iclkdesign
add wave -noupdate -format Logic /testbench/d3/gendso/triggermem/iresetasync
add wave -noupdate -format Literal /testbench/d3/gendso/triggermem/itriggermem
add wave -noupdate -format Literal /testbench/d3/gendso/triggermem/otriggermem
add wave -noupdate -format Literal -expand /testbench/d3/gendso/triggermem/ahbout
add wave -noupdate -format Literal -expand /testbench/d3/gendso/triggermem/memin
add wave -noupdate -format Literal /testbench/d3/gendso/triggermem/dataout
add wave -noupdate -format Logic /testbench/d3/gendso/triggermem/hready
add wave -noupdate -divider {DSO SFR}
add wave -noupdate -format Literal -radix hexadecimal -expand /testbench/d3/gensfrdso/sfr0/apb_i
add wave -noupdate -format Literal -expand /testbench/d3/gensfrdso/sfr0/apb_o
add wave -noupdate -format Literal -expand /testbench/d3/gensfrdso/sfr0/isfrcontrol
add wave -noupdate -format Literal -expand /testbench/d3/gensfrdso/sfr0/osfrcontrol
add wave -noupdate -format Literal /testbench/d3/gensfrdso/sfr0/sfr/addr
add wave -noupdate -format Logic /testbench/d3/gensfrdso/sfr0/rd
add wave -noupdate -format Logic /testbench/d3/gensfrdso/sfr0/wr
add wave -noupdate -format Literal -radix hexadecimal /testbench/d3/gensfrdso/sfr0/sfr/idata
add wave -noupdate -format Literal -radix hexadecimal /testbench/d3/gensfrdso/sfr0/sfr/odata
add wave -noupdate -format Logic /testbench/d3/gensfrdso/sfr0/cpuinterrupt
add wave -noupdate -divider CaptureSignals
add wave -noupdate -format Logic -radix hexadecimal /testbench/d3/capturesignals/oclkcpu
add wave -noupdate -format Logic /testbench/d3/capturesignals/iresetasync
add wave -noupdate -format Literal /testbench/d3/capturesignals/iclkadc
add wave -noupdate -format Logic /testbench/d3/capturesignals/oresetasync
add wave -noupdate -format Literal /testbench/d3/capturesignals/iadc
add wave -noupdate -format Literal /testbench/d3/capturesignals/idownsampler
add wave -noupdate -format Literal /testbench/d3/capturesignals/itriggercpuport
add wave -noupdate -format Literal /testbench/d3/capturesignals/otriggercpuport
add wave -noupdate -format Literal /testbench/d3/capturesignals/itriggermem
add wave -noupdate -format Literal /testbench/d3/capturesignals/otriggermem
add wave -noupdate -format Logic /testbench/d3/capturesignals/iexttrigger
add wave -noupdate -format Logic /testbench/d3/capturesignals/resetasync
add wave -noupdate -format Logic /testbench/d3/capturesignals/clkdesign
add wave -noupdate -format Literal /testbench/d3/capturesignals/decimatorin
add wave -noupdate -format Literal -radix hexadecimal -expand /testbench/d3/capturesignals/decimatorout
add wave -noupdate -format Logic /testbench/d3/capturesignals/decimatoroutvalid
add wave -noupdate -format Literal /testbench/d3/capturesignals/isignalselector
add wave -noupdate -format Literal -radix hexadecimal -expand /testbench/d3/capturesignals/selectorout
add wave -noupdate -format Logic /testbench/d3/capturesignals/selectoroutvalid
add wave -noupdate -format Literal /testbench/d3/capturesignals/slowinputdata
add wave -noupdate -format Logic /testbench/d3/capturesignals/slowinputvalid
add wave -noupdate -divider Trigger
add wave -noupdate -format Literal /testbench/d3/capturesignals/exttriggerinput/iexttrigger
add wave -noupdate -format Literal /testbench/d3/capturesignals/exttriggerinput/iexttriggersrc
add wave -noupdate -format Logic /testbench/d3/capturesignals/exttriggerinput/otrigger
add wave -noupdate -format Literal /testbench/d3/capturesignals/exttriggerinput/opwm
add wave -noupdate -format Logic /testbench/d3/capturesignals/exttriggerinput/toggle
add wave -noupdate -format Literal /testbench/d3/capturesignals/exttriggerinput/sources
add wave -noupdate -format Logic /testbench/d3/capturesignals/trigger/iclk
add wave -noupdate -format Logic /testbench/d3/capturesignals/trigger/iresetasync
add wave -noupdate -format Literal -radix hexadecimal /testbench/d3/capturesignals/trigger/idata
add wave -noupdate -format Logic /testbench/d3/capturesignals/trigger/ivalid
add wave -noupdate -format Logic /testbench/d3/capturesignals/trigger/iexttrigger
add wave -noupdate -format Literal /testbench/d3/capturesignals/trigger/itriggermem
add wave -noupdate -format Literal /testbench/d3/capturesignals/trigger/otriggermem
add wave -noupdate -format Literal -expand /testbench/d3/capturesignals/trigger/icpuport
add wave -noupdate -format Literal -expand /testbench/d3/capturesignals/trigger/ocpuport
add wave -noupdate -format Literal -expand /testbench/d3/capturesignals/trigger/r
add wave -noupdate -format Literal -expand /testbench/d3/capturesignals/trigger/triggerstrobes
add wave -noupdate -format Literal /testbench/d3/capturesignals/trigger/triggerdata
add wave -noupdate -format Logic /testbench/d3/capturesignals/trigger/triggerinvalid
add wave -noupdate -format Logic /testbench/d3/capturesignals/trigger/aclr
add wave -noupdate -divider IRQctrl
add wave -noupdate -format Literal /testbench/d3/irqctrl/irqctrl0/apbi
add wave -noupdate -format Literal /testbench/d3/irqctrl/irqctrl0/apbo
add wave -noupdate -format Literal /testbench/d3/irqctrl/irqctrl0/irqi
add wave -noupdate -format Literal /testbench/d3/irqctrl/irqctrl0/irqo
add wave -noupdate -format Literal /testbench/d3/irqctrl/irqctrl0/r
add wave -noupdate -format Literal /testbench/d3/irqctrl/irqctrl0/rin
add wave -noupdate -format Literal /testbench/d3/irqctrl/irqctrl0/r2
add wave -noupdate -format Literal /testbench/d3/irqctrl/irqctrl0/r2in
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {351464646 ps} 0}
configure wave -namecolwidth 396
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {5 us} {2105 us}
