onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testbench/dut/iclk
add wave -noupdate -format Logic /testbench/dut/iresetasync
add wave -noupdate -format Literal /testbench/dut/idecimator
add wave -noupdate -format Literal -radix decimal /testbench/dut/idata
add wave -noupdate -format Logic /testbench/dut/ivalid
add wave -noupdate -format Literal -radix decimal /testbench/dut/odata
add wave -noupdate -format Logic /testbench/dut/ovalid
add wave -noupdate -format Literal -radix decimal /testbench/dut/coeff
add wave -noupdate -format Logic /testbench/inputvalid
add wave -noupdate -format Analog-Step -height 200 -offset 60000.0 -radix decimal -scale 0.0015 /testbench/drawinput
add wave -noupdate -format Logic /testbench/drawvalid
add wave -noupdate -format Analog-Step -height 200 -offset 60000.0 -radix decimal -scale 0.0015 /testbench/drawoutput
add wave -noupdate -format Analog-Step -height 200 -offset 60000.0 -radix decimal -scale 0.0015 /testbench/drawaliasing
add wave -noupdate -divider {Polyphase Filter State}
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/r
add wave -noupdate -format Literal -radix decimal /testbench/dut/odata
add wave -noupdate -divider {Polyphase Filter Data}
add wave -noupdate -format Literal -radix unsigned /testbench/dut/readaddr
add wave -noupdate -format Literal -radix unsigned /testbench/dut/writeaddr
add wave -noupdate -format Analog-Step -height 40 -offset 4000.0 -radix decimal -scale 0.00069999999999999999 /testbench/dut/coeff
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/channel
add wave -noupdate -format Literal -radix decimal /testbench/dut/ch__0/data/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {91240000 ns} 0}
configure wave -namecolwidth 368
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
WaveRestoreZoom {90050842 ns} {94651418 ns}
