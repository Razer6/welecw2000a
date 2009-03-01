onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testbench/clk
add wave -noupdate -format Logic /testbench/resetasync
add wave -noupdate -divider {New Divider}
add wave -noupdate -format Analog-Step -scale 0.002 /testbench/drawoutput
add wave -noupdate -divider -height 35 {New Divider}
add wave -noupdate -format Analog-Step -scale 0.001 /testbench/intval
add wave -noupdate -divider -height 30 {New Divider}
add wave -noupdate -format Literal -radix decimal -expand /testbench/datain
add wave -noupdate -format Logic /testbench/valid
add wave -noupdate -format Logic /testbench/exttrigger
add wave -noupdate -format Literal /testbench/fileinfo
add wave -noupdate -divider TopTrigger
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/icpuport
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/ocpuport
add wave -noupdate -format Literal -radix unsigned -expand /testbench/dut/r
add wave -noupdate -format Literal -radix decimal /testbench/dut/triggerdata
add wave -noupdate -format Literal -expand /testbench/dut/triggerstrobes
add wave -noupdate -format Literal -radix decimal /testbench/dut/dataoutch0
add wave -noupdate -format Literal -radix decimal /testbench/dut/aligndatach0
add wave -noupdate -format Literal -radix decimal /testbench/dut/aligndatach1
add wave -noupdate -format Literal -radix decimal /testbench/dut/aligndatach2
add wave -noupdate -format Literal -radix decimal /testbench/dut/aligndatach3
add wave -noupdate -divider NormalTrigger
add wave -noupdate -format Literal /testbench/dut/normal/olhstrobe
add wave -noupdate -format Literal /testbench/dut/normal/ohlstrobe
add wave -noupdate -format Literal /testbench/dut/normal/ohigh
add wave -noupdate -format Literal /testbench/dut/normal/high
add wave -noupdate -format Literal /testbench/dut/normal/prev
add wave -noupdate -format Literal -radix unsigned /testbench/dut/normal/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2865892 ns} 0}
configure wave -namecolwidth 245
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
WaveRestoreZoom {2831735 ns} {3152737 ns}
