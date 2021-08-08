
module FSM(clk,tick,trigger,time_out,en_lfsr,start_delay,ledr,ren);


input clk;
input tick;
input trigger;
input time_out;
output [7:0] ledr;
output en_lfsr;
output start_delay;
output ren;
reg [4:0]state;
reg [7:0] ledr;
reg en_lfsr;
reg start_delay;
reg ren;
initial state=4'b0000;
always @(posedge clk) begin
     case (state)
		4'b0000:
			if(trigger==1'b1)
			state <= 4'b0001;
			else begin
			state <= 4'b0000;
			ledr[7:0]<=8'b11111111;
			start_delay <= 1'b0;
			en_lfsr <= 1'b0;
			ren <= 1'b0;end
		4'b0001:
			if(tick==1'b1) 
			state <= 4'b0010;
			else begin
			ledr[7:0]<=8'b11111110;
			state <= 4'b0001;end
		4'b0010:
			if(tick==1'b1) 
			state <= 4'b0011;
			else begin
			ledr[7:0]<=8'b11111100;
			state <= 4'b0010; end
		4'b0011:
			if(tick==1'b1)
			state <= 4'b0100;
			else begin
			state <= 4'b0011;
			ledr[7:0] <=8'b11111000;
			end
		4'b0100:
			if(tick==1'b1) 
			state <= 4'b0101; 
			else begin
			state <= 4'b0100;
			ledr[7:0] <=8'b11110000;
			end
		4'b0101:
			if(tick==1'b1) 
			state <= 4'b0110; 
			else begin 
			state <= 4'b0101;
			ledr[7:0] <=8'b11100000; end
		4'b0110:
			if(tick==1'b1) 
			state <= 4'b0111; 
			else begin
			state <= 4'b0110;
			ledr[7:0] <=8'b11000000;end
		4'b0111:
			if(tick==1'b1) 
			state <= 4'b1000; 
			else begin
			state <= 4'b0111;
			ledr[7:0] <=8'b10000000;
			end
		4'b1000:
			if(tick==1'b1)
			state <= 4'b1001;
			else begin
			state <= 4'b1000;
			ledr[7:0] <=8'b00000000;end
		4'b1001:
			if(tick==1'b1) 
			state <= 4'b1010; 
			else begin
			ledr[7:0] <=8'b00000000;
		   en_lfsr <= 1'b1;	
			state <= 4'b1001;end
		4'b1010: 
		  if(time_out==1'b1) begin
		  ren <=1'b1;
		  state <= 4'b0000;end 
		  else begin 
		  
		   start_delay <= 1'b1;
		  	ledr[7:0]<=8'b00000000;
		   state <= 4'b1010; end
			default: begin
			ledr[7:0]<=8'b11111111;
			end
		endcase
		end
		
endmodule
			
			
			