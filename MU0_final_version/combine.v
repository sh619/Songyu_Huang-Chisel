module combine
(
input clock;
input 
input [7:0] data1;
output  [15:0] ram_data;
)

reg [15:0] ram_data;

reg [1:0] state;

initial ram_data = 16'b0;
initial state = 2'b0;
always@ (posedge clock)   
begin
case (state)
2'b00:begin
if (ram_data[15:12] != 4'b0)
state <= 2'b01;
else
ram_data[15:8] <= data1;

end
2'b01:begin
if((data1!= ram_data[15:8]) && data1 != 0 ) begin
ram_data[7:0] <= data1;
state <= 2'b10;end
else 
ram_data[7:0] <= 8'b0;
end
2'b10:begin
ram_
