module clktick (
clkin,
tick,
N,
enable);

parameter N_BIT=16;

input enable;
input clkin;
output tick;
input [N_BIT-1:0] N;

reg [N_BIT-1:0] count;
reg tick;
initial tick=1'b0;

always @(posedge clkin)

if (enable==1) begin
   if (count==0) begin
	    tick <= 1'b1;
		 count <= N;
		 end
    else begin 
	    tick <= 1'b0;
		 count <= count - 1'b1;
		 end
end
endmodule