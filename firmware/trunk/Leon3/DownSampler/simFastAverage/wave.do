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
add wave -noupdate -format Analog-Step -radix decimal -scale 0.29999999999999999 /testbench/drawoutput
add wave -noupdate -divider -height 100 FastAverage
add wave -noupdate -format Literal /testbench/prevvalid
add wave -noupdate -format Literal -radix decimal /testbench/drawoutput
add wave -noupdate -format Literal -radix decimal -expand /testbench/outputdata
add wave -noupdate -format Literal -radix decimal /testbench/dut/odata
add wave -noupdate -format Literal -radix decimal /testbench/dut/shiftreg
add wave -noupdate -format Literal -radix decimal /testbench/dut/line1
add wave -noupdate -format Literal -radix decimal /testbench/dut/line2
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/line3
add wave -noupdate -format Literal -radix decimal /testbench/dut/line4
add wave -noupdate -format Literal /testbench/dut/m10state
add wave -noupdate -format Logic /testbench/dut/m10valid
add wave -noupdate -format Literal -radix decimal /testbench/dut/m10muxline1
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/m10line
add wave -noupdate -format Literal -radix decimal /testbench/dut/m10muxline4
add wave -noupdate -format Literal -radix decimal /testbench/dut/l10
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31350353 ns} 0} {{Cursor 2} {45588 ns} 0} {{Cursor 3} {16441000 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {16431843 ns} {16496157 ns}
