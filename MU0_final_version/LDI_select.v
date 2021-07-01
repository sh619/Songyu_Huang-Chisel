module LDI_select
(
output [15:0] LDI_acc,
input [15:0] acc,
input LDI_en
);

assign LDI_acc[11:0]=acc[11:0];
assign LDI_acc[12]=LDI_en & acc[12];
assign LDI_acc[13]=LDI_en & acc[13];		 
assign LDI_acc[14]=LDI_en & acc[14];
assign LDI_acc[15]=LDI_en & acc[15];		 

endmodule
