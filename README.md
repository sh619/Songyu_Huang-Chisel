# Chisel Project 
This project is for myself to learn Chisel language and hopefully finish some solid CPU design on FPGA.  

## Set up MU0 CPU 
### Initial reaserch and FPGA set up:  
I have already implemented this CPU on Quartus last year using quartus block digram design, therefore to implmented again using Chisel will be a excellent way to start leanring chisel.  
First need to make sure that the design can run on Cyclone10 FPGA successfully. I am using Cyclone10 for the project.  
In order to run the MU0 design on FPGA, I need to change the current Quartus file to the suitable version to make sure the designed CPU can run on Cyclone10 FPGA. When trying to connect the FPGA to Quartus vis USB blaster, Quartus cannot recognize the FPGA board. After searching online, I found out that this maybe caused by other USB devices connected to the PC(from Intel community).![image](https://user-images.githubusercontent.com/59866887/124550922-ff393580-de63-11eb-8a4a-ea62713121fc.png) This problem cause a lot of time to find the problem and fix, which makes the project slightly behind the scheduled time.  

- The logic diagrams of MU0 is shown below:  
![image](https://user-images.githubusercontent.com/59866887/126938739-4815c741-feed-448c-a997-710c2fb807d2.png)  
- The detailed block diagram version with all the individual modules are shown below(top level design on Quartus):  
![image](https://user-images.githubusercontent.com/59866887/126939010-83d284b1-9fda-4c96-a3f3-74bcb8cad541.png)
- With the following instructions:
![image](https://user-images.githubusercontent.com/59866887/126984500-08d65ecf-f881-4501-a19f-6d56afabd827.png)
### The FPGA configuration are shown below:
The new FPGA is STEP-CYC10:
![image](https://user-images.githubusercontent.com/59866887/128619895-24151c0a-f2c8-47d0-a158-cb1a7c4828f0.png)

### Display the output of the CPU on 7segment display
The 7 segment display has different pin allocation, it has a digit pin and a segment pin. In order to make sure the four 7 segment displays can represent different digit of a hex number, the following code is used(it does not have 7 pins for each of the display, therefore, in order to make the display show different number at the same time, we need to make sure the 7segment display flash quick enough to "trick" our eyes.
```
`timescale 1ns / 1ps 
module scan_led_hex_disp(
    input clk,
    input reset,
    input [3:0] hex0,
    input [3:0] hex1,
    input [3:0] hex2,
    input [3:0] hex3,
    output reg [3:0] an,   //片选
    output reg [6:0] sseg  //段选
    );
 // 四个数码管同时显示不同数据。
 localparam N = 18; //使用低16位对50Mhz的时钟进行分频(50MHZ/2^16)
 reg [N-1:0] regN; //高两位作为控制信号，低16位为计数器，对时钟进行分频
 reg [3:0] hex_in; //段选控制信号
 
 always@(posedge clk, posedge reset)
 begin
  if(reset)
   regN <= 0;
  else
   regN <= regN + 1;
 end
 
 always@ *
 begin
  case(regN[N-1:N-2])
  2'b00:begin
   an = 4'b0001; //选中第1个数码管
   hex_in = hex0; //数码管显示的数字由hex_in控制，显示hex0输入的数字；
  end
  2'b01:begin
   an = 4'b0010; 
   hex_in = hex1;
  end
  2'b10:begin
   an = 4'b0100;
   hex_in = hex2;
  end
  default:begin
   an = 4'b1000;
   hex_in = hex3;
  end
  
  endcase
 
 end
 always@ *
 begin
  case(hex_in)
      4'h0: sseg[6:0] = 7'b1000000;
		4'h1: sseg[6:0] = 7'b1111001;
		4'h2: sseg[6:0] = 7'b0100100;
		4'h3: sseg[6:0] = 7'b0110000;
		4'h4: sseg[6:0] = 7'b0011001;
		4'h5: sseg[6:0] = 7'b0010010;
		4'h6: sseg[6:0] = 7'b0000010;
		4'h7: sseg[6:0] = 7'b1111000;
		4'h8: sseg[6:0] = 7'b0000000;
		4'h9: sseg[6:0] = 7'b0011000;
		4'ha: sseg[6:0] = 7'b0001000;
		4'hb: sseg[6:0] = 7'b0000011;
		4'hc: sseg[6:0] = 7'b1000110;
		4'hd: sseg[6:0] = 7'b0100001;
		4'he: sseg[6:0] = 7'b0000110;
		4'hf: sseg[6:0] = 7'b0001110;
   default: sseg[6:0] = 7'b0111000;
  endcase
 end
endmodule
```
### Sending instructions from PC to FPGA(UART)
I am using UART to communicate between the FPGA and the PC, as UART is one of the simplest method to use. ![image](https://user-images.githubusercontent.com/59866887/129524898-c48aa4fe-4ca1-4362-a60c-1aa0ffd59171.png) Using the serial port on the FPGA, I can send instruction from PC to FPGA.
The verilog code for transmitter are shown below:
```
//串口助手设置:波特率9600 无奇偶校验位，8位数据位，一个停止位
//time:2019.11.13.22.41
module uart_tx(
 input            clk    ,
 input            rst_n  ,
 output   reg     uart_tx,
 input    [7:0]   data,
 input            tx_start
 );
 
 
parameter   CLK_FREQ = 50000000;                 
parameter   UART_BPS = 9600;     //波特率                 
localparam  PERIOD   = CLK_FREQ/UART_BPS;  
 
reg [7:0] tx_data;        //发送的数据
reg start_tx_flag;        //发送数据标志位
 
//记算一位数据需要多长时间PERIOD
reg   [15:0]   cnt0;
wire           add_cnt0;
wire           end_cnt0;
 
//发送几个数据
reg   [3:0]    cnt1;
wire           add_cnt1;
wire           end_cnt1;
 
 
 //发送标志位
 always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        start_tx_flag<=0;
		  tx_data<=0;
    end
    else if(tx_start) begin
        start_tx_flag<=1;    
		  tx_data<=data;      //把发送的数据存到这里来
		  
    end
    else if(end_cnt1) begin
        start_tx_flag<=0;
    end
end
 
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt0 <= 0;
    end
	 else if(end_cnt1) begin
	     cnt0 <= 0;
	 end
	 else if(end_cnt0) begin
	     cnt0 <= 0;
	 end
    else if(add_cnt0)begin
        cnt0 <= cnt0 + 1;
    end
end
assign add_cnt0 = start_tx_flag;       
assign end_cnt0 = add_cnt0 && cnt0==PERIOD-1;   //一位时间
 
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt1 <= 0;
    end
	 else if(end_cnt1) begin
	     cnt1 <= 0;
	 end
    else if(add_cnt1)begin
        cnt1 <= cnt1 + 1;
    end
end
 
assign add_cnt1 = end_cnt0 ;    
assign end_cnt1 = (cnt0==((PERIOD-1)/2))&& (cnt1==10-1);   //发送10位，包括停止位，空闲位
 
always  @(posedge clk or negedge rst_n)begin
      if(rst_n==1'b0)begin
         uart_tx<=1;               //空闲状态
      end
      else if(start_tx_flag) begin
		  if(cnt0==0)begin
           case(cnt1)
            4'd0:uart_tx<=0;         //起始位      
            4'd1:uart_tx<=tx_data[0]; 
				4'd2:uart_tx<=tx_data[1]; 
            4'd3:uart_tx<=tx_data[2];
            4'd4:uart_tx<=tx_data[3];
            4'd5:uart_tx<=tx_data[4];
            4'd6:uart_tx<=tx_data[5];
            4'd7:uart_tx<=tx_data[6];
            4'd8:uart_tx<=tx_data[7];
            4'd9:uart_tx<=1;       //停止位  
				default:;   
          endcase
        end  
      end 
end
endmodule
```
The verilog code for receiver are shown below:
```
//串口助手设置:波特率9600 无奇偶校验位，8位数据位，一个停止位
//time:2019.11.13.22.41
module uart_rx(
 input            clk    ,
 input            rst_n  ,
 input            uart_rx,
 output reg       uart_rx_done,
 output reg	[7:0] data
 );
 
   
parameter  CLK_FREQ = 50000000;                 
parameter  UART_BPS = 9600;      //波特率                
localparam PERIOD   = CLK_FREQ/UART_BPS;        
                                              
 
//接收的数据
reg [7:0] rx_data; 
 
 
reg       rx1,rx2;
wire      start_bit;
reg       start_flag;
 
 reg   [15:0]   cnt0;
 wire           add_cnt0;
 wire           end_cnt0;
 
 reg   [3:0]    cnt1;
 wire           add_cnt1;
 wire           end_cnt1;
 
 
 //下降沿检测 
assign  start_bit=(rx2)&(~rx1);
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
         rx1<=1'b0;
         rx2<=1'b0; 
    end
    else begin
         rx1<=uart_rx;
         rx2<=rx1;
    end
end
//开始标志位
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        start_flag<=0;
    end
    else if(start_bit) begin
        start_flag<=1;
    end
    else if(end_cnt1) begin
        start_flag<=0;
    end
end
 
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt0 <= 0;
    end
	 else if(end_cnt1) begin
	     cnt0 <= 0;
	 end
	 else if(end_cnt0) begin
	     cnt0 <= 0;
	 end
    else if(add_cnt0)begin
        cnt0 <= cnt0 + 1;
    end
end
assign add_cnt0 = start_flag;       
assign end_cnt0 = add_cnt0 && cnt0==PERIOD-1;
 
 
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt1 <= 0;
    end
	 else if(end_cnt1) begin
	     cnt1 <= 0;
	 end
    else if(add_cnt1)begin
        cnt1 <= cnt1 + 1;
    end
end
 
assign add_cnt1 = end_cnt0 ;    
assign end_cnt1 = (cnt0==((PERIOD-1)/2))&& (cnt1==10-1) ;  
 
//数据接收
always  @(posedge clk or negedge rst_n)begin
      if(rst_n==1'b0)begin
         rx_data<=8'd0;
      end
      else if(start_flag) begin
		  if(cnt0== PERIOD/2)begin
           case(cnt1)
            4'd1:rx_data[0]<=rx2;
            4'd2:rx_data[1]<=rx2;
            4'd3:rx_data[2]<=rx2;
            4'd4:rx_data[3]<=rx2;
            4'd5:rx_data[4]<=rx2;
            4'd6:rx_data[5]<=rx2;
            4'd7:rx_data[6]<=rx2;
            4'd8:rx_data[7]<=rx2;
		    default:rx_data<=rx_data;   
          endcase
        end
        else begin
            rx_data<=rx_data;
        end
     end
     else begin
         rx_data<=8'd0;
     end   
  end 
  //数据接收
 always  @(posedge clk or negedge rst_n)begin
      if(rst_n==1'b0)begin
           data<=0;
      end
      else if(end_cnt1)begin
          data<=rx_data;
      end  
  end
  
  //接收完成标志
 always  @(posedge clk or negedge rst_n)begin
     if(rst_n==1'b0)begin
         uart_rx_done<=0;
     end
     else if(end_cnt1)begin
         uart_rx_done<=1;
     end
     else begin
        uart_rx_done<=0;
     end
 end
endmodule
```
### Set up I/O standards and Pin assignment
The cyclone 10LP board needs a I/O standards of 3.3-V LVTTL. This can be set up on Quartus. Also, all unused pins needs to set up as input tri-stated.![image](https://user-images.githubusercontent.com/59866887/131060249-4e6299a8-cba1-4274-af7a-2780c1beb1ab.png)
The output of the project are: the 4 digits 7segment display, a reset button(which is the switch, it can be used to reset all the modules), a 50Mhz clock signal and two UART RX,TX ports.
I need to locate the pin using the table below:
![image](https://user-images.githubusercontent.com/59866887/128619929-ee8a7338-f50d-4289-8308-eec31d217f48.png)

### Store the project file inside the flash
The sof file will dispear after powing off the FPGA(when it is being stored inside the SRAM). In order to make sure the FPGA contains the sof file after powing off, the sof file can be stored in the flash, therefore we need to onvert the SOF file into jic file, following the steps below.
![image](https://user-images.githubusercontent.com/59866887/131063215-790ff2ca-0c9a-4476-bce9-f6528ea2494b.png)
Choose the device to be EPCS64:
![image](https://user-images.githubusercontent.com/59866887/131063321-4abe305b-d104-4a4e-bd99-02d8d9d29b68.png)
Choose the correct sof file and the PFGA device
![image](https://user-images.githubusercontent.com/59866887/131063862-9a430290-408e-4299-97db-55ae26f9102c.png)
Finally open the programmer and upload the jic file to the FPGA flash:
![image](https://user-images.githubusercontent.com/59866887/131063926-2c8f9064-45b0-42a0-a35c-baeeff6e5104.png)

## Implement MU0 using Chisel:
After finishing the steps above, I can now start implementing the CPU using chisel.
### Chisel Environment set up:
The chisel enviroment set up was finished based on the tutorial https://blog.csdn.net/qq_34291505/article/details/86744581, this is a detailed tutorial starts from learning scala to familiarize Chisel3. I am using Ubuntu 18.04.
The following reports should appear after running "sbt test"  
```
[info] welcome to sbt 1.4.9 (Private Build Java 1.8.0_292)
[info] loading settings for project chisel-template-build from plugins.sbt ...
[info] loading project definition from /home/songyu/Documents/Chisel_project/Songyu_Huang-Chisel/Chisel_MU0/chisel-template/project
[info] loading settings for project root from build.sbt ...
[info] set current project to %NAME% (in build file:/home/songyu/Documents/Chisel_project/Songyu_Huang-Chisel/Chisel_MU0/chisel-template/)
Elaborating design...
Done elaborating.
[info] Run completed in 4 seconds, 475 milliseconds.
[info] Total number of tests run: 1
[info] Suites: completed 1, aborted 0
[info] Tests: succeeded 1, failed 0, canceled 0, ignored 0, pending 0
[info] All tests passed.
[success] Total time: 7 s, completed Jul 26, 2021 5:21:12 PM
```  
This means that Chisel has set up successfully.
#### Simulation and Generating Verilog
I am using Vistual studio code as the text editor because it has Chisel syntax extention: 
![image](https://user-images.githubusercontent.com/59866887/126974995-2538c7c2-c795-4b60-9146-1230937c940c.png)  
Inserting the generated verilog file to Quartus and run Modelsim testbench is a good way to debug on the design, this is faster than writting testbench and runs using Verilator in my opinion.


### Individual module construction of MU0 (not all the module is listed), all modules were tested using modelsim on Quartus
The block digram of the circuit is shown below
#### Finite StateMachine
![image](https://user-images.githubusercontent.com/59866887/126973655-1616380d-b80b-4e8e-b173-004dac4a05f7.png)  
Chisel support Enum function which can be used to generate state names and corresponding parameters. 'Switch' function also can be used
```
import chisel3._
import chisel3.util._

class StateMachine extends Module {
    val io= IO(new Bundle{
      val extra = Input(Bool())
      val fetch = Output(Bool())
      val exec1 = Output(Bool())
      val exec2 = Output(Bool())
    })
   
   val fet :: ex1 :: ex2 :: Nil = Enum(3)
   val state = RegInit(fet)
    io.fetch := (state === fet)
    io.exec1 := (state === ex1)
    io.exec2 := (state === ex2)

switch (state) {
    is (fet) {
        state := ex1
    }
    is (ex1) {
      when (io.extra) {
        state := ex2
      } .otherwise {
        state := fet
      }
    }
    is (ex2) {
        state := fet
      }
    }
}
```  
The generated verilog code is shown below.
```
module StateMachine(
  input   clock,
  input   reset,
  input   io_extra,
  output  io_fetch,
  output  io_exec1,
  output  io_exec2
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  reg [1:0] state; // @[StateMachine.scala 15:23]
  wire  _T = 2'h0 == state; // @[Conditional.scala 37:30]
  wire  _T_1 = 2'h1 == state; // @[Conditional.scala 37:30]
  wire  _T_2 = 2'h2 == state; // @[Conditional.scala 37:30]
  assign io_fetch = state == 2'h0; // @[StateMachine.scala 16:24]
  assign io_exec1 = state == 2'h1; // @[StateMachine.scala 17:24]
  assign io_exec2 = state == 2'h2; // @[StateMachine.scala 18:24]
  always @(posedge clock) begin
    if (reset) begin // @[StateMachine.scala 15:23]
      state <= 2'h0; // @[StateMachine.scala 15:23]
    end else if (_T) begin // @[Conditional.scala 40:58]
      state <= 2'h1; // @[StateMachine.scala 22:15]
    end else if (_T_1) begin // @[Conditional.scala 39:67]
      if (io_extra) begin // @[StateMachine.scala 25:23]
        state <= 2'h2; // @[StateMachine.scala 26:15]
      end else begin
        state <= 2'h0; // @[StateMachine.scala 28:15]
      end
    end else if (_T_2) begin // @[Conditional.scala 39:67]
      state <= 2'h0; // @[StateMachine.scala 32:15]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  state = _RAND_0[1:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
```

#### RAM
Chisel supports RAM configuration in the Chisel3.uitl package. This is a single port RAM.  
We also need to initialize the memory of the RAM to insert the assemblly code.  
> Chisel memories can be initialized from an external binary or hex file emitting proper Verilog for synthesis or simulation. There are multiple modes of initialization.  
There is a function in the experimental package, it can read txt file and initialized in RAM.  
> def apply[T <: Data](memory: MemBase[T], fileName: String, hexOrBinary: FileType = MemoryLoadFileType.Hex): Unit  
This is just calling “$readmemh” and “$readmemb” in verilog, we need to follow verilog syntax when using this function.
```
package test
 
import chisel3._
import chisel3.util._

class RAM extends Module {
  val io = IO(new Bundle {
    val addr = Input(UInt(12.W))
    val dataIn = Input(UInt(16.W))
    val Wren = Input(Bool())
    val dataOut = Output(UInt(16.W))  
  })
  val syncRAM = SyncReadMem(1024, UInt(32.W))
    when(io.Wren) {
      syncRAM.write(io.addr, io.dataIn)
      io.dataOut := DontCare
    } .otherwise {
      io.dataOut := syncRAM.read(io.addr)
    }
  } 
  ```
  #### Top level Module (based on the block diagram above) 
  The top level module is used to connect ports between individual moodules. 
```
class CPU extends Module {
      val io = IO(new Bundle {
        val acc_out = Output(UInt(16.W))
        val IRq  = Output(UInt(12.W))
        val fetch = Output(Bool())
        val exec1 = Output(Bool())
        val exec2 = Output(Bool())
    })

    val stateMachine = Module (new StateMachine)
    val Compare = Module (new compare)
    val decoder = Module(new Decoder)
    val rAM =Module (new RAM)
    val programCounter =Module (new ProgramCounter)
    val acc = Module(new Accumulator)
    val insReg = Module (new InsReg)
    val Add_sub = Module (new add_sub)
    val lDI_select = Module(new LDI_select )
    val mUX2 = Mux(stateMachine.io.exec1,insReg.io.IR_out,rAM.io.dataOut)
    val mUX1 = Mux(decoder.io.sel1,mUX2(11,0),programCounter.io.PC_out)
    val mUX3 = Mux(decoder.io.sel3,lDI_select.io.LDI_acc ,Add_sub.io.add_out)
    io.fetch := stateMachine.io.fetch
    io.exec1 := stateMachine.io.exec1
    io.exec2 := stateMachine.io.exec2
    io.acc_out := acc.io.acc_out
    io.IRq := insReg.io.IR_out
    stateMachine.io.extra := decoder.io.extra
    decoder.io.fetch := stateMachine.io.fetch
    decoder.io.exec1 := stateMachine.io.exec1
    decoder.io.exec2 := stateMachine.io.exec2
    decoder.io.EQ := Compare.io.EQ
    decoder.io.GE := Compare.io.GE
    decoder.io.MI := Compare.io.MI
    decoder.io.opcode := mUX2(15,12)
    rAM.io.Wren := decoder.io.Wren
    rAM.io.dataIn := acc.io.acc_out
    rAM.io.addr := mUX1
    programCounter.io.PC_sload := decoder.io.PC_sload
    programCounter.io.cntEn := decoder.io.cntEn
    programCounter.io.addr := mUX2(11,0)
    acc.io.acc_sload := decoder.io.acc_sload
    acc.io.acc_en  := decoder.io.acc_en
    acc.io.dataIn := mUX3
    insReg.io.dataIn := rAM.io.dataOut
    insReg.io.IR_sload := decoder.io.IR_sload
    Add_sub.io.data1 := acc.io.acc_out
    Add_sub.io.data2 := rAM.io.dataOut
    Add_sub.io.add_sub := decoder.io.add_sub
    lDI_select.io.LDI_en := decoder.io.LDI_en
    lDI_select.io.acc_out :=rAM.io.dataOut
    Compare.io.acc_out := acc.io.acc_out
}
```
After adding all the generated verilog from Chisel to quartus and running on the FPGA, the CPU works fine.




