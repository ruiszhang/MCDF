//slave_fifo_testbench
`timescale 1ns/1ns
module slave_fifo_tb;
	//input
		reg 		clk_i;              //from outside
		reg 		rstn_i;				//from outside
		reg [31:0]  chx_data_i;			//from outside
		reg 		chx_valid_i;		//from outside
		reg 		slvx_en_i;			//from control_registers
		reg 		a2sx_ack_i;			//from arbiter
		reg [2:0] 	slvx_pkglen_i;		//from control_registers
	//output
		wire 		chx_ready_o;		//to outside
		wire [5:0]  slvx_margin_o;		//to control_registers
		wire [31:0] slvx_data_o;		//to arbiter
		wire 		slvx_valid_o;		//to arbiter
		wire 		slvx_req_o;			//to arbiter
		
	//output for test
		wire [6:0] wr_ptr;
		wire [6:0] rd_ptr;
		wire [6:0] fifo_cnt;
		wire flag_pkglength;
		
	slave_fifo slave_fifo_test(
	//input
		.clk_i(clk_i),              	//from outside
		.rstn_i(rstn_i),				//from outside
		.chx_data_i(chx_data_i),		//from outside
		.chx_valid_i(chx_valid_i),		//from outside
		.slvx_en_i(slvx_en_i),			//from control_registers
		.a2sx_ack_i(a2sx_ack_i),		//from arbiter
		.slvx_pkglen_i(slvx_pkglen_i),	//from control_registers
	//output
		.chx_ready_o(chx_ready_o),		//to outside
		.slvx_margin_o(slvx_margin_o),	//to control_registers
		.slvx_data_o(slvx_data_o),		//to arbiter
		.slvx_valid_o(slvx_valid_o),	//to arbiter
		.slvx_req_o(slvx_req_o),		//to arbiter
	//output for test
		.wr_ptr(wr_ptr),
		.rd_ptr(rd_ptr),
		.fifo_cnt(fifo_cnt),
		.flag_pkglength(flag_pkglength)
	);
	
	always #5 clk_i = ~clk_i;
	
	initial begin
		clk_i = 0;
		rstn_i = 1;
		chx_data_i = 32'd0;
		chx_valid_i = 0;
		slvx_en_i = 0;
		a2sx_ack_i = 0;
		slvx_pkglen_i = 3'd3; //数据包长度为32
			
		@(negedge clk_i);
		chx_data_i = 32'd10;
		chx_valid_i = 1;
		slvx_en_i = 1;	
		
		@(negedge clk_i);
		chx_data_i = 32'd20;
		
		@(negedge clk_i);
		rstn_i = 0;
		
		@(negedge clk_i);
		rstn_i = 1;
		
		@(negedge clk_i);
		chx_data_i = 32'd10;
		chx_valid_i = 1;
		slvx_en_i = 1;
		
		@(negedge clk_i);
		chx_data_i = 32'd20;
		
		@(negedge clk_i);
		chx_data_i = 32'd30;
		
		@(negedge clk_i);
		chx_data_i = 32'd40;
		
		@(negedge clk_i);
		chx_data_i = 32'd50;
		
		@(negedge clk_i);
		chx_data_i = 32'd60;
		
		@(negedge clk_i);
		chx_data_i = 32'd70;
		
		@(negedge clk_i);
		chx_data_i = 32'd80;
		
		@(negedge clk_i);
		chx_data_i = 32'd90;
		
		@(negedge clk_i);
		chx_data_i = 32'd100;
		
		@(negedge clk_i);
		chx_data_i = 32'd110;
		
		@(negedge clk_i);
		chx_data_i = 32'd120;
		
		@(negedge clk_i);
		chx_data_i = 32'd130;
		
		@(negedge clk_i);
		chx_data_i = 32'd140;
		
		@(negedge clk_i);
		chx_data_i = 32'd150;
		
		@(negedge clk_i);
		chx_data_i = 32'd160;
		
		@(negedge clk_i);
		chx_data_i = 32'd170;
		
		@(negedge clk_i);
		chx_data_i = 32'd180;
		
		
		@(negedge clk_i);
		chx_data_i = 32'd190;
		
		@(negedge clk_i);
		chx_data_i = 32'd200;
		
		@(negedge clk_i);
		chx_data_i = 32'd210;
		
		@(negedge clk_i);
		chx_data_i = 32'd220;
		
		@(negedge clk_i);
		chx_data_i = 32'd230;
		
		@(negedge clk_i);
		chx_data_i = 32'd240;
		
		@(negedge clk_i);
		chx_data_i = 32'd250;
		
		@(negedge clk_i);
		chx_data_i = 32'd260;
		
		@(negedge clk_i);
		chx_data_i = 32'd270;
		
		@(negedge clk_i);
		chx_data_i = 32'd280;
		
		@(negedge clk_i);
		chx_data_i = 32'd290;
		
		@(negedge clk_i);
		chx_data_i = 32'd300;
		
		@(negedge clk_i);
		chx_data_i = 32'd310;
		
		@(negedge clk_i);
		chx_data_i = 32'd320;
		
		@(negedge clk_i);
		chx_data_i = 32'd330;
		
		@(negedge clk_i);
		chx_data_i = 32'd350;
		
		@(negedge clk_i);
		chx_data_i = 32'd360;
		
		@(negedge clk_i);
		chx_data_i = 32'd370;
		
		@(negedge clk_i);
		chx_data_i = 32'd380;
		
		@(negedge clk_i);
		chx_data_i = 32'd390;
		
		@(negedge clk_i);
		chx_data_i = 32'd400;
		
		@(negedge clk_i);
		chx_data_i = 32'd410;
		
		@(negedge clk_i);
		chx_data_i = 32'd420;
		
		@(negedge clk_i);
		chx_data_i = 32'd430;
		
		@(negedge clk_i);
		chx_data_i = 32'd440;
		
		@(negedge clk_i);
		chx_data_i = 32'd450;
		
		@(negedge clk_i);
		chx_data_i = 32'd460;
		
		@(negedge clk_i);
		chx_data_i = 32'd470;
		
		@(negedge clk_i);
		chx_data_i = 32'd480;
		
		@(negedge clk_i);
		chx_data_i = 32'd490;
		
		@(negedge clk_i);
		chx_data_i = 32'd500;
		
		@(negedge clk_i);
		chx_data_i = 32'd510;
		
		@(negedge clk_i);
		chx_data_i = 32'd520;
		
		@(negedge clk_i);
		chx_data_i = 32'd530;
		
		@(negedge clk_i);
		chx_data_i = 32'd540;
		
		@(negedge clk_i);
		chx_data_i = 32'd550;
		
		@(negedge clk_i);
		chx_data_i = 32'd560;
		
		@(negedge clk_i);
		chx_data_i = 32'd570;
		
		@(negedge clk_i);
		chx_data_i = 32'd580;
		
		@(negedge clk_i);
		chx_data_i = 32'd590;
		
		@(negedge clk_i);
		chx_data_i = 32'd600;
		
		@(negedge clk_i);
		chx_data_i = 32'd610;
		
		@(negedge clk_i);
		chx_data_i = 32'd620;
		
		@(negedge clk_i);
		chx_data_i = 32'd630;
		
		@(negedge clk_i);
		chx_data_i = 32'd640;
		
		@(negedge clk_i);
		chx_data_i = 32'd650;
		
		@(negedge clk_i);
		chx_data_i = 32'd650;
		a2sx_ack_i = 1;	
		
		@(negedge clk_i);
		chx_data_i = 32'd660;
		
		@(negedge clk_i);
		chx_data_i = 32'd670;
		
		@(negedge clk_i);
		chx_data_i = 32'd680;
		
		@(negedge clk_i);
		chx_data_i = 32'd690;
		
		@(negedge clk_i);
		chx_data_i = 32'b0;
		
		#400 $finish;
		
	end
		
endmodule
		
		
		
		
		
		