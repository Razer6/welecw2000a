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
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/triggerdata
add wave -noupdate -format Literal -expand /testbench/dut/triggerstrobes
add wave -noupdate -format Literal -radix unsigned -expand /testbench/dut/itriggermem
add wave -noupdate -format Literal -radix hexadecimal -expand /testbench/dut/otriggermem
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/aligndata
add wave -noupdate -format Literal -radix unsigned -expand /testbench/dut/readalign
add wave -noupdate -format Literal -radix decimal /testbench/dut/readvalid
add wave -noupdate -divider NormalTrigger
add wave -noupdate -format Logic /testbench/dut/normal/ivalid
add wave -noupdate -format Literal -radix decimal /testbench/dut/normal/idata
add wave -noupdate -format Literal -radix decimal /testbench/dut/normal/ihighvalue
add wave -noupdate -format Literal -radix decimal /testbench/dut/normal/ilowvalue
add wave -noupdate -format Literal -radix unsigned /testbench/dut/normal/counter
add wave -noupdate -format Literal /testbench/dut/normal/prev
add wave -noupdate -format Literal /testbench/dut/normal/high
add wave -noupdate -format Literal /testbench/dut/normal/olhstrobe
add wave -noupdate -format Literal /testbench/dut/normal/ohlstrobe
add wave -noupdate -format Literal /testbench/dut/normal/olhglitch
add wave -noupdate -format Literal /testbench/dut/normal/ohlglitch
add wave -noupdate -format Literal /testbench/dut/normal/high
add wave -noupdate -format Literal /testbench/dut/normal/prev
add wave -noupdate -format Literal /testbench/lhglitchcounter
add wave -noupdate -format Literal /testbench/hlglitchcounter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {625038 ns} 0}
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
WaveRestoreZoom {0 ns} {120 ns}
