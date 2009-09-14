onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testbench/clk125
add wave -noupdate -format Logic /testbench/clk1000
add wave -noupdate -format Logic /testbench/resetasync
add wave -noupdate -format Literal -radix decimal /testbench/input
add wave -noupdate -format Literal -radix decimal /testbench/output
add wave -noupdate -format Literal /testbench/i
add wave -noupdate -format Literal /testbench/drawcounter
add wave -noupdate -format Literal /testbench/j
add wave -noupdate -divider -height 50 {New Divider}
add wave -noupdate -format Analog-Step -radix decimal -scale 0.29999999999999999 /testbench/drawinput
add wave -noupdate -divider -height 50 {New Divider}
add wave -noupdate -format Analog-Step -offset 10000.0 -radix decimal -scale 0.00040000000000000002 /testbench/drawoutput
add wave -noupdate -divider -height 50 50
add wave -noupdate -format Analog-Step -radix decimal -scale 0.20000000000000001 /testbench/drawaliasing
add wave -noupdate -divider -height 50 {New Divider}
add wave -noupdate -format Logic /testbench/valid
add wave -noupdate -format Literal /testbench/i
add wave -noupdate -format Logic /testbench/drawvalid
add wave -noupdate -divider TopDownSampler
add wave -noupdate -format Logic /testbench/dut/iclk
add wave -noupdate -format Logic /testbench/dut/iresetasync
add wave -noupdate -format Literal -radix decimal /testbench/dut/iadc
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/icpu
add wave -noupdate -format Literal -radix decimal /testbench/dut/odata
add wave -noupdate -format Logic /testbench/dut/ovalid
add wave -noupdate -format Literal -expand /testbench/dut/decimator
add wave -noupdate -format Literal -radix decimal /testbench/dut/stagedata0
add wave -noupdate -format Literal /testbench/dut/stagevalid0
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/stageinput
add wave -noupdate -format Literal -radix decimal /testbench/dut/stageoutput
add wave -noupdate -format Literal /testbench/dut/validout
add wave -noupdate -format Literal -radix decimal /testbench/dut/fastfirdata
add wave -noupdate -format Literal -radix decimal /testbench/dut/firdatain
add wave -noupdate -format Literal -radix decimal /testbench/dut/firdataout
add wave -noupdate -format Literal /testbench/dut/firvalid
add wave -noupdate -divider DownSampler
add wave -noupdate -format Logic /testbench/dut/control__0/c/iclk
add wave -noupdate -format Logic /testbench/dut/control__0/c/iresetasync
add wave -noupdate -format Literal /testbench/dut/control__0/c/ienablefilter
add wave -noupdate -format Logic /testbench/dut/control__0/c/istagevalid0
add wave -noupdate -format Literal -radix decimal /testbench/dut/control__0/c/istagedata0
add wave -noupdate -format Literal -radix decimal /testbench/dut/control__0/c/istage
add wave -noupdate -format Literal -radix decimal /testbench/dut/control__0/c/ostage
add wave -noupdate -format Literal -radix decimal /testbench/dut/control__0/c/odata
add wave -noupdate -format Logic /testbench/dut/control__0/c/ovalid
add wave -noupdate -format Literal -radix decimal /testbench/dut/control__0/c/stagedata0
add wave -noupdate -format Logic /testbench/dut/control__0/c/stagevalid0
add wave -noupdate -format Literal /testbench/dut/control__0/c/idecimation
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/control__0/c/stage
add wave -noupdate -format Literal -radix decimal /testbench/dut/control__0/c/aliasing
add wave -noupdate -format Literal /testbench/dut/control__0/c/dataoutcounter
add wave -noupdate -format Literal -radix decimal /testbench/dut/control__0/c/dataout
add wave -noupdate -divider FastAvg
add wave -noupdate -divider FastPolyPhaseDecimator
add wave -noupdate -divider PolyPhaseDecimator2
add wave -noupdate -format Logic /testbench/dut/slow__2/stage/iclk
add wave -noupdate -format Logic /testbench/dut/slow__2/stage/iresetasync
add wave -noupdate -format Literal /testbench/dut/slow__2/stage/idecimator
add wave -noupdate -format Literal -radix decimal /testbench/dut/slow__2/stage/idata
add wave -noupdate -format Logic /testbench/dut/slow__2/stage/ivalid
add wave -noupdate -format Literal -radix decimal /testbench/dut/slow__2/stage/odata
add wave -noupdate -format Logic /testbench/dut/slow__2/stage/ovalid
add wave -noupdate -format Literal -radix decimal /testbench/dut/slow__2/stage/coeff
add wave -noupdate -format Literal -radix decimal /testbench/dut/slow__2/stage/r
add wave -noupdate -divider {New Divider}
add wave -noupdate -divider -height 40 {New Divider}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19897712000 ns} 0} {{Cursor 2} {1600641620 ns} 0} {{Cursor 3} {12991939256 ns} 0}
configure wave -namecolwidth 224
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
WaveRestoreZoom {0 ns} {13623238673 ns}
