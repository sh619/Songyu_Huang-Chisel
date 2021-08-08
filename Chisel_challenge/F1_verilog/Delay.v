module delay(N,clk,trigger,time_out);


parameter N_BIT=14;
input clk;
input trigger;
input [N_BIT-1:0] N;
output time_out;
reg state;
reg time_out;
reg [N_BIT-1:0] count;
initial state=1'b0;


always @(posedge clk)begin
			count <= N;
		case(state)
		1'b0:
			if(trigger==1) begin
			state <= 1'b1;

	      end
			else begin
			state <= 1'b0;
			time_out <= 0; end
		1'b1:
			if(count==15'b0) begin
			time_out <=1;
			state <= 1'b0;end
			else begin
			count <=count-1'b1; 
			state <= 1'b1;
			time_out<=0; end
		default:;
		endcase
		end
endmodule
