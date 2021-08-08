module reaction(enable,clk,KEY,diff,trigger);

input enable;
input clk;
input KEY;
input trigger;
output [15:0] diff;
reg [15:0] diff;
reg  [15:0] final;
reg [2:0]state;
initial state=2'b00;

always @(posedge clk)begin
	case(state)
	  2'b00:
		   if(enable==1)
		   state <= 2'b01;
		   else begin
		   state <= 2'b00;
		   final=15'b0;
			diff[15:0]=0;
			end
	  2'b01:
			if(KEY==0)begin
			final<= final+15'b1;
			state <=2'b01;end
			else
			state <=2'b10;
	  2'b10:
			if(trigger==1)
			state <= 2'b00;
			else begin
			state <= 2'b10;
			diff[15:0] <= final[15:0];end
			default:;
	endcase
	end
endmodule
			
			


