`timescale 1ns / 1ps
module scan_led_hex_disp(
    input clk,
    input reset,
    input [3:0] hex0,
    input [3:0] hex1,
    input [3:0] hex2,
    input [3:0] hex3,
    output reg [3:0] an,   //片选
    output reg [6:0] sseg  //段选
    );
 
 localparam N = 18; //使用低16位对50Mhz的时钟进行分频(50MHZ/2^16)
 reg [N-1:0] regN; //高两位作为控制信号，低16位为计数器，对时钟进行分频
 reg [3:0] hex_in; //段选控制信号
 
 always@(posedge clk, posedge reset)
 begin
  if(reset)
   regN <= 0;
  else
   regN <= regN + 1;
 end
 
 always@ *
 begin
  case(regN[N-1:N-2])
  2'b00:begin
   an = 4'b0001; //选中第1个数码管
   hex_in = hex0; //数码管显示的数字由hex_in控制，显示hex0输入的数字；
  end
  2'b01:begin
   an = 4'b0010; //选中第二个数码管
   hex_in = hex1;
  end
  2'b10:begin
   an = 4'b0100;
   hex_in = hex2;
  end
  default:begin
   an = 4'b1000;
   hex_in = hex3;
  end
  
  endcase
 
 end
 always@ *
 begin
  case(hex_in)
      4'h0: sseg[6:0] = 7'b1000000;
		4'h1: sseg[6:0] = 7'b1111001;
		4'h2: sseg[6:0] = 7'b0100100;
		4'h3: sseg[6:0] = 7'b0110000;
		4'h4: sseg[6:0] = 7'b0011001;
		4'h5: sseg[6:0] = 7'b0010010;
		4'h6: sseg[6:0] = 7'b0000010;
		4'h7: sseg[6:0] = 7'b1111000;
		4'h8: sseg[6:0] = 7'b0000000;
		4'h9: sseg[6:0] = 7'b0011000;
		4'ha: sseg[6:0] = 7'b0001000;
		4'hb: sseg[6:0] = 7'b0000011;
		4'hc: sseg[6:0] = 7'b1000110;
		4'hd: sseg[6:0] = 7'b0100001;
		4'he: sseg[6:0] = 7'b0000110;
		4'hf: sseg[6:0] = 7'b0001110;
   default: sseg[6:0] = 7'b0111000;
  endcase
 end
endmodule