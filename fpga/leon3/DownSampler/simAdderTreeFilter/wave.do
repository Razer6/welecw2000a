onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testbench/clk125
add wave -noupdate -format Logic /testbench/clk1000
add wave -noupdate -format Logic /testbench/resetasync
add wave -noupdate -format Literal -radix decimal /testbench/input
add wave -noupdate -format Literal -radix decimal /testbench/output
add wave -noupdate -format Literal /testbench/decimator
add wave -noupdate -format Literal -radix decimal /testbench/valid
add wave -noupdate -format Literal /testbench/drawcounter
add wave -noupdate -format Literal /testbench/j
add wave -noupdate -format Literal /testbench/k
add wave -noupdate -format Logic /testbench/drawvalid
add wave -noupdate -divider -height 100 Input
add wave -noupdate -format Analog-Step -radix decimal -scale 0.59999999999999998 /testbench/drawinput
add wave -noupdate -divider -height 100 {Output without Filters}
add wave -noupdate -format Analog-Step -radix decimal -scale 0.59999999999999998 /testbench/drawaliasing
add wave -noupdate -divider -height 100 Output
add wave -noupdate -format Analog-Step -radix decimal -scale 0.0030000000000000001 /testbench/drawoutput
add wave -noupdate -divider -height 100 AdderTreeFilter
add wave -noupdate -format Literal -radix unsigned /testbench/dut/idecimator
add wave -noupdate -format Literal /testbench/dut/ifilterdepth
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/tree
add wave -noupdate -format Logic /testbench/dut/ovalid
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/filtered
add wave -noupdate -format Literal -radix decimal /testbench/dut/dataout
add wave -noupdate -format Literal /testbench/dut/ostagedata
add wave -noupdate -format Logic /testbench/dut/ostagevalid
add wave -noupdate -format Literal /testbench/dut/idata
add wave -noupdate -format Literal -radix decimal /testbench/drawoutput
add wave -noupdate -format Literal -radix decimal /testbench/outputdata
add wave -noupdate -format Literal -radix decimal /testbench/dut/odata
add wave -noupdate -divider draw
add wave -noupdate -format Logic /testbench/drawvalid
add wave -noupdate -format Logic /testbench/valid
add wave -noupdate -format Literal -radix decimal /testbench/outputdata
add wave -noupdate -format Literal /testbench/i
add wave -noupdate -format Literal /testbench/j
add wave -noupdate -format Literal /testbench/k
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {170416698 ns} 0} {{Cursor 2} {49177225 ns} 0} {{Cursor 3} {106123054 ns} 0}
configure wave -namecolwidth 133
configure wave -valuecolwidth 431
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {104878808 ns} {105065968 ns}
