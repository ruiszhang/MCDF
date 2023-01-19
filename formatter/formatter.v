/**********************************************************************************************************
模块名称：formatter
功能：formatter完整接收一个数据包后才开始发送。准备发送时将fmt_req置高，等待接收端的fmt_grant信号；
	  当fmt_grant信号变为高时，在下一个周期：fmt_req置低、fmt_start输出一个周期的高电平脉冲、fmt_data
	  开始送出第一个数据。数据开始发送后应接连发送，中间不允许有空闲周期（所以需要一个memory先完整
	  存入要发送的数据包）。在发送最后一个数据时，fmt_end信号应置高并保持一个周期。formatter必须完整
	  发送某一通道的数据包之后才可以准备发送下一个数据包。在发送数据报期间，fmt_chid和fmt_length应保持
	  不变，知道数据包发送结束。
注意：在读状态的时候不写入数据，在写状态的时候不读出数据。
**********************************************************************************************************/

module formatter(
	//input
		clk_i,								//from outside
		rstn_i,								//from outside
		a2f_valid_i,						//from arbiter
		a2f_pkglen_sel_i,					//from arbiter
		a2f_id_i,							//from arbiter
		a2f_data_i,							//from arbiter
		fmt_grant_i,						//from outside
	//output
		f2a_id_req_o,						//to arbiter
		f2a_ack_o,							//to arbiter
		fmt_chid_o,							//to outside
		fmt_length_o,						//to outside
		fmt_req_o,							//to outside
		fmt_data_o,							//to outside
		fmt_start_o,						//to outside
		fmt_end_o							//to outside
	//output for test	
		//current_state
		//fmt_cnt
	);
	
		input 		  clk_i;				//时钟信号
		input 		  rstn_i;				//复位信号，低电平有效
		input 		  a2f_valid_i;			//来自arbiter的数据有效信号
		input  [2:0]  a2f_pkglen_sel_i;		//来自arbiter的数据包长度
		input  [1:0]  a2f_id_i;				//来自arbiter的通道号
		input [31:0]  a2f_data_i;			//来自arbiter的数据
		input 		  fmt_grant_i;			//来自外部接收端的授权信号
		
		output reg	  	  f2a_id_req_o;			//送到arbiter的发送数据请求信号
		output reg	  	  f2a_ack_o;			//送到arbiter的读确认信号
		output reg	[1:0] fmt_chid_o;			//送到外部的通道号
		output reg	[5:0] fmt_length_o;			//送到外部的数据包长度
		output reg	      fmt_req_o;			//送到外部的发送数据请求信号
		output reg [31:0] fmt_data_o;			//送到外部的数据
		output reg	  	  fmt_start_o;			//开始发送数据信号
		output reg	  	  fmt_end_o;			//结束发送数据信号

		//output [6:0] fmt_cnt; 	  //需要7位，因为6位最多只能表示63
		
		
		reg [31:0] fmt_mem[63:0]; //formatter的存储单元，用于临时保存slave_fifo通过arbiter传来的数据
		reg [6:0] fmt_wr_ptr; 	  //最高位为状态位，低6位为数据位
		reg [6:0] fmt_rd_ptr; 	  //最高位为状态位，低6位为数据位
		wire [6:0] fmt_cnt; 	  //需要7位，因为6位最多只能表示63
		reg [5:0] fmt_rd_cnt;
		wire fmt_empty;
		wire fmt_full;
		reg fmt_send;  			  //fmt处于发送数据状态的标志信号
		
		assign fmt_empty = (fmt_wr_ptr == fmt_rd_ptr); 							//当读写指针的数据位和状态位都相同时，表示fmt空
		assign fmt_full  = ({~fmt_wr_ptr[6], fmt_wr_ptr[5:0]} == fmt_rd_ptr);   //当读写指针的数据位相同而状态位不同时，表示fmt满
		assign fmt_cnt   = fmt_wr_ptr - fmt_rd_ptr; 							//当前fmt的数据个数
		
		
/*--------------------------------------------------数据包长度解码: fmt_length_o-----------------------------------------------------*/		

	//数据包长度解码
	always @(posedge clk_i or negedge rstn_i)
	begin
		if(!rstn_i) fmt_length_o <= 6'd32; //数据包长度默认为32位
		else if(current_state == 3'd0)
		begin
			case(a2f_pkglen_sel_i)
				3'd0:		fmt_length_o <= 6'd4;
				3'd1:		fmt_length_o <= 6'd8;
				3'd2:		fmt_length_o <= 6'd16;
				3'd3:		fmt_length_o <= 6'd32;
				default:	fmt_length_o <= 6'd32;
			endcase
		end
		else fmt_length_o <= fmt_length_o;
	end
	
/*-----------------------------------------------------输出通道号: fmt_chid_o-------------------------------------------------------*/		
	//当电路在RECEIVE状态时才能改变输出通道号
	always @(posedge clk_i or negedge rstn_i)
	begin
		if(!rstn_i) fmt_chid_o <= 2'd3;
		else if(current_state == 3'd0) fmt_chid_o <= a2f_id_i;
		else fmt_chid_o <= fmt_chid_o;
	end	
	
/*---------------------------------------------------写入数据请求：f2a_id_req_o-----------------------------------------------------*/
	//只要fmt未满，就向arbiter发出数据请求
	always @(*)
	begin
		if(!rstn_i) f2a_id_req_o = 1'b0;
		else if(!fmt_full) f2a_id_req_o = 1'b1;
		else f2a_id_req_o = 1'b0;
	end
	
/*------------------------------------------------------向formatter写入数据----------------------------------------------------------*/		
	
	//更新写指针
	//当formatter的发送数据请求信号、读确认信号和来自arbiter的数据有效信号均为高时，且非满，将数据写入formatter的memory

	always @(posedge clk_i or negedge rstn_i)
	begin
		if(!rstn_i) fmt_wr_ptr <= 7'b0;
		else if(f2a_ack_o && f2a_id_req_o && a2f_valid_i && (!fmt_full)) fmt_wr_ptr <= fmt_wr_ptr + 1'b1;
		else fmt_wr_ptr <= fmt_wr_ptr;
	end
		
	//写数据
	integer i;
	always @(posedge clk_i or negedge rstn_i)
	begin
		if(!rstn_i) 
		begin: u_fmt
			for(i = 0; i < 64; i = i + 1)
				fmt_mem[i] <= 32'b0;
		end
		else if(f2a_ack_o && f2a_id_req_o && a2f_valid_i && (!fmt_full)) fmt_mem[fmt_wr_ptr[5:0]] <= a2f_data_i;
		else fmt_mem[fmt_wr_ptr[5:0]] <= fmt_mem[fmt_wr_ptr[5:0]];
	end
	
/*-----------------------------------------------------从formatter读出数据-----------------------------------------------------------*/
	
	//更新读指针
	//fmt处于发送数据状态且非空时进行读取
	//需要感应fmt_send信号的边沿，否则状态机的状态更新传递到always时序块内会晚一个周期
	always @(posedge clk_i or negedge rstn_i or posedge fmt_send or negedge fmt_send)
	begin
		if(!rstn_i ) fmt_rd_ptr <= 7'b0;
		else if(fmt_send && (!fmt_empty)) fmt_rd_ptr <= fmt_rd_ptr + 1'b1;
		else fmt_rd_ptr <= fmt_rd_ptr;
	end
	
	//读出数据
	always @(posedge clk_i or negedge rstn_i or posedge fmt_send or negedge fmt_send)
	begin
		if(!rstn_i) fmt_data_o <= 32'bz;
		else if(fmt_send && (!fmt_empty)) fmt_data_o <= fmt_mem[fmt_rd_ptr[5:0]];
		else fmt_data_o <= 32'bz;
	end
	
	//更新当前数据包读出数据计数器
	//读完一个数据包之后计数器清零
	always @(posedge clk_i or negedge rstn_i or posedge fmt_send or negedge fmt_send)
	begin
		if(!rstn_i || (fmt_rd_cnt == fmt_length_o)) fmt_rd_cnt <= 6'd0;
		else if(fmt_send && (!fmt_empty)) fmt_rd_cnt <= fmt_rd_cnt + 1'b1;
		else fmt_rd_cnt <= 6'd0;
	end
	
/*---------------------------------------------------------FMT状态机----------------------------------------------------------------*/	
	
	//output reg [2:0] current_state;
	reg [2:0] current_state;
	reg [2:0] next_state;
	parameter FMT_RECEIVE    = 3'b000;  //向formatter中写入数据
	parameter FMT_REQ 		 = 3'b001; 	//请求发送
	parameter FMT_WAIT_GRANT = 3'b010;  //等待发送允许
	parameter FMT_START 	 = 3'b011;  //开始发送
	parameter FMT_SEND 		 = 3'b100;  //正在发送
	parameter FMT_END 		 = 3'b101;  //结束发送

	always @(posedge clk_i or negedge rstn_i)
	begin
		if(!rstn_i) current_state <= FMT_RECEIVE;
		else current_state <= next_state;
	end
	
	always @(*)
	begin
		if(!rstn_i)
		begin
			next_state 	 =  FMT_RECEIVE;
			f2a_ack_o	 =  1'b0;
			fmt_req_o 	 =  1'b0;	
			fmt_send     =  1'b0;
			fmt_start_o  =  1'b0;			
			fmt_end_o    =  1'b0;
		end
		else
		begin
			case(current_state)
				FMT_RECEIVE: 	begin
									if(fmt_cnt < fmt_length_o - 1)
										begin
										next_state   =  FMT_RECEIVE;
										if((a2f_id_i == 2'd0) || (a2f_id_i == 2'd1) || (a2f_id_i == 2'd2)) f2a_ack_o = 1'b1;
										else f2a_ack_o = 1'b0;
										fmt_req_o 	 =  1'b0;			
										fmt_send     =  1'b0;
										fmt_start_o  =  1'b0;			
										fmt_end_o    =  1'b0;
										end
									else
										begin
										next_state   =  FMT_REQ;
										if((a2f_id_i == 2'd0) || (a2f_id_i == 2'd1) || (a2f_id_i == 2'd2)) f2a_ack_o = 1'b1;
										else f2a_ack_o = 1'b0;
										fmt_req_o 	 =  1'b0;			
										fmt_send     =  1'b0;
										fmt_start_o  =  1'b0;			
										fmt_end_o    =  1'b0;
										end
	
								end
				FMT_REQ:	 	begin
									if(fmt_cnt >= fmt_length_o)
										begin
										next_state   =  FMT_WAIT_GRANT;
										f2a_ack_o	 =  1'b1;
										fmt_req_o 	 =  1'b1;			
										fmt_send     =  1'b0;
										fmt_start_o  =  1'b0;			
										fmt_end_o    =  1'b0;
										end
									else
										begin
										next_state   =  FMT_REQ;
										f2a_ack_o	 =  1'b1;
										fmt_req_o 	 =  1'b1;			
										fmt_send     =  1'b0;
										fmt_start_o  =  1'b0;			
										fmt_end_o    =  1'b0;
										end
								end
				FMT_WAIT_GRANT: begin
									if(fmt_grant_i)
										begin
										next_state   =  FMT_START;
										f2a_ack_o	 =  1'b0;
										fmt_req_o 	 =  1'b1;			
										fmt_send     =  1'b0;
										fmt_start_o  =  1'b0;			
										fmt_end_o    =  1'b0;
										end
									else
										begin
										next_state   =  FMT_WAIT_GRANT;
										f2a_ack_o	 =  1'b0;
										fmt_req_o 	 =  1'b1;			
										fmt_send     =  1'b0;
										fmt_start_o  =  1'b0;			
										fmt_end_o    =  1'b0;
										end
								end
				
				FMT_START:		begin
									next_state   =  FMT_SEND;
									f2a_ack_o	 =  1'b0;
									fmt_req_o 	 =  1'b0;			
									fmt_send     =  1'b1;
									fmt_start_o  =  1'b1;			
									fmt_end_o    =  1'b0;
								end
				
				FMT_SEND:		begin
									if(fmt_rd_cnt < fmt_length_o - 1)
										begin
										next_state   =  FMT_SEND;
										f2a_ack_o	 =  1'b0;
										fmt_req_o 	 =  1'b0;			
										fmt_send     =  1'b1;
										fmt_start_o  =  1'b0;			
										fmt_end_o    =  1'b0;
										end
									else
										begin
										next_state   =  FMT_END;
										f2a_ack_o	 =  1'b0;
										fmt_req_o 	 =  1'b0;			
										fmt_send     =  1'b1;
										fmt_start_o  =  1'b0;			
										fmt_end_o    =  1'b0;
										end
								end
								
				FMT_END:		begin
									next_state   =  FMT_RECEIVE;
									f2a_ack_o	 =  1'b0;
									fmt_req_o 	 =  1'b0;			
									fmt_send     =  1'b1;
									fmt_start_o  =  1'b0;			
									fmt_end_o    =  1'b1;
								end
				default:		begin
									next_state   =  FMT_RECEIVE;
									f2a_ack_o	 =  1'b0;
									fmt_req_o 	 =  1'b0;			
									fmt_send     =  1'b0;
									fmt_start_o  =  1'b0;			
									fmt_end_o    =  1'b0;
								end
			endcase
		end
	end

endmodule	
		
		
		
		
		
		