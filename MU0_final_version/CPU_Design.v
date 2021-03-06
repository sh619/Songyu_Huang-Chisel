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

module CPU_Design(
	Clock,
	reset,
	an,
	uart_rx,
	uart_tx,
	sseg
);


input wire	Clock;
input wire	reset;
input  uart_rx;
output  uart_tx;
output wire	[3:0] an;
output wire	[6:0] sseg;

wire	[15:0] IR;
wire	[15:0] q;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_43;
wire	SYNTHESIZED_WIRE_3;
wire	[15:0] SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	[15:0] SYNTHESIZED_WIRE_44;
wire	[2:0] SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;
wire	[0:0] SYNTHESIZED_WIRE_11;
wire	[29:0] SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_13;
wire	[3:0] SYNTHESIZED_WIRE_14;
wire	[3:0] SYNTHESIZED_WIRE_15;
wire	[3:0] SYNTHESIZED_WIRE_16;
wire	[3:0] SYNTHESIZED_WIRE_17;
wire	SYNTHESIZED_WIRE_18;
wire	SYNTHESIZED_WIRE_45;
wire	SYNTHESIZED_WIRE_20;
wire	SYNTHESIZED_WIRE_21;
wire	SYNTHESIZED_WIRE_22;
wire	SYNTHESIZED_WIRE_23;
wire	SYNTHESIZED_WIRE_25;
wire	SYNTHESIZED_WIRE_27;
wire	[11:0] SYNTHESIZED_WIRE_28;
wire	[15:0] SYNTHESIZED_WIRE_30;
wire	SYNTHESIZED_WIRE_32;
wire	[15:0] SYNTHESIZED_WIRE_33;
wire	[15:0] SYNTHESIZED_WIRE_34;
wire	SYNTHESIZED_WIRE_35;
wire	SYNTHESIZED_WIRE_37;
wire	SYNTHESIZED_WIRE_38;
wire	[11:0] SYNTHESIZED_WIRE_40;
wire	SYNTHESIZED_WIRE_41;
wire	[2:0] SYNTHESIZED_WIRE_42;





lpm_shiftreg_0	b2v_acc(
	.shiftin(SYNTHESIZED_WIRE_0),
	.enable(SYNTHESIZED_WIRE_1),
	.clock(SYNTHESIZED_WIRE_43),
	.load(SYNTHESIZED_WIRE_3),
	.data(SYNTHESIZED_WIRE_4),
	.q(q));


lpm_add_sub_1	b2v_ALU(
	.add_sub(SYNTHESIZED_WIRE_5),
	.dataa(q),
	.datab(SYNTHESIZED_WIRE_44),
	.result(SYNTHESIZED_WIRE_34));


registerx3	b2v_inst(
	.CLK(SYNTHESIZED_WIRE_43),
	
	.D(SYNTHESIZED_WIRE_8),
	.Q(SYNTHESIZED_WIRE_42));


compare	b2v_inst1(
	.acc(q),
	.EQ(SYNTHESIZED_WIRE_21),
	.MI(SYNTHESIZED_WIRE_22),
	.GE(SYNTHESIZED_WIRE_23));


LDI_select	b2v_inst12(
	.LDI_en(SYNTHESIZED_WIRE_9),
	.acc(SYNTHESIZED_WIRE_44),
	.LDI_acc(SYNTHESIZED_WIRE_33));


clktick	b2v_inst14(
	.clkin(Clock),
	.enable(SYNTHESIZED_WIRE_11),
	.N(SYNTHESIZED_WIRE_12),
	.tick(SYNTHESIZED_WIRE_43));
	defparam	b2v_inst14.N_BIT = 30;


lpm_constant_2	b2v_inst15(
	.result(SYNTHESIZED_WIRE_12));


lpm_constant_3	b2v_inst16(
	.result(SYNTHESIZED_WIRE_11));


bin2bcd	b2v_inst19(
	.x(q),
	.BCD0(SYNTHESIZED_WIRE_14),
	.BCD1(SYNTHESIZED_WIRE_15),
	.BCD2(SYNTHESIZED_WIRE_16),
	.BCD3(SYNTHESIZED_WIRE_17));


scan_led_hex_disp	b2v_inst2(
	.clk(Clock),
	.reset(SYNTHESIZED_WIRE_13),
	.hex0(SYNTHESIZED_WIRE_14),
	.hex1(SYNTHESIZED_WIRE_15),
	.hex2(SYNTHESIZED_WIRE_16),
	.hex3(SYNTHESIZED_WIRE_17),
	.an(an),
	.sseg(sseg));

assign	SYNTHESIZED_WIRE_13 =  ~reset;


Decoder	b2v_inst7(
	.FETCH(SYNTHESIZED_WIRE_18),
	.EXEC1(SYNTHESIZED_WIRE_45),
	.EXEC2(SYNTHESIZED_WIRE_20),
	.EQ(SYNTHESIZED_WIRE_21),
	.MI(SYNTHESIZED_WIRE_22),
	.GE(SYNTHESIZED_WIRE_23),
	.op(IR[15:12]),
	.EXTRA(SYNTHESIZED_WIRE_41),
	.WRen(SYNTHESIZED_WIRE_38),
	.sel1(SYNTHESIZED_WIRE_27),
	.sel3(SYNTHESIZED_WIRE_32),
	.PC_sload(SYNTHESIZED_WIRE_35),
	.cnt_en(SYNTHESIZED_WIRE_37),
	.IR_sload(SYNTHESIZED_WIRE_25),
	.acc_en(SYNTHESIZED_WIRE_1),
	.acc_shin(SYNTHESIZED_WIRE_0),
	.acc_sload(SYNTHESIZED_WIRE_3),
	.add_sub(SYNTHESIZED_WIRE_5),
	.LDI_en(SYNTHESIZED_WIRE_9));


lpm_ff_4	b2v_IR1(
	.clock(SYNTHESIZED_WIRE_43),
	.sload(SYNTHESIZED_WIRE_25),
	.data(SYNTHESIZED_WIRE_44),
	.q(SYNTHESIZED_WIRE_30));


busmux_5	b2v_MUX1(
	.sel(SYNTHESIZED_WIRE_27),
	.dataa(IR[11:0]),
	.datab(SYNTHESIZED_WIRE_28),
	.result(SYNTHESIZED_WIRE_40));


busmux_6	b2v_MUX2(
	.sel(SYNTHESIZED_WIRE_45),
	.dataa(SYNTHESIZED_WIRE_30),
	.datab(SYNTHESIZED_WIRE_44),
	.result(IR));


busmux_7	b2v_MUX3(
	.sel(SYNTHESIZED_WIRE_32),
	.dataa(SYNTHESIZED_WIRE_33),
	.datab(SYNTHESIZED_WIRE_34),
	.result(SYNTHESIZED_WIRE_4));


lpm_counter_8	b2v_PC(
	.sload(SYNTHESIZED_WIRE_35),
	.clock(SYNTHESIZED_WIRE_43),
	.cnt_en(SYNTHESIZED_WIRE_37),
	.data(IR[11:0]),
	.q(SYNTHESIZED_WIRE_28));


CPU_RAM	b2v_RAM(
	.wren(SYNTHESIZED_WIRE_38),
	.clock(SYNTHESIZED_WIRE_43),
	.address(SYNTHESIZED_WIRE_40),
	.data(q),
	.q(SYNTHESIZED_WIRE_44));


statemachine	b2v_statemachine(
	.extra(SYNTHESIZED_WIRE_41),
	.cs(SYNTHESIZED_WIRE_42),
	.EXEC1(SYNTHESIZED_WIRE_45),
	.EXEC2(SYNTHESIZED_WIRE_20),
	.FETCH(SYNTHESIZED_WIRE_18),
	.NS(SYNTHESIZED_WIRE_8));


endmodule

module busmux_5(sel,dataa,datab,result);
/* synthesis black_box */

input sel;
input [11:0] dataa;
input [11:0] datab;
output [11:0] result;

endmodule

module busmux_6(sel,dataa,datab,result);
/* synthesis black_box */

input sel;
input [15:0] dataa;
input [15:0] datab;
output [15:0] result;

endmodule

module busmux_7(sel,dataa,datab,result);
/* synthesis black_box */

input sel;
input [15:0] dataa;
input [15:0] datab;
output [15:0] result;

endmodule

module lpm_add_sub_1(add_sub,dataa,datab,result);
/* synthesis black_box */

input add_sub;
input [15:0] dataa;
input [15:0] datab;
output [15:0] result;

endmodule

module lpm_constant_2(result);
/* synthesis black_box */

output [29:0] result;

endmodule

module lpm_constant_3(result);
/* synthesis black_box */

output [0:0] result;

endmodule

module lpm_counter_8(sload,clock,cnt_en,data,q);
/* synthesis black_box */

input sload;
input clock;
input cnt_en;
input [11:0] data;
output [11:0] q;

endmodule

module lpm_ff_4(clock,sload,data,q);
/* synthesis black_box */

input clock;
input sload;
input [15:0] data;
output [15:0] q;

endmodule

module lpm_shiftreg_0(shiftin,enable,clock,load,data,q);
/* synthesis black_box */

input shiftin;
input enable;
input clock;
input load;
input [15:0] data;
output [15:0] q;

endmodule
