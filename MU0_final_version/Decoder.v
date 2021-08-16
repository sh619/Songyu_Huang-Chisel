module Decoder

(
input [3:0] op,
input FETCH,
input EXEC1,
input EXEC2,
input EQ,
input MI,
input GE,
input uart,
output EXTRA,
output WRen,
output sel1,
output sel3,
output PC_sload,
output cnt_en,
output IR_sload,
output acc_en,
output acc_shin,
output acc_sload,
output add_sub,
output LDI_en
);

wire LDA, STA, ADD, SUB, JMP, JMI, JEQ, STP, LDI, LSL, LSR, JGE;

assign LDA=!op[3] & !op[2] & !op[1] & !op[0];
assign STA=!op[3] & !op[2] & !op[1] &  op[0];
assign ADD=!op[3] & !op[2] &  op[1] & !op[0];
assign SUB=!op[3] & !op[2] &  op[1] &  op[0];
assign JMP=!op[3] &  op[2] & !op[1] & !op[0];
assign JMI=!op[3] &  op[2] & !op[1] &  op[0];
assign JEQ=!op[3] &  op[2] &  op[1] & !op[0];
assign STP=!op[3] &  op[2] &  op[1] &  op[0];
assign LDI= op[3] & !op[2] & !op[1] & !op[0];
assign LSL= op[3] & !op[2] & !op[1] &  op[0];
assign LSR= op[3] & !op[2] &  op[1] & !op[0];
assign JGE= op[3] & !op[2] &  op[1] &  op[0];


assign EXTRA= LDA | ADD | SUB;
assign sel1=~(EXEC1&(LDA|STA|ADD|SUB));
assign WRen=(STA & EXEC1) | uart ;
assign sel3=(ADD & EXEC2) | (SUB & EXEC2);
assign PC_sload=(JMP & EXEC1) | (JMI & EXEC1 & MI ) | (JEQ & EXEC1 & EQ) | (JGE & EXEC1 & GE);
assign cnt_en=EXEC1 & ( LDA | STA | ADD | SUB | (JMI & !MI) | (JEQ & !EQ) | (JGE & !GE) | LSR | LSL | LDI);
assign IR_sload=EXEC1;
assign acc_en=((LDA & EXEC2) | (ADD & EXEC2) | (SUB & EXEC2) | (LDI & EXEC1)| (LSR & EXEC1));
assign acc_shin=0;
assign acc_sload=((LDA & EXEC2) | (ADD & EXEC2) | (SUB & EXEC2)|(LDI & EXEC1));
assign add_sub=(ADD & EXEC2);
assign LDI_en=~(LDI & EXEC1);
endmodule
