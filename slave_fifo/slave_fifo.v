/**********************************************************************************
模块名称：slave_fifo
功能：通道从端，同步FIFO深度为64，数据位宽为32；
	  从外部接口接收数据，当接收到一个完整数据包时，向arbiter发出发送请求；
	  若请求得到响应，则开始发送，直到整个数据包发送完成；
	  再根据情况确定是否发出发送请求（数据是否多于数据包长度）。
难点：让32个数据的标志信号flag_pkglength持续产生，直到连续输出32个数据，而不是只有一个周期。
**********************************************************************************/

module slave_fifo(
	//input
		clk_i,              //from outside
		rstn_i,				//from outside
		chx_data_i,			//from outside
		chx_valid_i,		//from outside
		slvx_en_i,			//from control_registers
		a2sx_ack_i,			//from arbiter
		slvx_pkglen_i,		//from control_registers
	//output
		chx_ready_o,		//to outside
		slvx_margin_o,		//to control_registers
		slvx_data_o,		//to arbiter
		slvx_valid_o,		//to arbiter
		slvx_req_o			//to arbiter
	//output for test
		//wr_ptr,
		//rd_ptr,
		//fifo_cnt,
		//flag_pkglength
	);
	
	input 		 clk_i;			//时钟信号，同步fifo
	input 		 rstn_i;		//复位信号，低电平有效
	input [31:0] chx_data_i; 	//通道数据输入，32bits
	input 		 chx_valid_i;	//通道数据有效指示信号
	input 		 slvx_en_i; 	//通道使能信号（可理解为写使能），由控制寄存器给出
	input 		 a2sx_ack_i; 	//由arbiter到slave的读确认，高电平表示对slave_fifo进行读使能（可理解为读使能）
	input [2:0]  slvx_pkglen_i; //数据包长度，0为四个，1为八个，2为十六个，其他为三十二个
	
	output reg		 	 chx_ready_o;	//输出的ready，表明当前通道是否准备好接收数据，和fifo的空满状态有关，满则ready拉低
	output 		[6:0] 	 slvx_margin_o; //fifo的数据边界（距fifo满还有多少），最大要表示64，因此需要7位
	output reg	[31:0] 	 slvx_data_o;	//输出到Arbiter的32位数据
	output reg	 	 	 slvx_valid_o;  //输出数据的valid，高电平表示输出数据有效
	output reg		 	 slvx_req_o;	//请求输出数据
	
	//output reg [6:0]  wr_ptr; 			//写指针，最高位为状态位
	//output reg [6:0]  rd_ptr; 			//读指针，最高位为状态位
	//output 	   [6:0]  fifo_cnt;         //数据个数计数器，需要7位，因为考虑到需要写指针和读指针相减
	//output reg 		  flag_pkglength;   //fifo中持续存在完整数据包时的指示信号
	
	reg [6:0]  wr_ptr; 		//写指针，最高位为状态位
	reg [6:0]  rd_ptr; 		//读指针，最高位为状态位
	wire [6:0]  fifo_cnt;     //数据个数计数器，需要7位，因为考虑到需要写指针和读指针相减
	reg [31:0] fifo_mem[63:0];  //定义共有64个32bits数据的存储器，深度为64

	wire full_sf, empty_sf; 	//定义fifo的满/空信号（后缀表示slave_fifo模块）
	
	reg  [5:0] PKG_length;      //数据包长度转换
	reg flag_pkglength;         //fifo中持续存在完整数据包时的指示信号
	reg [5:0] data_send_cnt;    //读出数据个数计数器
	
	assign empty_sf 	 = (wr_ptr == rd_ptr); //当读写指针的数据位和状态位都相同时，表示fifo空
	assign full_sf 		 = ({~wr_ptr[6], wr_ptr[5:0]} == rd_ptr); //当读写指针的数据位相同而状态位不同时，表示fifo满
	assign fifo_cnt      = wr_ptr - rd_ptr; //当前fifo的数据个数
	assign slvx_margin_o = 64 - fifo_cnt; //当前fifo余量是64减去已有数据量
	
	//数据包长度转换
	always @(*)
	begin
		if(slvx_pkglen_i == 3'd0) PKG_length = 4;
		else if(slvx_pkglen_i == 3'd1) PKG_length = 8;
		else if(slvx_pkglen_i == 3'd2) PKG_length = 16;
		else PKG_length = 32;
	end
	
/*------------------------------输出接收准备信号：chx_ready_o;------------------------------------*/

	//接收准备chx_ready_o
	//若fifo未满且通道使能，则输出允许接收数据的信号
	always @(*) //随时判断是否允许接收数据
	begin
		if((!full_sf) && slvx_en_i) chx_ready_o = 1'b1;
		else chx_ready_o = 1'b0;
	end

/*------------------------------输出发送请求信号：slvx_req_o;------------------------------------*/	

	//发送请求slvx_req_o
	//若fifo中的数据大于等于数据包长度且复位信号无效，则slave_fifo允许输出数据，输出请求置1
	always @(posedge clk_i or negedge rstn_i) //在flag_pkglength置低后的第一个时钟上升沿开始不发出发送请求
	begin	
		if(!rstn_i) slvx_req_o <= 1'b0;
		else if(flag_pkglength) slvx_req_o <= 1'b1;
		else slvx_req_o <= 1'b0;
	end	 
	
	//当数据包完整时产生指示信号flag_pkglength
	always @(*)
	begin
		if(!rstn_i || (data_send_cnt == PKG_length)) flag_pkglength = 1'b0;
		else if(fifo_cnt >= PKG_length) flag_pkglength = 1'b1;
		else flag_pkglength = flag_pkglength; //当flag_pkglength为1之后，不会变成0，除非复位或输出数据的个数等于数据包长度
	end
	
	//读出数据个数计数
	always @(posedge clk_i or negedge rstn_i)
	begin
		if(!rstn_i || (data_send_cnt == PKG_length)) data_send_cnt <= 0;
		else if(flag_pkglength && a2sx_ack_i) data_send_cnt <= data_send_cnt + 1'b1;
		else data_send_cnt <= data_send_cnt;
	end
	
	
/*------------------------------输出数据有效信号：slvx_valid_o;------------------------------------*/		
	//输出数据有效信号slvx_valid_o
	//若fifo非空且有来自arbiter的读使能信号且fifo有发送请求，则输出数据有效
	always @(posedge clk_i or negedge rstn_i)//发出时钟同步的输出数据有效信号
	begin
		if(!rstn_i) slvx_valid_o <= 1'b0;
		else if(a2sx_ack_i && flag_pkglength) slvx_valid_o <= 1'b1;
		else slvx_valid_o <= 1'b0;
	end
	
	
/*---------------------------写/读操作，输出数据信号：slvx_data_o;--------------------------------*/		
	
	//写数据fifo_mem
	//当通道有效且通道数据有效且fifo当前允许接收数据，则将输入的数据写入memory中
	integer i;
	always @(posedge clk_i or negedge rstn_i)//异步复位
	begin
		if(!rstn_i) 
			begin: u
				for(i = 0; i < 64; i = i + 1)
					fifo_mem[i] <= 0;
			end
		else if(chx_valid_i && chx_ready_o && slvx_en_i) fifo_mem[wr_ptr[5:0]] <= chx_data_i;
		else fifo_mem[wr_ptr[5:0]] <= fifo_mem[wr_ptr[5:0]];
	end
	
	//更新写指针wr_ptr
	//若通道使能且通道数据有效且fifo当前允许接收数据，则写指针+1
	always @(posedge clk_i or negedge rstn_i) //异步复位
	begin
		if(!rstn_i) wr_ptr <= 0;
		else if(chx_valid_i && chx_ready_o && slvx_en_i) wr_ptr <= wr_ptr + 1;
		else wr_ptr <= wr_ptr;
	end
	
	//读数据slvx_data_o
	//若fifo非空且有来自arbiter的读使能信号且fifo有发送请求，则将数据读出到arbiter中
	always @(posedge clk_i or negedge rstn_i)//异步复位
	begin
		if(!rstn_i) slvx_data_o <= 0; //复位时读出数据置0
		else if(a2sx_ack_i && flag_pkglength) slvx_data_o <= fifo_mem[rd_ptr[5:0]];
		else slvx_data_o <= 0; 
	end
	
	//更新读指针rd_ptr
	//若fifo非空且有来自arbiter的读使能信号且fifo有发送请求，则读指针+1
	always @(posedge clk_i or negedge rstn_i)//异步复位
	begin
		if(!rstn_i) rd_ptr <= 0;
		else if(a2sx_ack_i && flag_pkglength) rd_ptr <= rd_ptr + 1;
		else rd_ptr <= rd_ptr;
	end 
	
endmodule
	
	
	
	
	
		
	
	