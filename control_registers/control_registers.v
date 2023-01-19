/**********************************************************************************
模块名称：control_registers
功能：当cmd为写指令时，将输入数据cmd_data_i写入cmd_addr指定的寄存器中；
	  当cmd为读指令时，从cmd_addr指定的寄存器中读出数据到cmd_data_o；
	  共有6个寄存器，分别是3个通道的控制寄存器和状态寄存器；
	  包括通道使能、通道优先级、数据包长度、FIFO实时余量信息；
	  总线数据cmd_data_i只有低6位被使用。
注意：在always时序块中，时钟上升沿的赋值导致的变化在下一个周期给出。
**********************************************************************************/

module control_registers(
	//input
		clk_i,              //from outside
		rstn_i,				//from outside
		cmd_i,				//from outside
		cmd_addr_i,			//from outside
		cmd_data_i,			//from outside
		slv0_margin_i,		//from slave_fifo
		slv1_margin_i,		//from slave_fifo
		slv2_margin_i,		//from slave_fifo
	//output
		cmd_data_o,			//to outside
		slv0_en_o,			//to slave_fifo
		slv1_en_o,			//to slave_fifo
		slv2_en_o,			//to slave_fifo
		slv0_pkglen_o,		//to arbiter and slave_fifo
		slv1_pkglen_o,		//to arbiter and slave_fifo
		slv2_pkglen_o,		//to arbiter and slave_fifo
		slv0_prio_o,		//to arbiter
		slv1_prio_o,		//to arbiter
		slv2_prio_o			//to arbiter
	);
	
	input 		 clk_i;						//时钟信号
	input 		 rstn_i;		    		//复位信号，低电平有效
	input [1:0]  cmd_i;			    		//读/写控制指令
	input [5:0]  cmd_addr_i;	    		//命令地址
	input [31:0] cmd_data_i;				//命令数据输入
	input [6:0]  slv0_margin_i;				//通道0数据边界
	input [6:0]  slv1_margin_i;				//通道1数据边界
	input [6:0]  slv2_margin_i;				//通道2数据边界
	
	output reg [31:0] cmd_data_o;			//命令数据输出
	output  		  slv0_en_o;			//通道0使能信号
	output  		  slv1_en_o;			//通道1使能信号
	output  		  slv2_en_o;			//通道2使能信号
	output  	[2:0] slv0_pkglen_o;		//通道0数据包长度
	output  	[2:0] slv1_pkglen_o;		//通道1数据包长度
	output  	[2:0] slv2_pkglen_o;		//通道2数据包长度
	output  	[1:0] slv0_prio_o;			//通道0优先级
	output  	[1:0] slv1_prio_o;			//通道1优先级
	output  	[1:0] slv2_prio_o;			//通道2优先级
	
	parameter READ = 2'b01, WRITE = 2'b10;	//读写控制命令
	parameter CMD_SLV0_CTR_ADDR   = 6'd0;	//通道0的控制寄存器地址
	parameter CMD_SLV1_CTR_ADDR   = 6'd4;	//通道1的控制寄存器地址
	parameter CMD_SLV2_CTR_ADDR   = 6'd8;	//通道2的控制寄存器地址
	parameter CMD_SLV0_STATE_ADDR = 6'd12;	//通道0的状态寄存器地址
	parameter CMD_SLV1_STATE_ADDR = 6'd16;	//通道1的状态寄存器地址
	parameter CMD_SLV2_STATE_ADDR = 6'd20;	//通道2的状态寄存器地址
	
	
	//控制寄存器，可读写，通道使能、数据包长度
	reg [31:0] slv0_ctr_reg;		
	reg [31:0] slv1_ctr_reg;
	reg [31:0] slv2_ctr_reg;
	
	//状态寄存器，只读，实时同步FIFO余量
	reg [31:0] slv0_state_reg;
	reg [31:0] slv1_state_reg; 
	reg [31:0] slv2_state_reg; 
	
	//更新状态寄存器
	//复位值为FIFO深度64
	always @(posedge clk_i or negedge rstn_i) //异步复位
	begin
		if(!rstn_i)
		begin
			slv0_state_reg <= 32'd64;
			slv1_state_reg <= 32'd64;
			slv2_state_reg <= 32'd64;
		end
		else
		begin
			slv0_state_reg <= {25'b0, slv0_margin_i};
			slv1_state_reg <= {25'b0, slv1_margin_i};
			slv2_state_reg <= {25'b0, slv2_margin_i};
		end
	end
	
	//更新控制寄存器
	//复位值为7（低三位为111），写操作时低六位写入cmd_data_i的低六位，高位不可写入
	//32位cmd_data_i只有低6位被使用
	always @(posedge clk_i or negedge rstn_i)
	begin
		if(!rstn_i)
		begin
			slv0_ctr_reg <= 32'd7;
			slv1_ctr_reg <= 32'd7;
			slv2_ctr_reg <= 32'd7;
		end
		else if(cmd_i == WRITE)
		begin
			case(cmd_addr_i)
				CMD_SLV0_CTR_ADDR: slv0_ctr_reg <= {26'd0, cmd_data_i[5:0]};
				CMD_SLV1_CTR_ADDR: slv1_ctr_reg <= {26'd0, cmd_data_i[5:0]};
				CMD_SLV2_CTR_ADDR: slv2_ctr_reg <= {26'd0, cmd_data_i[5:0]};
			endcase
		end
		else
		begin
			slv0_ctr_reg <= slv0_ctr_reg;
			slv1_ctr_reg <= slv1_ctr_reg;
			slv2_ctr_reg <= slv2_ctr_reg;
		end
	end	
		
	//数据输出cmd_data_o
	//读操作时根据输入的地址，选择其中一个寄存器输出数据
	//当寄存器模块不读出数据时，输出端口设为z
	always @(posedge clk_i or negedge rstn_i)	
	begin
		if(!rstn_i) cmd_data_o <= 32'bz;
		else if(cmd_i == READ)
		begin
			case(cmd_addr_i)
				CMD_SLV0_CTR_ADDR:		cmd_data_o <= slv0_ctr_reg;
				CMD_SLV1_CTR_ADDR:		cmd_data_o <= slv1_ctr_reg;	
				CMD_SLV2_CTR_ADDR:		cmd_data_o <= slv2_ctr_reg;	
				CMD_SLV0_STATE_ADDR:	cmd_data_o <= slv0_state_reg;
				CMD_SLV1_STATE_ADDR:	cmd_data_o <= slv1_state_reg;
				CMD_SLV2_STATE_ADDR:	cmd_data_o <= slv2_state_reg;
			endcase
		end
		else cmd_data_o <= 32'bz;
	end
			
	assign slv0_en_o = slv0_ctr_reg[0];
	assign slv1_en_o = slv1_ctr_reg[0];
	assign slv2_en_o = slv2_ctr_reg[0];
	
	assign slv0_prio_o = slv0_ctr_reg[2:1];
	assign slv1_prio_o = slv1_ctr_reg[2:1];
	assign slv2_prio_o = slv2_ctr_reg[2:1];
	
	assign slv0_pkglen_o = slv0_ctr_reg[5:3];
	assign slv1_pkglen_o = slv1_ctr_reg[5:3];
	assign slv2_pkglen_o = slv2_ctr_reg[5:3];
	
endmodule
	
			
			
	