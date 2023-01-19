# MCDF
Multi-Channel Data Formatter，多通道数据整形器设计

利用verilog语言编写，测试使用ModelSim软件

设计原理及接口时序见
[设计要求](https://github.com/CYYYC13/MCDF/blob/main/%E8%AE%BE%E8%AE%A1%E8%A6%81%E6%B1%82.pdf)
&nbsp;

**仅供交流，请勿直接抄袭！**
&nbsp;

**水平有限，代码存在错误与不足之处，欢迎友好批评指正！:sunflower:**  
&nbsp;

&nbsp;

&nbsp;


————————————————————————————————
 &nbsp;
    
## slave_fifo
    通道从端，同步FIFO深度为64，数据位宽为32；

    从外部接口接收数据，当接收到一个完整数据包时，向arbiter发出发送请求；

    若请求得到响应，则开始发送，直到整个数据包发送完成；

    再根据情况确定是否发出发送请求（数据是否多于数据包长度）。

