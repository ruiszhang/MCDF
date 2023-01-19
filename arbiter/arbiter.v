/**********************************************************************************************
模块名称：arbiter
功能：当formatter的发送数据请求信号f2a_id_req_i为高时，arbiter根据三个通道的发送请求信号，
	  按优先级确定响应通道的发送请求，并根据通道号产生信号送到formatter；
	  若各通道优先级相同，则发送编号最低的通道数据。
难点：优先级由寄存器模块给出，在一次数据包的发送过程中不应该改变（在给测试激励时要注意）；
	  给一组优先级只能发送一个通道的信号，若要实现“轮流”，需要通过改变测试激励的优先级的方式。
**********************************************************************************************/

module arbiter(
	//input
		clk_i,						//from outside
		rstn_i,						//from outside
		slv0_prio_i,				//from control_registers
		slv1_prio_i,				//from control_registers
		slv2_prio_i,				//from control_registers
		slv0_pkglen_i,				//from control_registers
		slv1_pkglen_i,				//from control_registers
		slv2_pkglen_i,				//from control_registers
		slv0_data_i,				//from slave_fifo
		slv1_data_i,				//from slave_fifo
		slv2_data_i,				//from slave_fifo
		slv0_req_i,					//from slave_fifo
		slv1_req_i,					//from slave_fifo
		slv2_req_i,					//from slave_fifo
		slv0_valid_i,				//from slave_fifo
		slv1_valid_i,				//from slave_fifo
		slv2_valid_i,				//from slave_fifo
		f2a_id_req_i,				//from formatter
		f2a_ack_i,					//from formatter
	//output
		a2s0_ack_o,					//to slave_fifo
		a2s1_ack_o,					//to slave_fifo
		a2s2_ack_o,					//to slave_fifo
		a2f_valid_o,				//to formatter
		a2f_id_o,					//to formatter
		a2f_pkglen_sel_o,			//to formatter
		a2f_data_o					//to formatter
	);
		
	input 		 clk_i;					//时钟信号
	input 		 rstn_i;				//复位信号，低电平有效
	input  [1:0] slv0_prio_i;			//通道0的优先级
	input  [1:0] slv1_prio_i;			//通道1的优先级
	input  [1:0] slv2_prio_i;			//通道2的优先级
	input  [2:0] slv0_pkglen_i;			//通道0的数据包长度
	input  [2:0] slv1_pkglen_i;			//通道1的数据包长度
	input  [2:0] slv2_pkglen_i;			//通道2的数据包长度
	input [31:0] slv0_data_i;			//来自通道0的数据
	input [31:0] slv1_data_i;			//来自通道1的数据
	input [31:0] slv2_data_i;			//来自通道2的数据
	input 		 slv0_req_i;			//来自通道0的发送数据请求
	input 		 slv1_req_i;			//来自通道1的发送数据请求
	input 		 slv2_req_i;			//来自通道2的发送数据请求
	input 		 slv0_valid_i;			//来自通道0的数据有效信号
	input 		 slv1_valid_i;			//来自通道1的数据有效信号
	input 		 slv2_valid_i;			//来自通道2的数据有效信号
	input 		 f2a_id_req_i;			//来自formatter的发送数据请求信号
	input 		 f2a_ack_i;				//来自formatter的读确认信号
		
	output 		  	  a2s0_ack_o;		//送到通道0的读确认信号
	output 		  	  a2s1_ack_o;		//送到通道1的读确认信号
	output 		  	  a2s2_ack_o;		//送到通道2的读确认信号
	output reg	  	  a2f_valid_o;		//送到formatter数据有效信号
	output reg  [1:0] a2f_id_o;			//送到formatter的通道编号
	output reg  [2:0] a2f_pkglen_sel_o;	//送到formatter的数据包长度
	output reg [31:0] a2f_data_o;		//送到formatter的数据
	
	wire [2:0] slvx_req_i;				//各通道的发送请求
	assign slvx_req_i = {slv2_req_i, slv1_req_i, slv0_req_i};
	
/*-------------------------------------------输出通道号和数据包长度------------------------------------------------*/	
	
	//根据发送请求和优先级确定发送信号的通道和数据包长度（因为这两个信号是在一个数据包的发送过程中一直不变的）
	//优先级数字越小越优先
	//优先级相同时发编号低的通道
	always @(posedge clk_i or negedge rstn_i)
	begin
		if(!rstn_i) 
		begin 
			a2f_id_o <= 2'd3;
			a2f_pkglen_sel_o <= 3'dz;
		end
		else if(f2a_id_req_i)
		begin
			case(slvx_req_i)
				3'b000: begin 
							a2f_id_o 		 <= 2'd3;
							a2f_pkglen_sel_o <= 3'dz;
						end
				3'b001: begin 
							a2f_id_o 		 <= 2'd0;
							a2f_pkglen_sel_o <= slv0_pkglen_i;
						end
				3'b010: begin 
							a2f_id_o 		 <= 2'd1;
							a2f_pkglen_sel_o <= slv1_pkglen_i;
						end
				3'b100: begin 
							a2f_id_o 		 <= 2'd2;
							a2f_pkglen_sel_o <= slv2_pkglen_i;
						end
				3'b011: begin 
							if(slv1_prio_i >= slv0_prio_i) 
							begin
								a2f_id_o 		 <= 2'd0;
								a2f_pkglen_sel_o <= slv0_pkglen_i;
							end
							else 
							begin
								a2f_id_o 		 <= 2'd1;
								a2f_pkglen_sel_o <= slv1_pkglen_i;
							end
						end
				3'b101: begin 
							if(slv2_prio_i >= slv0_prio_i) 
							begin
								a2f_id_o 		 <= 2'd0;
								a2f_pkglen_sel_o <= slv0_pkglen_i;
							end
							else 
							begin
								a2f_id_o 		 <= 2'd2;
								a2f_pkglen_sel_o <= slv2_pkglen_i;
							end
						end
				3'b110: begin 
							if(slv2_prio_i >= slv1_prio_i) 
							begin
								a2f_id_o 		 <= 2'd1;
								a2f_pkglen_sel_o <= slv1_pkglen_i;
							end
							else 
							begin
								a2f_id_o 		 <= 2'd2;
								a2f_pkglen_sel_o <= slv2_pkglen_i;
							end
						end
				3'b111: begin 
							if((slv2_prio_i >= slv1_prio_i) && (slv1_prio_i >= slv0_prio_i))
								begin
									a2f_id_o 		 <= 2'd0;  		  //slv2>=slv1>=slv0
									a2f_pkglen_sel_o <= slv0_pkglen_i;
								end
							else if((slv2_prio_i >= slv1_prio_i) && (slv0_prio_i > slv1_prio_i)) 
								begin
									a2f_id_o 		 <= 2'd1;		  //slv2>=slv1, slv0>slv1
									a2f_pkglen_sel_o <= slv1_pkglen_i;
								end
							else if((slv1_prio_i > slv2_prio_i) && (slv0_prio_i > slv2_prio_i)) 
								begin
									a2f_id_o 		 <= 2'd2;		  //slv1>slv2, slv0>slv2
									a2f_pkglen_sel_o <= slv2_pkglen_i;
								end
							else 
							begin
								a2f_id_o 		 <= 2'd3;
								a2f_pkglen_sel_o <= 3'bz;
							end				
						end
				default: begin
							a2f_id_o 		 <= 2'd3;
							a2f_pkglen_sel_o <= 3'bz;
						 end
			endcase
		end
		else 	//当f2a_id_req_i为低电平时，保持选择的通道号和数据包长度不变
		begin
			a2f_id_o 		 <= a2f_id_o; 
			a2f_pkglen_sel_o <= a2f_pkglen_sel_o;
		end
	end
	
/*---------------------------------------------输出数据和数据有效信号---------------------------------------------------*/	
	
	//根据确定的通道输出数据内容和数据有效信号（这两个信号在一个数据包的发送过程中是可能改变的）
	//复位时通道号为3，输出数据为32'hffffffff，输出数据无效
	always @(*) //slvx_data_i和slvx_valid_i本来就是在时钟上升沿产生，所以此处不需要再约束，模块单独测试时在测试激励中约束
	begin
		if(!rstn_i)
		begin
			a2f_data_o 	<= 32'bz;
			a2f_valid_o <=  1'b0;
		end
		else 
		begin
			case(a2f_id_o)
				2'd0:	begin
							a2f_data_o 	<= slv0_data_i;
							a2f_valid_o <= slv0_valid_i;
						end
				2'd1:	begin
							a2f_data_o 	<= slv1_data_i;
							a2f_valid_o <= slv1_valid_i;
						end
				2'd2:	begin
							a2f_data_o 	<= slv2_data_i;
							a2f_valid_o <= slv2_valid_i;
						end
				2'd3:	begin
							a2f_data_o  <= 32'hffffffff;
							a2f_valid_o <=  1'b0;
						end
				default:begin
							a2f_data_o  <= 32'hffffffff;
							a2f_valid_o <=  1'b0;
						end
			endcase
		end
	end
	
	//向slave_fifo传递来自formatter的读确认信号
	assign a2s0_ack_o = (a2f_id_o == 2'd0)? f2a_ack_i : 1'b0;
	assign a2s1_ack_o = (a2f_id_o == 2'd1)? f2a_ack_i : 1'b0;
	assign a2s2_ack_o = (a2f_id_o == 2'd2)? f2a_ack_i : 1'b0;
	
endmodule
	
	
	
	
	
	