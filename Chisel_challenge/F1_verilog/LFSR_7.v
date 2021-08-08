module LFSR_16 (data_out,clk,enable);

  output [14:1] data_out;
  input clk;
  input enable;
  reg [14:1] sreg;
  initial sreg=14'b1;
  always @(posedge clk)
			if(enable==1)
			sreg <= {sreg[13:1], sreg[1]^sreg[6]^sreg[10]^sreg[14]};

	assign data_out= sreg;
endmodule
	