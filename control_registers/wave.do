onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /control_registers_tb/clk_i
add wave -noupdate -radix unsigned /control_registers_tb/rstn_i
add wave -noupdate -radix unsigned /control_registers_tb/cmd_i
add wave -noupdate -radix unsigned /control_registers_tb/cmd_addr_i
add wave -noupdate -radix unsigned /control_registers_tb/cmd_data_i
add wave -noupdate -radix unsigned /control_registers_tb/slv0_margin_i
add wave -noupdate -radix unsigned /control_registers_tb/slv1_margin_i
add wave -noupdate -radix unsigned /control_registers_tb/slv2_margin_i
add wave -noupdate -radix unsigned /control_registers_tb/cmd_data_o
add wave -noupdate -radix unsigned /control_registers_tb/slv0_en_o
add wave -noupdate -radix unsigned /control_registers_tb/slv1_en_o
add wave -noupdate -radix unsigned /control_registers_tb/slv2_en_o
add wave -noupdate -radix unsigned /control_registers_tb/slv0_pkglen_o
add wave -noupdate -radix unsigned /control_registers_tb/slv1_pkglen_o
add wave -noupdate -radix unsigned /control_registers_tb/slv2_pkglen_o
add wave -noupdate -radix unsigned /control_registers_tb/slv0_prio_o
add wave -noupdate -radix unsigned /control_registers_tb/slv1_prio_o
add wave -noupdate -radix unsigned /control_registers_tb/slv2_prio_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 256
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
WaveRestoreZoom {67 ns} {181 ns}
