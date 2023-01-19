//control_registers_testbench
`timescale 1ns/1ns
module control_registers_tb;
	//input
		reg clk_i;              		//from outside
		reg rstn_i;						//from outside
		reg [1:0] cmd_i;				//from outside
		reg [5:0] cmd_addr_i;			//from outside
		reg [31:0] cmd_data_i;			//from outside
		reg [6:0] slv0_margin_i;		//from slave_fifo
		reg [6:0] slv1_margin_i;		//from slave_fifo
		reg [6:0] slv2_margin_i;		//from slave_fifo
	//output
		wire [31:0] cmd_data_o;			//to outside
		wire slv0_en_o;					//to slave_fifo
		wire slv1_en_o;					//to slave_fifo
		wire slv2_en_o;					//to slave_fifo
		wire [2:0] slv0_pkglen_o;		//to arbiter and slave_fifo
		wire [2:0] slv1_pkglen_o;		//to arbiter and slave_fifo
		wire [2:0] slv2_pkglen_o;		//to arbiter and slave_fifo
		wire [1:0] slv0_prio_o;			//to arbiter
		wire [1:0] slv1_prio_o;			//to arbiter
		wire [1:0] slv2_prio_o;			//to arbiter
		
	control_registers control_registers_test(
	//input
		.clk_i(clk_i),              	//from outside
		.rstn_i(rstn_i),				//from outside
		.cmd_i(cmd_i),					//from outside
		.cmd_addr_i(cmd_addr_i),		//from outside
		.cmd_data_i(cmd_data_i),		//from outside
		.slv0_margin_i(slv0_margin_i),	//from slave_fifo
		.slv1_margin_i(slv1_margin_i),	//from slave_fifo
		.slv2_margin_i(slv2_margin_i),	//from slave_fifo
	//output
		.cmd_data_o(cmd_data_o),		//to outside
		.slv0_en_o(slv0_en_o),			//to slave_fifo
		.slv1_en_o(slv1_en_o),			//to slave_fifo
		.slv2_en_o(slv2_en_o),			//to slave_fifo
		.slv0_pkglen_o(slv0_pkglen_o),	//to arbiter and slave_fifo
		.slv1_pkglen_o(slv1_pkglen_o),	//to arbiter and slave_fifo
		.slv2_pkglen_o(slv2_pkglen_o),	//to arbiter and slave_fifo
		.slv0_prio_o(slv0_prio_o),		//to arbiter
		.slv1_prio_o(slv1_prio_o),		//to arbiter
		.slv2_prio_o(slv2_prio_o)		//to arbiter
	);
	
	always #5 clk_i = ~clk_i;
	
	initial begin
		clk_i = 0;
		rstn_i = 1;
		cmd_data_i = 0;
		slv0_margin_i = 64;
		slv1_margin_i = 64;
		slv2_margin_i = 64;
		
/********************复位************************/		
		@(negedge clk_i);
		rstn_i = 0;
		
		@(negedge clk_i);
		rstn_i = 1;
		
/**************读写控制寄存器********************/	
		@(posedge clk_i);
		cmd_addr_i = 6'd0;
		cmd_i = 2'b10; 		//写
		cmd_data_i = 32'h2;
		
		@(posedge clk_i);
		cmd_addr_i = 6'd4;
		cmd_i = 2'b10; 
		cmd_data_i = 32'h4;
		
		@(posedge clk_i);
		cmd_addr_i = 6'd8;
		cmd_i = 2'b10;
		cmd_data_i = 32'h6;
		
		@(posedge clk_i);
		cmd_addr_i = 6'bz;
		cmd_i = 2'b00;		//不进行任何操作
		cmd_data_i = 32'h6;
		
		@(posedge clk_i);
		cmd_addr_i = 6'd0;
		cmd_i = 2'b10;
		cmd_data_i = 32'h8;
		
		@(posedge clk_i);
		cmd_addr_i = 6'd4;
		cmd_i = 2'b01;		//读
		cmd_data_i = 32'bz;
		
		@(posedge clk_i);
		cmd_addr_i = 6'd0;
		cmd_i = 2'b01;
		cmd_data_i = 32'bz;
		
		#50 ;
		
/***************读状态寄存器*********************/
		@(posedge clk_i);
		cmd_i = 2'b01;
		slv0_margin_i = 10;
		slv1_margin_i = 20;
		slv2_margin_i = 30;
	
		@(posedge clk_i);
		cmd_addr_i = 6'd12;

		@(posedge clk_i);
		cmd_addr_i = 6'd16;

		@(posedge clk_i);
		cmd_addr_i = 6'd20;

		#50 $finish;
		
	end
	
endmodule
		
		
		
		
		
		
		