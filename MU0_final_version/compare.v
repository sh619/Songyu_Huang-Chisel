module compare

(
input [15:0] acc,
output EQ,
output MI,
output GE
);

assign EQ=~(acc[0] | acc[1] | acc[2] | acc[3] | acc[4] | acc[5] | acc[6] | acc[7] | acc[8] | acc[8] | acc[9] | acc[10] | acc[11] | acc[12] | acc[13] | acc[14] | acc[15]);
assign MI=acc[15];
assign GE=~(MI|EQ);

endmodule