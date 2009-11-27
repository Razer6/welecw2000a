onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Testbench
add wave -noupdate -format Logic /testbench/clk
add wave -noupdate -format Logic /testbench/resetasync
add wave -noupdate -format Logic /testbench/serialclk
add wave -noupdate -format Literal /testbench/leds
add wave -noupdate -format Literal /testbench/keys
add wave -noupdate -format Literal /testbench/analogsettings
add wave -noupdate -format Logic /testbench/analogbusy
add wave -noupdate -format Literal /testbench/fptoleds
add wave -noupdate -format Literal /testbench/fptokeys
add wave -noupdate -format Literal /testbench/fptoanalog
add wave -noupdate -format Literal /testbench/dac_a
add wave -noupdate -format Literal /testbench/dac_b
add wave -noupdate -format Literal /testbench/asenable
add wave -noupdate -format Logic /testbench/dacen
add wave -noupdate -format Logic /testbench/asdch0
add wave -noupdate -format Logic /testbench/asdch1
add wave -noupdate -format Literal /testbench/ledsd
add wave -noupdate -format Literal /testbench/keysd
add wave -noupdate -format Literal /testbench/keydata
add wave -noupdate -divider Frontpanel
add wave -noupdate -format Logic /testbench/frontpanel/iclk
add wave -noupdate -format Logic /testbench/frontpanel/iresetasync
add wave -noupdate -format Logic /testbench/frontpanel/strobe
add wave -noupdate -format Literal -expand /testbench/frontpanel/okeys
add wave -noupdate -format Literal -expand /testbench/frontpanel/keystate
add wave -noupdate -format Logic /testbench/frontpanel/oserialclk
add wave -noupdate -format Logic /testbench/frontpanel/ikeysdata
add wave -noupdate -format Literal -expand /testbench/frontpanel/onfetchkeys
add wave -noupdate -format Literal /testbench/frontpanel/icputoanalog
add wave -noupdate -format Logic /testbench/frontpanel/serialclk
add wave -noupdate -format Literal /testbench/frontpanel/ledstate
add wave -noupdate -format Literal /testbench/frontpanel/ileds
add wave -noupdate -format Literal /testbench/frontpanel/oleds
add wave -noupdate -format Literal /testbench/frontpanel/analogsettings
add wave -noupdate -format Literal /testbench/frontpanel/oanalogsettings
add wave -noupdate -format Logic /testbench/frontpanel/oanalogbusy
add wave -noupdate -format Literal /testbench/frontpanel/pwm_offset
add wave -noupdate -divider Decoder
add wave -noupdate -format Logic /testbench/frontpanel/ch3_updn/iclk
add wave -noupdate -format Logic /testbench/frontpanel/ch3_updn/iresetasync
add wave -noupdate -format Logic /testbench/frontpanel/ch3_updn/ia
add wave -noupdate -format Logic /testbench/frontpanel/ch3_updn/ib
add wave -noupdate -format Literal /testbench/frontpanel/ch3_updn/ocounter
add wave -noupdate -format Literal /testbench/frontpanel/ch3_updn/c
add wave -noupdate -format Literal /testbench/frontpanel/ch3_updn/dir
add wave -noupdate -divider RandomDecoder
add wave -noupdate -format Logic /testbench/nob/dec/iclk
add wave -noupdate -format Logic /testbench/nob/dec/iresetasync
add wave -noupdate -format Logic /testbench/nob/dec/ia
add wave -noupdate -format Logic /testbench/nob/dec/ib
add wave -noupdate -format Literal /testbench/nob/dec/ocounter
add wave -noupdate -format Literal /testbench/nob/dec/p180/fsm/s180
add wave -noupdate -format Literal /testbench/nob/dec/c
add wave -noupdate -format Literal /testbench/nob/dec/dir
add wave -noupdate -divider Leds0
add wave -noupdate -format Logic /testbench/pleds__0/bank/isd
add wave -noupdate -format Logic /testbench/pleds__0/bank/isck
add wave -noupdate -format Logic /testbench/pleds__0/bank/insclr
add wave -noupdate -format Logic /testbench/pleds__0/bank/irck
add wave -noupdate -format Logic /testbench/pleds__0/bank/ig
add wave -noupdate -format Logic /testbench/pleds__0/bank/osd
add wave -noupdate -format Literal /testbench/pleds__0/bank/oq
add wave -noupdate -format Literal /testbench/pleds__0/bank/reg
add wave -noupdate -format Literal /testbench/pleds__0/bank/shift
add wave -noupdate -divider Leds1
add wave -noupdate -format Logic /testbench/pleds__1/bank/isd
add wave -noupdate -format Logic /testbench/pleds__1/bank/isck
add wave -noupdate -format Logic /testbench/pleds__1/bank/insclr
add wave -noupdate -format Logic /testbench/pleds__1/bank/irck
add wave -noupdate -format Logic /testbench/pleds__1/bank/ig
add wave -noupdate -format Logic /testbench/pleds__1/bank/osd
add wave -noupdate -format Literal /testbench/pleds__1/bank/oq
add wave -noupdate -format Literal /testbench/pleds__1/bank/reg
add wave -noupdate -format Literal /testbench/pleds__1/bank/shift
add wave -noupdate -format Literal /testbench/phyleds
add wave -noupdate -divider KeyData0
add wave -noupdate -format Logic /testbench/pkeys__0/bank/inmr
add wave -noupdate -format Logic /testbench/pkeys__0/bank/ince
add wave -noupdate -format Logic /testbench/pkeys__0/bank/inpe
add wave -noupdate -format Logic /testbench/pkeys__0/bank/ick
add wave -noupdate -format Literal /testbench/pkeys__0/bank/ipd
add wave -noupdate -format Logic /testbench/pkeys__0/bank/isd
add wave -noupdate -format Logic /testbench/pkeys__0/bank/oq
add wave -noupdate -format Logic /testbench/pkeys__0/bank/onq
add wave -noupdate -format Literal /testbench/pkeys__0/bank/shift
add wave -noupdate -divider KeyData6
add wave -noupdate -format Logic /testbench/pkeys__6/bank/inmr
add wave -noupdate -format Logic /testbench/pkeys__6/bank/ick
add wave -noupdate -format Logic /testbench/pkeys__6/bank/ince
add wave -noupdate -format Logic /testbench/pkeys__6/bank/inpe
add wave -noupdate -format Literal /testbench/pkeys__6/bank/ipd
add wave -noupdate -format Logic /testbench/pkeys__6/bank/isd
add wave -noupdate -format Logic /testbench/pkeys__6/bank/oq
add wave -noupdate -format Logic /testbench/pkeys__6/bank/onq
add wave -noupdate -format Literal /testbench/pkeys__6/bank/shift
add wave -noupdate -divider AnalogSettings
add wave -noupdate -divider Mux
add wave -noupdate -format Literal /testbench/mux/ia
add wave -noupdate -format Logic /testbench/mux/ine1
add wave -noupdate -format Logic /testbench/mux/ine2
add wave -noupdate -format Logic /testbench/mux/ie3
add wave -noupdate -format Literal /testbench/mux/oq
add wave -noupdate -divider DAC
add wave -noupdate -format Logic /testbench/dac/ince
add wave -noupdate -format Logic /testbench/dac/isck
add wave -noupdate -format Logic /testbench/dac/isd
add wave -noupdate -format Literal /testbench/dac/iref
add wave -noupdate -format Literal /testbench/dac/oa
add wave -noupdate -format Literal /testbench/dac/ob
add wave -noupdate -format Literal /testbench/dac/ignd
add wave -noupdate -format Literal /testbench/dac/shift
add wave -noupdate -format Literal /testbench/dac/a
add wave -noupdate -format Literal /testbench/dac/b
add wave -noupdate -format Logic /testbench/dac/aen
add wave -noupdate -format Logic /testbench/dac/ben
add wave -noupdate -format Logic /testbench/dac/au
add wave -noupdate -format Logic /testbench/dac/bu
add wave -noupdate -format Literal /testbench/dac/ao
add wave -noupdate -format Literal /testbench/dac/bo
add wave -noupdate -divider CH0
add wave -noupdate -format Literal -expand /testbench/frontpanel/analogsettings
add wave -noupdate -format Literal -expand /testbench/frontpanel/oanalogsettings
add wave -noupdate -format Logic /testbench/ch0_regl/clk
add wave -noupdate -format Logic /testbench/ch0_regl/str
add wave -noupdate -format Logic /testbench/ch0_regl/oe
add wave -noupdate -format Logic /testbench/ch0_regl/d
add wave -noupdate -format Logic /testbench/ch0_regl/qs
add wave -noupdate -format Logic /testbench/ch0_regl/qs2
add wave -noupdate -format Literal /testbench/ch0_regl/q
add wave -noupdate -format Literal /testbench/ch0_regl/shift
add wave -noupdate -format Literal /testbench/ch0_regl/latch
add wave -noupdate -format Logic /testbench/ch0_regh/clk
add wave -noupdate -format Logic /testbench/ch0_regh/str
add wave -noupdate -format Logic /testbench/ch0_regh/oe
add wave -noupdate -format Logic /testbench/ch0_regh/d
add wave -noupdate -format Logic /testbench/ch0_regh/qs
add wave -noupdate -format Logic /testbench/ch0_regh/qs2
add wave -noupdate -format Literal /testbench/ch0_regh/q
add wave -noupdate -format Literal /testbench/ch0_regh/shift
add wave -noupdate -format Literal /testbench/ch0_regh/latch
add wave -noupdate -divider CH1
add wave -noupdate -format Logic /testbench/ch1_regl/clk
add wave -noupdate -format Logic /testbench/ch1_regl/str
add wave -noupdate -format Logic /testbench/ch1_regl/oe
add wave -noupdate -format Logic /testbench/ch1_regl/d
add wave -noupdate -format Logic /testbench/ch1_regl/qs
add wave -noupdate -format Logic /testbench/ch1_regl/qs2
add wave -noupdate -format Literal /testbench/ch1_regl/q
add wave -noupdate -format Literal /testbench/ch1_regl/shift
add wave -noupdate -format Literal /testbench/ch1_regl/latch
add wave -noupdate -format Logic /testbench/ch1_regh/clk
add wave -noupdate -format Logic /testbench/ch1_regh/str
add wave -noupdate -format Logic /testbench/ch1_regh/oe
add wave -noupdate -format Logic /testbench/ch1_regh/d
add wave -noupdate -format Logic /testbench/ch1_regh/qs
add wave -noupdate -format Logic /testbench/ch1_regh/qs2
add wave -noupdate -format Literal /testbench/ch1_regh/q
add wave -noupdate -format Literal /testbench/ch1_regh/shift
add wave -noupdate -format Literal /testbench/ch1_regh/latch
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {130304 ns} 0} {{Cursor 2} {130656 ns} 0}
configure wave -namecolwidth 285
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
WaveRestoreZoom {32650842 ns} {32654979 ns}
