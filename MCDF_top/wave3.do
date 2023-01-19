onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /MCDF_tb/clk_i
add wave -noupdate -radix unsigned /MCDF_tb/rstn_i
add wave -noupdate -radix unsigned /MCDF_tb/ch0_data_i
add wave -noupdate -radix unsigned /MCDF_tb/ch1_data_i
add wave -noupdate -radix unsigned /MCDF_tb/ch2_data_i
add wave -noupdate -radix unsigned /MCDF_tb/ch0_valid_i
add wave -noupdate -radix unsigned /MCDF_tb/ch1_valid_i
add wave -noupdate -radix unsigned /MCDF_tb/ch2_valid_i
add wave -noupdate -radix unsigned /MCDF_tb/cmd_i
add wave -noupdate -radix unsigned /MCDF_tb/cmd_addr_i
add wave -noupdate -radix unsigned /MCDF_tb/cmd_data_i
add wave -noupdate -radix unsigned /MCDF_tb/ch0_ready_o
add wave -noupdate -radix unsigned /MCDF_tb/ch1_ready_o
add wave -noupdate -radix unsigned /MCDF_tb/ch2_ready_o
add wave -noupdate -radix unsigned /MCDF_tb/cmd_data_o
add wave -noupdate -radix unsigned /MCDF_tb/fmt_chid_o
add wave -noupdate -radix unsigned /MCDF_tb/fmt_length_o
add wave -noupdate -radix unsigned /MCDF_tb/fmt_req_o
add wave -noupdate -radix unsigned /MCDF_tb/fmt_grant_i
add wave -noupdate -radix unsigned /MCDF_tb/fmt_data_o
add wave -noupdate -radix unsigned /MCDF_tb/fmt_start_o
add wave -noupdate -radix unsigned /MCDF_tb/fmt_end_o
add wave -noupdate -radix unsigned /MCDF_tb/fmt_current_state
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/clk_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/rstn_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/cmd_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/cmd_addr_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/cmd_data_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv0_margin_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv1_margin_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv2_margin_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/cmd_data_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv0_en_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv1_en_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv2_en_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv0_pkglen_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv1_pkglen_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv2_pkglen_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv0_prio_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv1_prio_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv2_prio_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv0_ctr_reg
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv1_ctr_reg
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv2_ctr_reg
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv0_state_reg
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv1_state_reg
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/control_registers/slv2_state_reg
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/clk_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/rstn_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/chx_data_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/chx_valid_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/slvx_en_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/a2sx_ack_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/slvx_pkglen_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/chx_ready_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/slvx_margin_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/slvx_data_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/slvx_valid_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/slvx_req_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/wr_ptr
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/rd_ptr
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/fifo_cnt
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/full_sf
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/empty_sf
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/PKG_length
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/flag_pkglength
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/data_send_cnt
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/slave_fifo_2/i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/clk_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/rstn_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv0_prio_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv1_prio_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv2_prio_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv0_pkglen_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv1_pkglen_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv2_pkglen_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv0_data_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv1_data_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv2_data_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv0_req_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv1_req_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv2_req_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv0_valid_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv1_valid_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slv2_valid_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/f2a_id_req_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/f2a_ack_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/a2s0_ack_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/a2s1_ack_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/a2s2_ack_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/a2f_valid_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/a2f_id_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/a2f_pkglen_sel_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/a2f_data_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/arbiter/slvx_req_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/clk_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/rstn_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/a2f_valid_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/a2f_pkglen_sel_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/a2f_id_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/a2f_data_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_grant_i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/f2a_id_req_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/f2a_ack_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_chid_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_length_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_req_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_data_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_start_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_end_o
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/current_state
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_wr_ptr
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_rd_ptr
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_cnt
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_rd_cnt
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_empty
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_full
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/fmt_send
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/i
add wave -noupdate -radix unsigned /MCDF_tb/MCDF_test/formatter/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 265
configure wave -valuecolwidth 57
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
WaveRestoreZoom {1040 ns} {1140 ns}
