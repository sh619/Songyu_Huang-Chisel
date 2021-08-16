// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Standard Edition"
// CREATED		"Sun Aug 15 23:16:27 2021"


module lpm_add_sub_1(add_sub,dataa,datab,result);
input add_sub;
input [15:0] dataa;
input [15:0] datab;
output [15:0] result;

lpm_add_sub	lpm_instance(.add_sub(add_sub),.dataa(dataa),.datab(datab),.result(result));
	defparam	lpm_instance.LPM_DIRECTION = "DEFAULT";
	defparam	lpm_instance.LPM_WIDTH = 16;

endmodule
