onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /formatter_tb/clk_i
add wave -noupdate -radix unsigned /formatter_tb/rstn_i
add wave -noupdate -radix unsigned /formatter_tb/a2f_valid_i
add wave -noupdate -radix unsigned /formatter_tb/a2f_pkglen_sel_i
add wave -noupdate -radix unsigned /formatter_tb/a2f_id_i
add wave -noupdate -radix unsigned /formatter_tb/a2f_data_i
add wave -noupdate -radix unsigned /formatter_tb/f2a_id_req_o
add wave -noupdate -radix unsigned /formatter_tb/f2a_ack_o
add wave -noupdate -radix unsigned /formatter_tb/fmt_chid_o
add wave -noupdate -radix unsigned /formatter_tb/fmt_length_o
add wave -noupdate -radix unsigned /formatter_tb/fmt_req_o
add wave -noupdate -radix unsigned /formatter_tb/fmt_grant_i
add wave -noupdate -radix unsigned /formatter_tb/fmt_data_o
add wave -noupdate -radix unsigned /formatter_tb/fmt_start_o
add wave -noupdate -radix unsigned /formatter_tb/fmt_end_o
add wave -noupdate -radix unsigned /formatter_tb/current_state
add wave -noupdate -radix unsigned /formatter_tb/fmt_cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 219
configure wave -valuecolwidth 47
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
WaveRestoreZoom {0 ns} {126 ns}
