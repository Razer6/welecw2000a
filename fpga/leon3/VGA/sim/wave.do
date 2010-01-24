onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {VGA port}
add wave -noupdate -format Logic /testbench/svga0/rst
add wave -noupdate -format Logic /testbench/svga0/clk
add wave -noupdate -format Logic /testbench/svga0/vgaclk
add wave -noupdate -format Literal -expand /testbench/svga0/apbi
add wave -noupdate -format Literal -expand /testbench/svga0/apbo
add wave -noupdate -format Literal /testbench/svga0/ahbi
add wave -noupdate -format Literal /testbench/svga0/ahbo
add wave -noupdate -format Literal /testbench/svga0/clk_sel
add wave -noupdate -format Literal /testbench/svga0/t
add wave -noupdate -format Literal /testbench/svga0/tin
add wave -noupdate -format Literal /testbench/svga0/r
add wave -noupdate -format Literal /testbench/svga0/rin
add wave -noupdate -format Literal /testbench/svga0/sync_w
add wave -noupdate -format Literal /testbench/svga0/sync_ra
add wave -noupdate -format Literal /testbench/svga0/sync_rb
add wave -noupdate -format Literal /testbench/svga0/sync_c
add wave -noupdate -format Literal /testbench/svga0/read_status
add wave -noupdate -format Literal /testbench/svga0/write_status
add wave -noupdate -format Logic /testbench/svga0/write_en
add wave -noupdate -format Logic /testbench/svga0/res_mod
add wave -noupdate -format Logic /testbench/svga0/en_mod
add wave -noupdate -format Logic /testbench/svga0/fifo_en
add wave -noupdate -format Literal /testbench/svga0/dmai
add wave -noupdate -format Literal /testbench/svga0/dmao
add wave -noupdate -format Logic /testbench/svga0/equal
add wave -noupdate -format Literal /testbench/svga0/hmax
add wave -noupdate -format Literal /testbench/svga0/hfporch
add wave -noupdate -format Literal /testbench/svga0/hsyncpulse
add wave -noupdate -format Literal /testbench/svga0/hvideo
add wave -noupdate -format Literal /testbench/svga0/vmax
add wave -noupdate -format Literal /testbench/svga0/vfporch
add wave -noupdate -format Literal /testbench/svga0/vsyncpulse
add wave -noupdate -format Literal /testbench/svga0/vvideo
add wave -noupdate -format Literal /testbench/svga0/read_pointer_fifo
add wave -noupdate -format Literal /testbench/svga0/write_pointer_fifo
add wave -noupdate -format Literal /testbench/svga0/datain_fifo
add wave -noupdate -format Literal /testbench/svga0/dataout_fifo
add wave -noupdate -format Logic /testbench/svga0/vcc
add wave -noupdate -format Logic /testbench/svga0/read_en_fifo
add wave -noupdate -format Logic /testbench/svga0/write_en_fifo
add wave -noupdate -format Literal /testbench/svga0/r.color0
add wave -noupdate -format Literal /testbench/svga0/r.color1
add wave -noupdate -format Literal /testbench/svga0/t.data
add wave -noupdate -format Literal /testbench/svga0/planes
add wave -noupdate -format Literal /testbench/svga0/orplane
add wave -noupdate -format Literal /testbench/svga0/andplane
add wave -noupdate -format Literal -expand /testbench/svga0/vgao
add wave -noupdate -format Literal -label data /testbench/svga0/r.data
add wave -noupdate -divider RAM
add wave -noupdate -format Logic /testbench/mg2/rst
add wave -noupdate -format Logic /testbench/mg2/clk
add wave -noupdate -format Literal /testbench/mg2/ahbsi
add wave -noupdate -format Literal /testbench/mg2/ahbso
add wave -noupdate -format Literal /testbench/mg2/sri
add wave -noupdate -format Literal /testbench/mg2/sro
add wave -noupdate -format Literal /testbench/mg2/sdo
add wave -noupdate -format Literal /testbench/mg2/r
add wave -noupdate -format Literal /testbench/mg2/ri
add wave -noupdate -format Literal /testbench/mg2/rbdrive
add wave -noupdate -format Literal /testbench/mg2/ribdrive
add wave -noupdate -format Literal /testbench/memi
add wave -noupdate -format Literal /testbench/memo
add wave -noupdate -format Literal /testbench/ram/iaddr
add wave -noupdate -format Literal /testbench/ram/bdata
add wave -noupdate -format Logic /testbench/ram/ince
add wave -noupdate -format Logic /testbench/ram/inwe
add wave -noupdate -format Logic /testbench/ram/inoe
add wave -noupdate -divider dcom
add wave -noupdate -format Logic /testbench/dcom0/rst
add wave -noupdate -format Logic /testbench/dcom0/clk
add wave -noupdate -format Literal /testbench/dcom0/dmai
add wave -noupdate -format Literal /testbench/dcom0/dmao
add wave -noupdate -format Literal /testbench/dcom0/uarti
add wave -noupdate -format Literal /testbench/dcom0/uarto
add wave -noupdate -format Literal /testbench/dcom0/ahbi
add wave -noupdate -format Literal /testbench/dcom0/r
add wave -noupdate -format Literal /testbench/dcom0/rin
add wave -noupdate -format Literal /testbench/duarto
add wave -noupdate -format Literal /testbench/svga0/ahb_master/dmai
add wave -noupdate -format Literal /testbench/svga0/ahb_master/dmao
add wave -noupdate -format Literal /testbench/svga0/ahb_master/ahbi
add wave -noupdate -format Literal /testbench/svga0/ahb_master/ahbo
add wave -noupdate -format Literal -expand /testbench/svga0/ahb_master/r
add wave -noupdate -format Literal -expand /testbench/svga0/ahb_master/rin
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {260731830 ps} 0} {{Cursor 2} {202620000 ps} 0} {{Cursor 3} {7120513000 ps} 0}
configure wave -namecolwidth 243
configure wave -valuecolwidth 251
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
configure wave -timelineunits ps
update
WaveRestoreZoom {2730771153 ps} {2731100819 ps}
