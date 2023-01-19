//arbiter testbench
`timescale 1ns/1ns
module arbiter_tb;
	//input
		reg 		clk_i;						//from outside
		reg 		rstn_i;						//from outside
		reg  [1:0] 	slv0_prio_i;				//from control_registers
		reg  [1:0] 	slv1_prio_i;				//from control_registers
		reg  [1:0] 	slv2_prio_i;				//from control_registers
		reg  [2:0] 	slv0_pkglen_i;				//from control_registers
		reg  [2:0] 	slv1_pkglen_i;				//from control_registers
		reg  [2:0] 	slv2_pkglen_i;				//from control_registers
		reg [31:0] 	slv0_data_i;				//from slave_fifo
		reg [31:0] 	slv1_data_i;				//from slave_fifo
		reg [31:0] 	slv2_data_i;				//from slave_fifo
		reg 		slv0_req_i;					//from slave_fifo
		reg 		slv1_req_i;					//from slave_fifo
		reg 		slv2_req_i;					//from slave_fifo
		reg 		slv0_valid_i;				//from slave_fifo
		reg 		slv1_valid_i;				//from slave_fifo
		reg 		slv2_valid_i;				//from slave_fifo
		reg 		f2a_id_req_i;				//from formatter
		reg 		f2a_ack_i;					//from formatter
	//output
		wire 		a2s0_ack_o;					//to slave_fifo
		wire 		a2s1_ack_o;					//to slave_fifo
		wire 		a2s2_ack_o;					//to slave_fifo
		wire 		a2f_valid_o;				//to formatter
		wire  [1:0] a2f_id_o;					//to formatter
		wire  [2:0] a2f_pkglen_sel_o;			//to formatter
		wire [31:0] a2f_data_o;					//to formatter
		
	arbiter arbiter_test(
	//input
		.clk_i(clk_i),							//from outside
		.rstn_i(rstn_i),						//from outside
		.slv0_prio_i(slv0_prio_i),				//from control_registers
		.slv1_prio_i(slv1_prio_i),				//from control_registers
		.slv2_prio_i(slv2_prio_i),				//from control_registers
		.slv0_pkglen_i(slv0_pkglen_i),			//from control_registers
		.slv1_pkglen_i(slv1_pkglen_i),			//from control_registers
		.slv2_pkglen_i(slv2_pkglen_i),			//from control_registers
		.slv0_data_i(slv0_data_i),				//from slave_fifo
		.slv1_data_i(slv1_data_i),				//from slave_fifo
		.slv2_data_i(slv2_data_i),				//from slave_fifo
		.slv0_req_i(slv0_req_i),				//from slave_fifo
		.slv1_req_i(slv1_req_i),				//from slave_fifo
		.slv2_req_i(slv2_req_i),				//from slave_fifo
		.slv0_valid_i(slv0_valid_i),			//from slave_fifo
		.slv1_valid_i(slv1_valid_i),			//from slave_fifo
		.slv2_valid_i(slv2_valid_i),			//from slave_fifo
		.f2a_id_req_i(f2a_id_req_i),			//from formatter
		.f2a_ack_i(f2a_ack_i),					//from formatter
	//output
		.a2s0_ack_o(a2s0_ack_o),				//to slave_fifo
		.a2s1_ack_o(a2s1_ack_o),				//to slave_fifo
		.a2s2_ack_o(a2s2_ack_o),				//to slave_fifo
		.a2f_valid_o(a2f_valid_o),				//to formatter
		.a2f_id_o(a2f_id_o),					//to formatter
		.a2f_pkglen_sel_o(a2f_pkglen_sel_o),	//to formatter
		.a2f_data_o(a2f_data_o)					//to formatter
	);
	
	always #5 clk_i = ~clk_i;
	
	initial begin
		clk_i 		  =  1'b0;
		rstn_i        =  1'b1;
		slv0_prio_i   =  2'dz;				
		slv1_prio_i   =  2'dz;				
		slv2_prio_i   =  2'dz;				
		slv0_pkglen_i =  3'dz;			
		slv1_pkglen_i =  3'dz;			
		slv2_pkglen_i =  3'dz;				
		slv0_data_i   = 32'bz;				
		slv1_data_i   = 32'bz;				
		slv2_data_i   = 32'bz;				
		slv0_req_i    =  1'b0;					
		slv1_req_i    =  1'b0;				
		slv2_req_i    =  1'b0;					
		slv0_valid_i  =  1'b0;				
		slv1_valid_i  =  1'b0;				
		slv2_valid_i  =  1'b0;				
		f2a_id_req_i  =  1'b0;				
		f2a_ack_i 	  =  1'b0;					

/********************复位************************/	
	
		@(negedge clk_i);
		rstn_i = 0;
		
		@(negedge clk_i);
		rstn_i = 1;
		
/********预设通道优先级、数据包长度、各通道发送请求*********/		
	
		@(negedge clk_i);
		slv0_prio_i   =  2'd1;	//通道0的优先级为1				
		slv1_prio_i   =  2'd1;	//通道1的优先级为1			
		slv2_prio_i   =  2'd2;	//通道2的优先级为2		
		slv0_pkglen_i =  3'd3;	//通道0的数据包长度为32		
		slv1_pkglen_i =  3'd2;  //通道1的数据包长度为16			
		slv2_pkglen_i =  3'd1;	//通道2的数据包长度为8			
	
		f2a_id_req_i  =  1'b1;	//打开formatter的发送数据请求			
		f2a_ack_i 	  =  1'b1;	//打开formatter的读响应	
		
		slv0_req_i    =  1'b1;					
		slv1_req_i    =  1'b1;				
		slv2_req_i    =  1'b1;		
	
/*****************数据和数据有效信号********************/
	//测试激励给出的数据最低位表示通道号，高位依次递增
	//发完一个通道的数据后改变优先级，发其他通道的数据
		@(posedge clk_i);
		slv0_data_i   = 32'd10;				
		slv1_data_i   = 32'd11;				
		slv2_data_i   = 32'd12;	
		slv0_valid_i  =  1'd1;				
		slv1_valid_i  =  1'd1;				
		slv2_valid_i  =  1'd1;		
		
		@(posedge clk_i);
		slv0_data_i   = 32'd20;				
		slv1_data_i   = 32'd21;				
		slv2_data_i   = 32'd22;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd30;				
		slv1_data_i   = 32'd31;				
		slv2_data_i   = 32'd32;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd40;				
		slv1_data_i   = 32'd41;				
		slv2_data_i   = 32'd42;	

		@(posedge clk_i);
		slv0_data_i   = 32'd50;				
		slv1_data_i   = 32'd51;				
		slv2_data_i   = 32'd52;	

		@(posedge clk_i);
		slv0_data_i   = 32'd60;				
		slv1_data_i   = 32'd61;				
		slv2_data_i   = 32'd62;	

		@(posedge clk_i);
		slv0_data_i   = 32'd70;				
		slv1_data_i   = 32'd71;				
		slv2_data_i   = 32'd72;	

		@(posedge clk_i);
		slv0_data_i   = 32'd80;				
		slv1_data_i   = 32'd81;				
		slv2_data_i   = 32'd82;	

		@(posedge clk_i);
		slv0_data_i   = 32'd90;				
		slv1_data_i   = 32'd91;				
		slv2_data_i   = 32'd92;	

		@(posedge clk_i);
		slv0_data_i   = 32'd100;				
		slv1_data_i   = 32'd101;				
		slv2_data_i   = 32'd102;	

		@(posedge clk_i);
		slv0_data_i   = 32'd110;				
		slv1_data_i   = 32'd111;				
		slv2_data_i   = 32'd112;	

		@(posedge clk_i);
		slv0_data_i   = 32'd120;				
		slv1_data_i   = 32'd121;				
		slv2_data_i   = 32'd122;	

		@(posedge clk_i);
		slv0_data_i   = 32'd130;				
		slv1_data_i   = 32'd131;				
		slv2_data_i   = 32'd132;	

		@(posedge clk_i);
		slv0_data_i   = 32'd140;				
		slv1_data_i   = 32'd141;				
		slv2_data_i   = 32'd142;	

		@(posedge clk_i);
		slv0_data_i   = 32'd150;				
		slv1_data_i   = 32'd151;				
		slv2_data_i   = 32'd152;	

		@(posedge clk_i);
		slv0_data_i   = 32'd160;				
		slv1_data_i   = 32'd161;				
		slv2_data_i   = 32'd162;	

		@(posedge clk_i);
		slv0_data_i   = 32'd170;				
		slv1_data_i   = 32'd171;				
		slv2_data_i   = 32'd172;	

		@(posedge clk_i);
		slv0_data_i   = 32'd180;				
		slv1_data_i   = 32'd181;				
		slv2_data_i   = 32'd182;	

		@(posedge clk_i);
		slv0_data_i   = 32'd190;				
		slv1_data_i   = 32'd191;				
		slv2_data_i   = 32'd192;	

		@(posedge clk_i);
		slv0_data_i   = 32'd200;				
		slv1_data_i   = 32'd201;				
		slv2_data_i   = 32'd202;	

		@(posedge clk_i);
		slv0_data_i   = 32'd210;				
		slv1_data_i   = 32'd211;				
		slv2_data_i   = 32'd212;	

		@(posedge clk_i);
		slv0_data_i   = 32'd220;				
		slv1_data_i   = 32'd221;				
		slv2_data_i   = 32'd222;	

		@(posedge clk_i);
		slv0_data_i   = 32'd230;				
		slv1_data_i   = 32'd231;				
		slv2_data_i   = 32'd232;	

		@(posedge clk_i);
		slv0_data_i   = 32'd240;				
		slv1_data_i   = 32'd241;				
		slv2_data_i   = 32'd242;	

		@(posedge clk_i);
		slv0_data_i   = 32'd250;				
		slv1_data_i   = 32'd251;				
		slv2_data_i   = 32'd252;	
		slv0_valid_i  =  1'd0;	//改变一次数据有效信号		

		@(posedge clk_i);
		slv0_data_i   = 32'd260;				
		slv1_data_i   = 32'd261;				
		slv2_data_i   = 32'd262;	
		slv0_valid_i  =  1'd1;				

		@(posedge clk_i);
		slv0_data_i   = 32'd270;				
		slv1_data_i   = 32'd271;				
		slv2_data_i   = 32'd272;	

		@(posedge clk_i);
		slv0_data_i   = 32'd280;				
		slv1_data_i   = 32'd281;				
		slv2_data_i   = 32'd282;	

		@(posedge clk_i);
		slv0_data_i   = 32'd290;				
		slv1_data_i   = 32'd291;				
		slv2_data_i   = 32'd292;	

		@(posedge clk_i);
		slv0_data_i   = 32'd300;				
		slv1_data_i   = 32'd301;				
		slv2_data_i   = 32'd302;	

		@(posedge clk_i);
		slv0_data_i   = 32'd310;				
		slv1_data_i   = 32'd311;				
		slv2_data_i   = 32'd312;	

		@(posedge clk_i);
		slv0_data_i   = 32'd320;				
		slv1_data_i   = 32'd321;				
		slv2_data_i   = 32'd322;	

		@(posedge clk_i);
		slv0_data_i   = 32'd330;				
		slv1_data_i   = 32'd331;				
		slv2_data_i   = 32'd332;	
		
		//改变优先级，发通道1
		@(negedge clk_i);
		slv0_prio_i   =  2'd1;	//通道0的优先级为1				
		slv1_prio_i   =  2'd0;	//通道1的优先级为0			
		slv2_prio_i   =  2'd2;	//通道2的优先级为2		
		
		@(posedge clk_i);
		slv0_data_i   = 32'd340;				
		slv1_data_i   = 32'd341;				
		slv2_data_i   = 32'd342;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd350;				
		slv1_data_i   = 32'd351;				
		slv2_data_i   = 32'd352;	

		@(posedge clk_i);
		slv0_data_i   = 32'd360;				
		slv1_data_i   = 32'd361;				
		slv2_data_i   = 32'd362;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd370;				
		slv1_data_i   = 32'd371;				
		slv2_data_i   = 32'd372;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd380;				
		slv1_data_i   = 32'd381;				
		slv2_data_i   = 32'd382;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd390;				
		slv1_data_i   = 32'd391;				
		slv2_data_i   = 32'd392;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd400;				
		slv1_data_i   = 32'd401;				
		slv2_data_i   = 32'd402;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd410;				
		slv1_data_i   = 32'd411;				
		slv2_data_i   = 32'd412;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd420;				
		slv1_data_i   = 32'd421;				
		slv2_data_i   = 32'd422;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd430;				
		slv1_data_i   = 32'd431;				
		slv2_data_i   = 32'd432;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd440;				
		slv1_data_i   = 32'd441;				
		slv2_data_i   = 32'd442;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd450;				
		slv1_data_i   = 32'd451;				
		slv2_data_i   = 32'd452;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd460;				
		slv1_data_i   = 32'd461;				
		slv2_data_i   = 32'd462;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd470;				
		slv1_data_i   = 32'd471;				
		slv2_data_i   = 32'd472;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd480;				
		slv1_data_i   = 32'd481;				
		slv2_data_i   = 32'd482;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd490;				
		slv1_data_i   = 32'd491;				
		slv2_data_i   = 32'd492;	
		
		//改变优先级，发通道2
		@(negedge clk_i);
		slv0_prio_i   =  2'd1;	//通道0的优先级为1				
		slv1_prio_i   =  2'd1;	//通道1的优先级为1			
		slv2_prio_i   =  2'd0;	//通道2的优先级为0	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd500;				
		slv1_data_i   = 32'd501;				
		slv2_data_i   = 32'd502;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd510;				
		slv1_data_i   = 32'd511;				
		slv2_data_i   = 32'd512;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd520;				
		slv1_data_i   = 32'd521;				
		slv2_data_i   = 32'd522;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd530;				
		slv1_data_i   = 32'd531;				
		slv2_data_i   = 32'd532;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd540;				
		slv1_data_i   = 32'd541;				
		slv2_data_i   = 32'd542;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd550;				
		slv1_data_i   = 32'd551;				
		slv2_data_i   = 32'd552;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd560;				
		slv1_data_i   = 32'd561;				
		slv2_data_i   = 32'd562;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd570;				
		slv1_data_i   = 32'd571;				
		slv2_data_i   = 32'd572;	
		
		@(posedge clk_i);
		slv0_data_i   = 32'd0;				
		slv1_data_i   = 32'd0;				
		slv2_data_i   = 32'd0;	
	
		#50 $finish;
	end
	
endmodule
		
		
		
		