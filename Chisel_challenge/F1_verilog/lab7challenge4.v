module lab7challenge4(MAX10_CLK1_50,KEY,HEX1,LEDR,seg);

input MAX10_CLK1_50;
input [1:0] KEY;
output [6:0] HEX1;
output [7:0] LEDR;
output [3:0] seg;
wire tick_ms;
wire tick_halfs;
wire time_out;
wire en_lfsr;
wire start_delay;
wire ren;
wire [3:0] BCD0,BCD1,BCD2,BCD3,BCD4;
wire [13:0] N;
wire [15:0] diff;
wire reset;
assign reset=0;
clktick ms(MAX10_CLK1_50,tick_ms,16'd50000,1'b1);
clktick halfs(MAX10_CLK1_50,tick_halfs,16'd500,tick_ms);

FSM stat(tick_ms,tick_halfs,~KEY[1],time_out,en_lfsr,start_delay,LEDR[7:0],ren);
delay de(N[13:0],tick_ms,start_delay,time_out);
LFSR_16 (N[13:0],tick_ms,en_lfsr);
reaction react(ren,tick_ms,~KEY[0],diff[15:0],~KEY[1]);
bin2bcd_16 bcd(diff[15:0],BCD0,BCD1,BCD2,BCD3,BCD4);
scan_led_hex_disp cyclone(MAX10_CLK1_50,reset,BCD1,BCD2,BCD3,BCD4,seg[3:0],HEX1[6:0]);
//hex_to_7seg  seg1(HEX1[6:0],BCD1);
////hex_to_7seg  seg2(HEX2[6:0],BCD2);
////hex_to_7seg  seg3(HEX3[6:0],BCD3);
////hex_to_7seg  seg4(HEX4[6:0],BCD4);

endmodule