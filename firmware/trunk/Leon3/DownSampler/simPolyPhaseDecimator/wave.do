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
add wave -noupdate -divider {Polyphase Filter}
add wave -noupdate -format Literal -radix decimal /testbench/dut/coeff
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/r
add wave -noupdate -format Literal -radix decimal /testbench/dut/fir__0/data/ramdata
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/fir__0/data/r
add wave -noupdate -format Literal -radix decimal /testbench/dut/odata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2196808000 ns} 0}
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
WaveRestoreZoom {0 ns} {2355502800 ns}
