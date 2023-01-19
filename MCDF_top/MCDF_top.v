/**********************************************************************************************************
模块名称：MCDF_top
功能：将系统命令由cmd_data_i模块写入control_registers，由control_registers给出对三个slave_fifo和arbiter的
	  控制信号，控制数据的写入。外部数据chx_data_i写入slave_fifo且达到一个完整的数据包后，slave_fifo向
	  arbiter发出发送数据请求，arbiter根据发送数据请求和优先级决定将哪个通道的数据输出到formatter中，
	  formatter收到一个完整的数据包之后将fmt_req_o置高，表明准备发送数据，当等到外界的fmt_grant_i信号，
	  则开始连续发送一个完整的数据包，中间没有空闲。数据开始输入slave_fifo到数据开始从formatter中输出至少
	  需要两个数据包长度的时钟周期。
注意：数据开始输入slave_fifo到数据开始从formatter中输出至少需要两个数据包长度的时钟周期，因为slave_fifo模块
	  和formatter模块均需要输入完整的数据包之后才开始输出。
**********************************************************************************************************/

module MCDF_top(
	//input
		clk_i,
		rstn_i,
		ch0_data_i,
		ch1_data_i,
		ch2_data_i,
		ch0_valid_i,
		ch1_valid_i,
		ch2_valid_i,
		cmd_i,
		cmd_addr_i,
		cmd_data_i,
		fmt_grant_i,
	//output
		ch0_ready_o,
		ch1_ready_o,
		ch2_ready_o,
		cmd_data_o,
		fmt_chid_o,
		fmt_length_o,
		fmt_req_o,
		fmt_data_o,
		fmt_start_o,
		fmt_end_o
	//output for test
		//fmt_current_state
	);
	
	input 		 clk_i;
	input 		 rstn_i;
	input [31:0] ch0_data_i;
	input [31:0] ch1_data_i;
	input [31:0] ch2_data_i;
	input 		 ch0_valid_i;
	input 		 ch1_valid_i;
	input 		 ch2_valid_i;
	input  [1:0] cmd_i;
	input  [5:0] cmd_addr_i;
	input [31:0] cmd_data_i;
	input 		 fmt_grant_i;
	
	output 		  ch0_ready_o;
	output 		  ch1_ready_o;
	output 		  ch2_ready_o;
	output [31:0] cmd_data_o;
	output  [1:0] fmt_chid_o;
	output  [5:0] fmt_length_o;
	output 		  fmt_req_o;
	output [31:0] fmt_data_o;
	output 		  fmt_start_o;
	output 		  fmt_end_o;
	
	//output for test
	//output [2:0] fmt_current_state;
	
	//control_registers ←→ slave_fifo
	wire 		slv0_en_w;
	wire 		slv1_en_w;
	wire 		slv2_en_w;
	wire [6:0]  slv0_margin_w;
	wire [6:0]  slv1_margin_w;
	wire [6:0]  slv2_margin_w;
	
	//control_registers ←→ arbiter
	wire [1:0] slv0_prio_w;
	wire [1:0] slv1_prio_w;
	wire [1:0] slv2_prio_w;
	wire [2:0] slv0_pkglen_w;
	wire [2:0] slv1_pkglen_w;
	wire [2:0] slv2_pkglen_w;
	
	//slave_fifo ←→ arbiter
	wire 		a2s0_ack_w;
	wire 		a2s1_ack_w;
	wire 		a2s2_ack_w;
	wire [31:0] slv0_data_w;
	wire [31:0] slv1_data_w;
	wire [31:0] slv2_data_w;
	wire 		slv0_valid_w;
	wire 		slv1_valid_w;
	wire 		slv2_valid_w;
	wire 		slv0_req_w;
	wire 		slv1_req_w;
	wire 		slv2_req_w;
	
	//arbiter ←→ formatter
	wire 		f2a_ack_w;
	wire 		f2a_id_req_w;
	wire [31:0] a2f_data_w;
	wire  [2:0] a2f_pkglen_sel_w;
	wire  [1:0] a2f_id_w;
	wire 		a2f_valid_w;
	
	control_registers control_registers(
		//input
			.clk_i(clk_i),             
			.rstn_i(rstn_i),				
			.cmd_i(cmd_i),				
			.cmd_addr_i(cmd_addr_i),			
			.cmd_data_i(cmd_data_i),			
			.slv0_margin_i(slv0_margin_w),		
			.slv1_margin_i(slv1_margin_w),		
			.slv2_margin_i(slv2_margin_w),		
		//output
			.cmd_data_o(cmd_data_o),			
			.slv0_en_o(slv0_en_w),			
			.slv1_en_o(slv1_en_w),			
			.slv2_en_o(slv2_en_w),			
			.slv0_pkglen_o(slv0_pkglen_w),		
			.slv1_pkglen_o(slv1_pkglen_w),		
			.slv2_pkglen_o(slv2_pkglen_w),		
			.slv0_prio_o(slv0_prio_w),		
			.slv1_prio_o(slv1_prio_w),		
			.slv2_prio_o(slv2_prio_w)			
		);
	
	slave_fifo slave_fifo_0(
		//input
			.clk_i(clk_i),              
			.rstn_i(rstn_i),				
			.chx_data_i(ch0_data_i),			
			.chx_valid_i(ch0_valid_i),		
			.slvx_en_i(slv0_en_w),			
			.a2sx_ack_i(a2s0_ack_w),			
			.slvx_pkglen_i(slv0_pkglen_w),		
		//output
			.chx_ready_o(ch0_ready_o),		
			.slvx_margin_o(slv0_margin_w),		
			.slvx_data_o(slv0_data_w),		
			.slvx_valid_o(slv0_valid_w),		
			.slvx_req_o(slv0_req_w)			
		);
	
	slave_fifo slave_fifo_1(
		//input
			.clk_i(clk_i),              
			.rstn_i(rstn_i),				
			.chx_data_i(ch1_data_i),			
			.chx_valid_i(ch1_valid_i),		
			.slvx_en_i(slv1_en_w),			
			.a2sx_ack_i(a2s1_ack_w),			
			.slvx_pkglen_i(slv1_pkglen_w),		
		//output
			.chx_ready_o(ch1_ready_o),		
			.slvx_margin_o(slv1_margin_w),		
			.slvx_data_o(slv1_data_w),		
			.slvx_valid_o(slv1_valid_w),		
			.slvx_req_o(slv1_req_w)			
		);
		
	slave_fifo slave_fifo_2(
		//input
			.clk_i(clk_i),              
			.rstn_i(rstn_i),				
			.chx_data_i(ch2_data_i),			
			.chx_valid_i(ch2_valid_i),		
			.slvx_en_i(slv2_en_w),			
			.a2sx_ack_i(a2s2_ack_w),			
			.slvx_pkglen_i(slv2_pkglen_w),		
		//output
			.chx_ready_o(ch2_ready_o),		
			.slvx_margin_o(slv2_margin_w),		
			.slvx_data_o(slv2_data_w),		
			.slvx_valid_o(slv2_valid_w),		
			.slvx_req_o(slv2_req_w)			
		);
	
	arbiter arbiter(
		//input
			.clk_i(clk_i),						
			.rstn_i(rstn_i),						
			.slv0_prio_i(slv0_prio_w),				
			.slv1_prio_i(slv1_prio_w),				
			.slv2_prio_i(slv2_prio_w),				
			.slv0_pkglen_i(slv0_pkglen_w),			
			.slv1_pkglen_i(slv1_pkglen_w),				
			.slv2_pkglen_i(slv2_pkglen_w),				
			.slv0_data_i(slv0_data_w),				
			.slv1_data_i(slv1_data_w),				
			.slv2_data_i(slv2_data_w),				
			.slv0_req_i(slv0_req_w),					
			.slv1_req_i(slv1_req_w),				
			.slv2_req_i(slv2_req_w),					
			.slv0_valid_i(slv0_valid_w),				
			.slv1_valid_i(slv1_valid_w),				
			.slv2_valid_i(slv2_valid_w),			
			.f2a_id_req_i(f2a_id_req_w),				
			.f2a_ack_i(f2a_ack_w),				
		//output
			.a2s0_ack_o(a2s0_ack_w),					
			.a2s1_ack_o(a2s1_ack_w),					
			.a2s2_ack_o(a2s2_ack_w),					
			.a2f_valid_o(a2f_valid_w),				
			.a2f_id_o(a2f_id_w),					
			.a2f_pkglen_sel_o(a2f_pkglen_sel_w),			
			.a2f_data_o(a2f_data_w)				
		);
		
	formatter formatter(
		//input
			.clk_i(clk_i),								
			.rstn_i(rstn_i),								
			.a2f_valid_i(a2f_valid_w),						
			.a2f_pkglen_sel_i(a2f_pkglen_sel_w),					
			.a2f_id_i(a2f_id_w),							
			.a2f_data_i(a2f_data_w),							
			.fmt_grant_i(fmt_grant_i),						
		//output
			.f2a_id_req_o(f2a_id_req_w),						
			.f2a_ack_o(f2a_ack_w),							
			.fmt_chid_o(fmt_chid_o),							
			.fmt_length_o(fmt_length_o),						
			.fmt_req_o(fmt_req_o),							
			.fmt_data_o(fmt_data_o),							
			.fmt_start_o(fmt_start_o),						
			.fmt_end_o(fmt_end_o)
		//output for test
			//.current_state(fmt_current_state)
		);
		
endmodule
	
	