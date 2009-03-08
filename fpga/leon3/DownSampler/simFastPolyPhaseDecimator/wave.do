onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testbench/clk125
add wave -noupdate -format Logic /testbench/resetasync
add wave -noupdate -format Literal -radix decimal /testbench/input
add wave -noupdate -format Literal -radix decimal /testbench/output
add wave -noupdate -divider -height 50 {New Divider}
add wave -noupdate -format Analog-Step -radix decimal -scale 0.29999999999999999 /testbench/drawinput
add wave -noupdate -divider -height 50 {New Divider}
add wave -noupdate -format Analog-Step -radix decimal -scale 0.29999999999999999 /testbench/drawaliasing
add wave -noupdate -divider -height 50 {New Divider}
add wave -noupdate -format Analog-Step -radix decimal -scale 0.001 /testbench/drawoutput
add wave -noupdate -divider -height 50 {New Divider}
add wave -noupdate -format Literal /testbench/m
add wave -noupdate -format Literal /testbench/decimator
add wave -noupdate -divider TopFastPolyphaseDecimator
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/coeff
add wave -noupdate -divider FastPolyPhaseDecimator
add wave -noupdate -format Logic /testbench/dut/iclk
add wave -noupdate -format Literal -radix decimal /testbench/dut/coeff
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/r
add wave -noupdate -format Logic /testbench/dut/fir__0/slave/iinputvalid
add wave -noupdate -format Logic /testbench/dut/fir__0/slave/isumvalid
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/fir__0/slave/r
add wave -noupdate -format Logic /testbench/dut/fir__0/slave/iresultvalid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {69059698 ns} 0} {{Cursor 2} {275357862 ns} 0}
configure wave -namecolwidth 210
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
WaveRestoreZoom {12864780 ns} {85316880 ns}
