module extension
(
input  [7:0] data,
output  [15:0] data1
);
assign data1= {data,8'b0};

endmodule
