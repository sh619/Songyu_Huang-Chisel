module LFSR_7 (data_out,clk);

  output [7:1] data_out;
  input clk;
  reg [7:1] sreg;
  initial sreg=7'b1;
  always @(posedge clk)
			sreg <= {sreg[6:1], sreg[1]^sreg[7]};
	assign data_out= sreg;
endmodule
	