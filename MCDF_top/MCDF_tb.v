//MCDF_top testbench
module MCDF_tb;
	//input
	reg 		clk_i;
	reg 		rstn_i;
	reg [31:0]  ch0_data_i;
	reg [31:0]  ch1_data_i;
	reg [31:0]  ch2_data_i;
	reg	 		ch0_valid_i;
	reg 		ch1_valid_i;
	reg 		ch2_valid_i;
	reg  [1:0]  cmd_i;
	reg  [5:0]  cmd_addr_i;
	reg [31:0]  cmd_data_i;
	reg 		fmt_grant_i;
	//output
	wire 		ch0_ready_o;
	wire 		ch1_ready_o;
	wire 		ch2_ready_o;
	wire [31:0] cmd_data_o;
	wire  [1:0] fmt_chid_o;
	wire  [5:0] fmt_length_o;
	wire 		fmt_req_o;
	wire [31:0] fmt_data_o;
	wire 		fmt_start_o;
	wire 		fmt_end_o;
	//output for test
	//wire [2:0] fmt_current_state;

	MCDF_top MCDF_test(
	//input
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.ch0_data_i(ch0_data_i),
		.ch1_data_i(ch1_data_i),
		.ch2_data_i(ch2_data_i),
		.ch0_valid_i(ch0_valid_i),
		.ch1_valid_i(ch1_valid_i),
		.ch2_valid_i(ch2_valid_i),
		.cmd_i(cmd_i),
		.cmd_addr_i(cmd_addr_i),
		.cmd_data_i(cmd_data_i),
		.fmt_grant_i(fmt_grant_i),
	//output
		.ch0_ready_o(ch0_ready_o),
		.ch1_ready_o(ch1_ready_o),
		.ch2_ready_o(ch2_ready_o),
		.cmd_data_o(cmd_data_o),
		.fmt_chid_o(fmt_chid_o),
		.fmt_length_o(fmt_length_o),
		.fmt_req_o(fmt_req_o),
		.fmt_data_o(fmt_data_o),
		.fmt_start_o(fmt_start_o),
		.fmt_end_o(fmt_end_o)
	//output for test
		//.fmt_current_state(fmt_current_state)
	);
	
	always #5 clk_i = ~clk_i;
	
	initial begin 
		clk_i = 0;
		rstn_i = 1;
		ch0_data_i = 32'bz;
		ch1_data_i = 32'bz;
		ch2_data_i = 32'bz;
		ch0_valid_i = 0;
		ch1_valid_i = 0;
		ch2_valid_i = 0;
		cmd_i = 0;
		cmd_addr_i = 6'bz;
		cmd_data_i = 32'bz;
		fmt_grant_i = 0;
		
		@(negedge clk_i);
		rstn_i = 0;
		
		@(negedge clk_i);
		rstn_i = 1;	
		
/***************************测试通道0*******************************/			

		//写通道0的控制寄存器
		//通道使能，优先级为0，数据包长度为8
		@(negedge clk_i);
		cmd_i = 2'd2; 
		cmd_addr_i = 6'd0;
		cmd_data_i = 32'h9; 
		
		//写通道1的控制寄存器
		//通道使能，优先级为1，数据包长度为16
		@(negedge clk_i);
		cmd_i = 2'd2; 
		cmd_addr_i = 6'd4;
		cmd_data_i = 32'h13; 
		
		//写通道2的控制寄存器
		//通道使能，优先级为2，数据包长度为32
		@(negedge clk_i);
		cmd_i = 2'd2; 
		cmd_addr_i = 6'd8;
		cmd_data_i = 32'h1D; 
		
		//实时同步slave_fifo_0余量
		@(negedge clk_i);
		cmd_i = 2'd1; 
		cmd_addr_i = 6'd12;
		
		//向slave_fifo写入数据
		@(negedge clk_i);
		ch0_data_i = 32'd10;
		ch1_data_i = 32'd11;
		ch2_data_i = 32'd12;
		ch0_valid_i = 1;
		ch1_valid_i = 1;
		ch2_valid_i = 1;
		
		@(negedge clk_i);
		ch0_data_i = 32'd20;
		ch1_data_i = 32'd21;
		ch2_data_i = 32'd22;
		
		@(negedge clk_i);
		ch0_data_i = 32'd30;
		ch1_data_i = 32'd31;
		ch2_data_i = 32'd32;
		
		@(negedge clk_i);
		ch0_data_i = 32'd40;
		ch1_data_i = 32'd41;
		ch2_data_i = 32'd42;
		
		@(negedge clk_i);
		ch0_data_i = 32'd50;
		ch1_data_i = 32'd51;
		ch2_data_i = 32'd52;
		
		@(negedge clk_i);
		ch0_data_i = 32'd60;
		ch1_data_i = 32'd61;
		ch2_data_i = 32'd62;
		
		@(negedge clk_i);
		ch0_data_i = 32'd70;
		ch1_data_i = 32'd71;
		ch2_data_i = 32'd72;
		
		@(negedge clk_i);
		ch0_data_i = 32'd80;
		ch1_data_i = 32'd81;
		ch2_data_i = 32'd82;
		
		@(negedge clk_i);
		ch0_data_i = 32'd90;
		ch1_data_i = 32'd91;
		ch2_data_i = 32'd92;
		
		@(negedge clk_i);
		ch0_data_i = 32'd100;
		ch1_data_i = 32'd101;
		ch2_data_i = 32'd102;
		
		@(negedge clk_i);
		ch0_data_i = 32'bz;
		ch1_data_i = 32'bz;
		ch2_data_i = 32'bz;
		ch0_valid_i = 0;
		ch1_valid_i = 0;
		ch2_valid_i = 0;
		
		#100;
		
		@(posedge clk_i);
		fmt_grant_i = 1;
		
		#50;
		
		@(posedge clk_i);
		fmt_grant_i = 0;
		
		#50;
		
/***************************测试通道1*******************************/		
		
		//写通道0的控制寄存器
		//通道使能，优先级为1，数据包长度为8
		@(negedge clk_i);
		cmd_i = 2'd2; 
		cmd_addr_i = 6'd0;
		cmd_data_i = 32'hB; 
		
		//写通道1的控制寄存器
		//通道使能，优先级为0，数据包长度为16
		@(negedge clk_i);
		cmd_i = 2'd2; 
		cmd_addr_i = 6'd4;
		cmd_data_i = 32'h11; 
		
		//写通道2的控制寄存器
		//通道使能，优先级为2，数据包长度为32
		@(negedge clk_i);
		cmd_i = 2'd2; 
		cmd_addr_i = 6'd8;
		cmd_data_i = 32'h1D; 
		
		//实时同步slave_fifo_1余量
		@(negedge clk_i);
		cmd_i = 2'd1; 
		cmd_addr_i = 6'd16;
		
		//向slave_fifo写入数据
		@(negedge clk_i);
		ch0_data_i = 32'd110;
		ch1_data_i = 32'd111;
		ch2_data_i = 32'd112;
		ch0_valid_i = 0;
		ch1_valid_i = 1;
		ch2_valid_i = 1;	
		
		@(negedge clk_i);
		ch0_data_i = 32'd120;
		ch1_data_i = 32'd121;
		ch2_data_i = 32'd122;
		
		@(negedge clk_i);
		ch0_data_i = 32'd130;
		ch1_data_i = 32'd131;
		ch2_data_i = 32'd132;
		
		@(negedge clk_i);
		ch0_data_i = 32'd140;
		ch1_data_i = 32'd141;
		ch2_data_i = 32'd142;
		
		@(negedge clk_i);
		ch0_data_i = 32'd150;
		ch1_data_i = 32'd151;
		ch2_data_i = 32'd152;
		
		@(negedge clk_i);
		ch0_data_i = 32'd160;
		ch1_data_i = 32'd161;
		ch2_data_i = 32'd162;
		
		@(negedge clk_i);
		ch0_data_i = 32'd170;
		ch1_data_i = 32'd171;
		ch2_data_i = 32'd172;
		
		@(negedge clk_i);
		ch0_data_i = 32'd180;
		ch1_data_i = 32'd181;
		ch2_data_i = 32'd182;
		
		@(negedge clk_i);
		ch0_data_i = 32'bz;
		ch1_data_i = 32'bz;
		ch2_data_i = 32'bz;
		ch0_valid_i = 0;
		ch1_valid_i = 0;
		ch2_valid_i = 0;
		
		#200;
		
		@(posedge clk_i);
		fmt_grant_i = 1;
		
		#100;
		
		@(posedge clk_i);
		fmt_grant_i = 0;
		
		#200;
		
/***************************测试通道2*******************************/	

		//写通道0的控制寄存器
		//通道使能，优先级为1，数据包长度为8
		@(negedge clk_i);
		cmd_i = 2'd2; 
		cmd_addr_i = 6'd0;
		cmd_data_i = 32'hB; 
		
		//写通道1的控制寄存器
		//通道使能，优先级为2，数据包长度为16
		@(negedge clk_i);
		cmd_i = 2'd2; 
		cmd_addr_i = 6'd4;
		cmd_data_i = 32'h15; 
		
		//写通道2的控制寄存器
		//通道使能，优先级为0，数据包长度为32
		@(negedge clk_i);
		cmd_i = 2'd2; 
		cmd_addr_i = 6'd8;
		cmd_data_i = 32'h19; 
		
		//实时同步slave_fifo_2余量
		@(negedge clk_i);
		cmd_i = 2'd1; 
		cmd_addr_i = 6'd20;
		
		//向slave_fifo写入数据	
		@(negedge clk_i);
		ch0_data_i = 32'd190;
		ch1_data_i = 32'd191;
		ch2_data_i = 32'd192;
		ch0_valid_i = 0;
		ch1_valid_i = 0;
		ch2_valid_i = 1;	
		
		@(negedge clk_i);
		ch0_data_i = 32'd200;
		ch1_data_i = 32'd201;
		ch2_data_i = 32'd202;
		
		@(negedge clk_i);
		ch0_data_i = 32'd210;
		ch1_data_i = 32'd211;
		ch2_data_i = 32'd212;
		
		@(negedge clk_i);
		ch0_data_i = 32'd220;
		ch1_data_i = 32'd221;
		ch2_data_i = 32'd222;
		
		@(negedge clk_i);
		ch0_data_i = 32'd230;
		ch1_data_i = 32'd231;
		ch2_data_i = 32'd232;
		
		@(negedge clk_i);
		ch0_data_i = 32'd240;
		ch1_data_i = 32'd241;
		ch2_data_i = 32'd242;
		
		@(negedge clk_i);
		ch0_data_i = 32'd250;
		ch1_data_i = 32'd251;
		ch2_data_i = 32'd252;
		
		@(negedge clk_i);
		ch0_data_i = 32'd260;
		ch1_data_i = 32'd261;
		ch2_data_i = 32'd262;
		
		@(negedge clk_i);
		ch0_data_i = 32'd270;
		ch1_data_i = 32'd271;
		ch2_data_i = 32'd272;
		
		@(negedge clk_i);
		ch0_data_i = 32'd280;
		ch1_data_i = 32'd281;
		ch2_data_i = 32'd282;
		
		@(negedge clk_i);
		ch0_data_i = 32'd290;
		ch1_data_i = 32'd291;
		ch2_data_i = 32'd292;
		
		@(negedge clk_i);
		ch0_data_i = 32'd300;
		ch1_data_i = 32'd301;
		ch2_data_i = 32'd302;
		
		@(negedge clk_i);
		ch0_data_i = 32'd310;
		ch1_data_i = 32'd311;
		ch2_data_i = 32'd312;
		
		@(negedge clk_i);
		ch0_data_i = 32'd320;
		ch1_data_i = 32'd321;
		ch2_data_i = 32'd322;
		
		@(negedge clk_i);
		ch0_data_i = 32'd330;
		ch1_data_i = 32'd331;
		ch2_data_i = 32'd332;
		
		@(negedge clk_i);
		ch0_data_i = 32'd340;
		ch1_data_i = 32'd341;
		ch2_data_i = 32'd342;
		
		@(negedge clk_i);
		ch0_data_i = 32'd350;
		ch1_data_i = 32'd351;
		ch2_data_i = 32'd352;
		
		@(negedge clk_i);
		ch0_data_i = 32'bz;
		ch1_data_i = 32'bz;
		ch2_data_i = 32'bz;
		ch0_valid_i = 0;
		ch1_valid_i = 0;
		ch2_valid_i = 0;
		
		#400;
		
		@(posedge clk_i);
		fmt_grant_i = 1;
		
		#100;
		
		@(posedge clk_i);
		fmt_grant_i = 0;
	
		#500 $finish;		
		
	end
	
endmodule
		
		