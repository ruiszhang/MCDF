# MCDF
Multi-Channel Data Formatter，多通道数据整形器设计

利用verilog语言编写，测试使用ModelSim软件

包含：模块代码、测试代码、测试波形及波形分析

设计原理及接口时序见
[设计要求](https://github.com/CYYYC13/MCDF/blob/main/%E8%AE%BE%E8%AE%A1%E8%A6%81%E6%B1%82.pdf)
&nbsp;

**仅供交流，请勿直接抄袭！**
&nbsp;

**水平有限，代码存在错误与不足之处，欢迎友好批评指正！:sunflower:**  
&nbsp;

&nbsp;

&nbsp;

分模块设计如下：

————————————————————————————————
 &nbsp;
    
## slave_fifo
    通道从端，同步FIFO深度为64，数据位宽为32；

    从外部接口接收数据，当接收到一个完整数据包时，向arbiter发出发送请求；

    若请求得到响应，则开始发送，直到整个数据包发送完成；

    再根据情况确定是否发出发送请求（数据是否多于数据包长度）。

&nbsp;
    
&nbsp;
    
## control_registers
    当cmd为写指令时，将输入数据cmd_data_i写入cmd_addr指定的寄存器中；
   
    当cmd为读指令时，从cmd_addr指定的寄存器中读出数据到cmd_data_o；
   
    共有6个寄存器，分别是3个通道的控制寄存器和状态寄存器；
   
    包括通道使能、通道优先级、数据包长度、FIFO实时余量信息；
   
    总线数据cmd_data_i只有低6位被使用。
   
&nbsp;
    
&nbsp;
    
## arbiter
    当formatter的发送数据请求信号f2a_id_req_i为高时，arbiter根据三个通道的发送请求信号，
    
    按优先级确定响应通道的发送请求，并根据通道号产生信号送到formatter；
    
    若各通道优先级相同，则发送编号最低的通道数据。
    
&nbsp;
    
&nbsp;
       
## formatter  
    formatter完整接收一个数据包后才开始发送。准备发送时将fmt_req置高，等待接收端的fmt_grant信号；
    
    当fmt_grant信号变为高时，在下一个周期：fmt_req置低、fmt_start输出一个周期的高电平脉冲、fmt_data
    
    开始送出第一个数据。数据开始发送后应接连发送，中间不允许有空闲周期（所以需要一个memory先完整
    
    存入要发送的数据包）。在发送最后一个数据时，fmt_end信号应置高并保持一个周期。formatter必须完整
    
    发送某一通道的数据包之后才可以准备发送下一个数据包。在发送数据报期间，fmt_chid和fmt_length应保持
    
    不变，知道数据包发送结束。
    
    
