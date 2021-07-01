module statemachine1

(
 input [3:0] CS,
 output [2:0] NS
);

 assign NS[0]=~(CS[2]|CS[3]),
        NS[1]=CS[1] & CS[0],
        NS[2]=CS[2];
 endmodule