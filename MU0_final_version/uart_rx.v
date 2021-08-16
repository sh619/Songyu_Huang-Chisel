//串口助手设置:波特率9600 无奇偶校验位，8位数据位，一个停止位
//time:2019.11.13.22.41
module uart_rx(
 input            clk    ,
 input            rst_n  ,
 input            uart_rx,
 output reg       uart_rx_done,
 output reg	[7:0] data
 );
 
   
parameter  CLK_FREQ = 50000000;                 
parameter  UART_BPS = 9600;      //波特率                
localparam PERIOD   = CLK_FREQ/UART_BPS;        
                                              
 
//接收的数据
reg [7:0] rx_data; 
 
 
reg       rx1,rx2;
wire      start_bit;
reg       start_flag;
 
 reg   [15:0]   cnt0;
 wire           add_cnt0;
 wire           end_cnt0;
 
 reg   [3:0]    cnt1;
 wire           add_cnt1;
 wire           end_cnt1;
 
 
 //下降沿检测 
assign  start_bit=(rx2)&(~rx1);
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
         rx1<=1'b0;
         rx2<=1'b0; 
    end
    else begin
         rx1<=uart_rx;
         rx2<=rx1;
    end
end
//开始标志位
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        start_flag<=0;
    end
    else if(start_bit) begin
        start_flag<=1;
    end
    else if(end_cnt1) begin
        start_flag<=0;
    end
end
 
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt0 <= 0;
    end
	 else if(end_cnt1) begin
	     cnt0 <= 0;
	 end
	 else if(end_cnt0) begin
	     cnt0 <= 0;
	 end
    else if(add_cnt0)begin
        cnt0 <= cnt0 + 1;
    end
end
assign add_cnt0 = start_flag;       
assign end_cnt0 = add_cnt0 && cnt0==PERIOD-1;
 
 
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt1 <= 0;
    end
	 else if(end_cnt1) begin
	     cnt1 <= 0;
	 end
    else if(add_cnt1)begin
        cnt1 <= cnt1 + 1;
    end
end
 
assign add_cnt1 = end_cnt0 ;    
assign end_cnt1 = (cnt0==((PERIOD-1)/2))&& (cnt1==10-1) ;  
 
//数据接收
always  @(posedge clk or negedge rst_n)begin
      if(rst_n==1'b0)begin
         rx_data<=8'd0;
      end
      else if(start_flag) begin
		  if(cnt0== PERIOD/2)begin
           case(cnt1)
            4'd1:rx_data[0]<=rx2;
            4'd2:rx_data[1]<=rx2;
            4'd3:rx_data[2]<=rx2;
            4'd4:rx_data[3]<=rx2;
            4'd5:rx_data[4]<=rx2;
            4'd6:rx_data[5]<=rx2;
            4'd7:rx_data[6]<=rx2;
            4'd8:rx_data[7]<=rx2;
		    default:rx_data<=rx_data;   
          endcase
        end
        else begin
            rx_data<=rx_data;
        end
     end
     else begin
         rx_data<=8'd0;
     end   
  end 
  //数据接收
 always  @(posedge clk or negedge rst_n)begin
      if(rst_n==1'b0)begin
           data<=0;
      end
      else if(end_cnt1)begin
          data<=rx_data;
      end  
  end
  
  //接收完成标志
 always  @(posedge clk or negedge rst_n)begin
     if(rst_n==1'b0)begin
         uart_rx_done<=0;
     end
     else if(end_cnt1)begin
         uart_rx_done<=1;
     end
     else begin
        uart_rx_done<=0;
     end
 end
endmodule