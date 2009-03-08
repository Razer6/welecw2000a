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
add wave -noupdate -format Literal /testbench/dut/stage0avgdecimator
add wave -noupdate -format Literal -expand /testbench/dut/decimator
add wave -noupdate -format Literal -radix decimal /testbench/dut/stagedata0
add wave -noupdate -format Literal /testbench/dut/stagevalid0
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/stageinput
add wave -noupdate -format Literal -radix decimal /testbench/dut/stageoutput
add wave -noupdate -format Literal /testbench/dut/validout
add wave -noupdate -format Literal -radix decimal /testbench/dut/fastfirdata
add wave -noupdate -format Literal -radix decimal /testbench/dut/firdatain
add wave -noupdate -format Literal -radix decimal /testbench/dut/firdataout
add wave -noupdate -format Literal /testbench/dut/avgvalid
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
add wave -noupdate -format Literal /testbench/dut/control__0/c/aliasavgcounter
add wave -noupdate -format Literal -radix decimal /testbench/dut/control__0/c/aliasavg
add wave -noupdate -format Logic /testbench/dut/control__0/c/aliasavgvalid
add wave -noupdate -format Literal -radix decimal /testbench/dut/control__0/c/stagedata0
add wave -noupdate -format Logic /testbench/dut/control__0/c/stagevalid0
add wave -noupdate -format Literal /testbench/dut/stage0avgdecimator
add wave -noupdate -format Literal /testbench/dut/control__0/c/idecimation
add wave -noupdate -format Literal -radix decimal -expand /testbench/dut/control__0/c/stage
add wave -noupdate -format Literal -radix decimal /testbench/dut/control__0/c/aliasing
add wave -noupdate -format Literal /testbench/dut/control__0/c/dataoutcounter
add wave -noupdate -format Literal -radix decimal /testbench/dut/control__0/c/dataout
add wave -noupdate -divider FastAvg
add wave -noupdate -format Logic /testbench/dut/stage0__1/fastavg/iclk
add wave -noupdate -format Logic /testbench/dut/stage0__1/fastavg/iresetasync
add wave -noupdate -format Literal /testbench/dut/stage0__1/fastavg/idecimator
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/idata
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/odata
add wave -noupdate -format Logic /testbench/dut/stage0__1/fastavg/ovalid
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/ostagedata
add wave -noupdate -format Logic /testbench/dut/stage0__1/fastavg/ostagevalid
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/shiftreg
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/line1
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/line2
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/line3
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/line4
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/delayer
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/l10
add wave -noupdate -format Literal /testbench/dut/stage0__1/fastavg/l10regcounter
add wave -noupdate -format Literal /testbench/dut/stage0__1/fastavg/m10state
add wave -noupdate -format Logic /testbench/dut/stage0__1/fastavg/m10valid
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/m10muxline1
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/m10line
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage0__1/fastavg/m10muxline4
add wave -noupdate -divider FastPolyPhaseDecimator
add wave -noupdate -format Logic /testbench/dut/stage1/fir__0/slave/iclk
add wave -noupdate -format Logic /testbench/dut/stage1/fir__0/slave/iresetasync
add wave -noupdate -format Literal /testbench/dut/stage1/fir__0/slave/idecimator
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage1/fir__0/slave/idata
add wave -noupdate -format Logic /testbench/dut/stage1/fir__0/slave/iinputvalid
add wave -noupdate -format Logic /testbench/dut/stage1/fir__0/slave/isumvalid
add wave -noupdate -format Logic /testbench/dut/stage1/fir__0/slave/iresultvalid
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage1/fir__0/slave/icoeff
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage1/fir__0/slave/odata
add wave -noupdate -format Literal -radix decimal /testbench/dut/stage1/fir__0/slave/r
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
WaveRestoreCursors {{Cursor 1} {10470605979 ns} 0} {{Cursor 2} {4439997 ns} 0} {{Cursor 3} {366997114 ns} 0}
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
WaveRestoreZoom {0 ns} {10996650 us}
