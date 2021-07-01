module statemachine

(
input [2:0] cs,
input extra,
output EXEC1,
output EXEC2,
output FETCH,
output [2:0] NS
);

assign EXEC1=cs[0],
		 EXEC2=cs[1],
		 FETCH=~(EXEC1 | EXEC2),
       NS[0]= ~(cs[1]| cs[0]),
		 NS[1]=cs[0] & extra,
		 NS[2]=0;
endmodule

