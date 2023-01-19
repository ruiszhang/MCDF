onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /arbiter_tb/clk_i
add wave -noupdate -radix unsigned /arbiter_tb/rstn_i
add wave -noupdate -radix unsigned /arbiter_tb/slv0_prio_i
add wave -noupdate -radix unsigned /arbiter_tb/slv1_prio_i
add wave -noupdate -radix unsigned /arbiter_tb/slv2_prio_i
add wave -noupdate -radix unsigned /arbiter_tb/slv0_pkglen_i
add wave -noupdate -radix unsigned /arbiter_tb/slv1_pkglen_i
add wave -noupdate -radix unsigned /arbiter_tb/slv2_pkglen_i
add wave -noupdate -radix unsigned /arbiter_tb/slv0_data_i
add wave -noupdate -radix unsigned /arbiter_tb/slv1_data_i
add wave -noupdate -radix unsigned /arbiter_tb/slv2_data_i
add wave -noupdate -radix unsigned /arbiter_tb/slv0_req_i
add wave -noupdate -radix unsigned /arbiter_tb/slv1_req_i
add wave -noupdate -radix unsigned /arbiter_tb/slv2_req_i
add wave -noupdate -radix unsigned /arbiter_tb/slv0_valid_i
add wave -noupdate -radix unsigned /arbiter_tb/slv1_valid_i
add wave -noupdate -radix unsigned /arbiter_tb/slv2_valid_i
add wave -noupdate -radix unsigned /arbiter_tb/f2a_id_req_i
add wave -noupdate -radix unsigned /arbiter_tb/f2a_ack_i
add wave -noupdate -radix unsigned /arbiter_tb/a2s0_ack_o
add wave -noupdate -radix unsigned /arbiter_tb/a2s1_ack_o
add wave -noupdate -radix unsigned /arbiter_tb/a2s2_ack_o
add wave -noupdate -radix unsigned /arbiter_tb/a2f_valid_o
add wave -noupdate -radix unsigned /arbiter_tb/a2f_id_o
add wave -noupdate -radix unsigned /arbiter_tb/a2f_pkglen_sel_o
add wave -noupdate -radix unsigned /arbiter_tb/a2f_data_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {116 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 230
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {117 ns}
