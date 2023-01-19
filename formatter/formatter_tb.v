//formatter_testbench
`timescale 1ns/1ns
module formatter_tb;
	//input
	reg 		clk_i;								//from outside
	reg 		rstn_i;								//from outside
	reg 		a2f_valid_i;						//from arbiter
	reg  [2:0]  a2f_pkglen_sel_i;					//from arbiter
	reg  [1:0]  a2f_id_i;							//from arbiter
	reg [31:0]  a2f_data_i;							//from arbiter
	reg 		fmt_grant_i;						//from outside
	//output
	wire 		f2a_id_req_o;						//to arbiter
	wire 		f2a_ack_o;							//to arbiter
	wire  [1:0] fmt_chid_o;							//to outside
	wire  [5:0] fmt_length_o;						//to outside
	wire 		fmt_req_o;							//to outside
	wire [31:0] fmt_data_o;							//to outside
	wire 		fmt_start_o;						//to outside
	wire 		fmt_end_o;							//to outside
	//output for test	
	wire [2:0] current_state;
	wire [6:0] fmt_cnt;
	
	formatter formatter_test(
	//input
		.clk_i(clk_i),								//from outside
		.rstn_i(rstn_i),							//from outside
		.a2f_valid_i(a2f_valid_i),					//from arbiter
		.a2f_pkglen_sel_i(a2f_pkglen_sel_i),		//from arbiter
		.a2f_id_i(a2f_id_i),						//from arbiter
		.a2f_data_i(a2f_data_i),					//from arbiter
		.fmt_grant_i(fmt_grant_i),					//from outside
	//output
		.f2a_id_req_o(f2a_id_req_o),				//to arbiter
		.f2a_ack_o(f2a_ack_o),						//to arbiter
		.fmt_chid_o(fmt_chid_o),					//to outside
		.fmt_length_o(fmt_length_o),				//to outside
		.fmt_req_o(fmt_req_o),						//to outside
		.fmt_data_o(fmt_data_o),					//to outside
		.fmt_start_o(fmt_start_o),					//to outside
		.fmt_end_o(fmt_end_o),						//to outside
	//output for test	
		.current_state(current_state),
		.fmt_cnt(fmt_cnt)
	);
	
	always #5 clk_i = ~clk_i;
	
	initial begin
		clk_i 			 = 0;							
		rstn_i 			 = 1;							
		a2f_valid_i 	 = 0;						
		a2f_pkglen_sel_i = 3'd3;					
		a2f_id_i 		 = 2'd3;							
		a2f_data_i 		 = 32'bz;						
		fmt_grant_i 	 = 0;
		
/***************************复位*******************************/	
		@(negedge clk_i);
		rstn_i = 0;
		
		@(negedge clk_i);
		rstn_i = 1;	
	
/********************预设通道号和数据包长度********************/
		//通道0，数据包长度32
		@(posedge clk_i);
		a2f_id_i = 2'd0;
		a2f_pkglen_sel_i = 3'd3;		
		
/***************************接收数据***************************/	
		@(posedge clk_i);
		a2f_valid_i	 = 1;
		a2f_data_i 	 = 32'd10;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd20;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd30;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd40;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd50;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd60;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd70;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd80;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd90;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd100;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd110;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd120;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd130;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd140;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd150;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd160;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd170;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd180;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd190;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd200;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd210;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd220;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd230;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd240;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd250;	
		a2f_valid_i	 = 0;
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd260;	
		a2f_valid_i	 = 1;
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd270;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd280;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd290;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd300;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd310;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd320;	
		
		@(posedge clk_i);
		a2f_valid_i = 0;	
		
		@(posedge clk_i);
		a2f_valid_i = 1;	
		a2f_data_i	 = 32'd330;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'dz;	
		a2f_valid_i = 0;
		fmt_grant_i = 1;
		
		@(posedge clk_i);
		
		@(posedge clk_i);
		fmt_grant_i = 0;
		
		#320 ;
		
/*******************发送数据，同时改变通道接收数据**********************/	
		//通道1，数据包长度为16
		@(posedge clk_i);
		a2f_id_i = 2'd1;
		a2f_pkglen_sel_i = 3'd2;
		a2f_valid_i = 1;
		a2f_data_i 	 = 32'd11;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd21;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd31;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd41;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd51;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd61;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd71;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd81;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd91;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd101;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd111;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd121;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd131;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd141;	

		@(posedge clk_i);
		a2f_data_i 	 = 32'd151;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd161;	
		
		@(posedge clk_i);
		a2f_valid_i = 0;
		a2f_data_i 	 = 32'dz;	
		
		
		@(posedge clk_i);
		fmt_grant_i = 1;
		
		@(posedge clk_i);
		
		@(posedge clk_i);
		fmt_grant_i = 0;
		
		#150 ;
		
		//通道2，数据包长度为8
		@(posedge clk_i);
		a2f_id_i = 2'd2;
		a2f_pkglen_sel_i = 3'd1;
		a2f_valid_i = 1;
		a2f_data_i 	 = 32'd12;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd22;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd32;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd42;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd52;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd62;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd72;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'd82;	
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'dz;	
		a2f_valid_i = 0;
		
		
		@(posedge clk_i);
		fmt_grant_i = 1;
		
		@(posedge clk_i);
		
		@(posedge clk_i);
		fmt_grant_i = 0;
		
		#70 ;
		
/**************************停止写入数据**************************/
		
		@(posedge clk_i);
		a2f_data_i 	 = 32'dz;	
		a2f_valid_i = 0;
		
		#50 $finish;
	end
	
endmodule







