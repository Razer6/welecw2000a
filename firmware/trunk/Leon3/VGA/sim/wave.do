onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testbenchsimplevga/dut/iclk
add wave -noupdate -format Logic /testbenchsimplevga/dut/iresetasync
add wave -noupdate -format Literal -radix unsigned /testbenchsimplevga/dut/omem
add wave -noupdate -format Literal -radix unsigned /testbenchsimplevga/dut/imem
add wave -noupdate -format Literal -radix unsigned -expand /testbenchsimplevga/dut/vgarow
add wave -noupdate -format Literal -radix unsigned -expand /testbenchsimplevga/dut/vgaline
add wave -noupdate -format Logic /testbenchsimplevga/dut/ngenvgasignals
add wave -noupdate -format Logic /testbenchsimplevga/dut/pixelstrobe
add wave -noupdate -format Literal /testbenchsimplevga/dut/pixelclockcounter
add wave -noupdate -format Logic /testbenchsimplevga/dut/prevmembusy
add wave -noupdate -format Literal -radix unsigned -expand /testbenchsimplevga/dut/cache
add wave -noupdate -divider RAM
add wave -noupdate -format Literal -radix unsigned /testbenchsimplevga/ram/iaddr
add wave -noupdate -format Logic /testbenchsimplevga/ram/ince
add wave -noupdate -format Logic /testbenchsimplevga/ram/inwe
add wave -noupdate -format Logic /testbenchsimplevga/ram/inoe
add wave -noupdate -format Literal -radix unsigned /testbenchsimplevga/ram/bdata
add wave -noupdate -divider {VGA port}
add wave -noupdate -format Literal /testbenchsimplevga/vgasignal
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12341600 ns} 0}
configure wave -namecolwidth 329
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
WaveRestoreZoom {0 ns} {15750 us}
