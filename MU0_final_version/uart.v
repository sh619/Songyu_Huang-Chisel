//串口助手设置:波特率9600 无奇偶校验位，8位数据位，一个停止位
//time:2019.11.13.22.41
module uart(
    input  Clock    ,
    input  reset ,
	input  uart_rx  ,
	output  uart_tx  ,
   output [3:0] an,
   output [6:0] data
	
);
 
wire [7:0] data; 
wire uart_rx_done;
																
 
 
//FPGA接收串口助手发来的数据 
uart_rx uart_rx_uut(
     .clk    (Clock),
    .rst_n   (reset),
    .uart_rx (uart_rx),
    .uart_rx_done(uart_rx_done),
	 .data    (data)
);
	 
//FPGA把接收的数据发送到串口助手上	 	 
uart_tx uart_tx_uut(
   .clk     (Clock),
   .rst_n   (reset),
   .uart_tx (uart_tx),
   .data    (data),
   .tx_start(uart_rx_done)
 );
	 
endmodule