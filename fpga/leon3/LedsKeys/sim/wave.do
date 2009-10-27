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
add wave -noupdate -format Logic /testbench/frontpanel/ikeysdata
add wave -noupdate -format Literal /testbench/frontpanel/okeys
add wave -noupdate -format Logic /testbench/frontpanel/oserialclk
add wave -noupdate -format Literal -expand /testbench/frontpanel/onfetchkeys
add wave -noupdate -format Literal /testbench/frontpanel/keyshiftreg
add wave -noupdate -format Literal /testbench/frontpanel/keycounter
add wave -noupdate -format Literal /testbench/frontpanel/icputoanalog
add wave -noupdate -format Logic /testbench/frontpanel/serialclk
add wave -noupdate -format Literal /testbench/frontpanel/ileds
add wave -noupdate -format Literal /testbench/frontpanel/oleds
add wave -noupdate -format Literal /testbench/frontpanel/ledshiftreg
add wave -noupdate -format Literal /testbench/frontpanel/ledcounter
add wave -noupdate -format Logic /testbench/frontpanel/ledstrobe
add wave -noupdate -format Literal /testbench/frontpanel/analogsettings
add wave -noupdate -format Literal /testbench/frontpanel/oanalogsettings
add wave -noupdate -format Logic /testbench/frontpanel/oanalogbusy
add wave -noupdate -divider Decoder
add wave -noupdate -format Logic /testbench/frontpanel/time_div/istrobe
add wave -noupdate -format Logic /testbench/frontpanel/time_div/iunstable
add wave -noupdate -format Logic /testbench/frontpanel/time_div/istable
add wave -noupdate -format Literal /testbench/frontpanel/time_div/ocounter
add wave -noupdate -format Literal /testbench/frontpanel/time_div/c
add wave -noupdate -format Literal /testbench/frontpanel/time_div/stable
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
add wave -noupdate -format Logic /testbench/frontpanel/ikeysdata
add wave -noupdate -format Literal /testbench/frontpanel/okeys
add wave -noupdate -format Logic /testbench/frontpanel/oserialclk
add wave -noupdate -format Literal -expand /testbench/frontpanel/onfetchkeys
add wave -noupdate -format Literal /testbench/frontpanel/keyshiftreg
add wave -noupdate -format Literal /testbench/frontpanel/keycounter
add wave -noupdate -format Literal /testbench/frontpanel/icputoanalog
add wave -noupdate -format Logic /testbench/frontpanel/serialclk
add wave -noupdate -format Literal /testbench/frontpanel/ileds
add wave -noupdate -format Literal /testbench/frontpanel/oleds
add wave -noupdate -format Literal /testbench/frontpanel/ledshiftreg
add wave -noupdate -format Literal /testbench/frontpanel/ledcounter
add wave -noupdate -format Logic /testbench/frontpanel/ledstrobe
add wave -noupdate -format Literal /testbench/frontpanel/analogsettings
add wave -noupdate -format Literal /testbench/frontpanel/oanalogsettings
add wave -noupdate -format Logic /testbench/frontpanel/oanalogbusy
add wave -noupdate -divider Decoder
add wave -noupdate -format Logic /testbench/frontpanel/time_div/istrobe
add wave -noupdate -format Logic /testbench/frontpanel/time_div/iunstable
add wave -noupdate -format Logic /testbench/frontpanel/time_div/istable
add wave -noupdate -format Literal /testbench/frontpanel/time_div/ocounter
add wave -noupdate -format Literal /testbench/frontpanel/time_div/c
add wave -noupdate -format Literal /testbench/frontpanel/time_div/stable
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {196864 ns} 0}
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
WaveRestoreZoom {1968827 ns} {2001641 ns}
