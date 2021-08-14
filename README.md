# Chisel Project 
This project is for myself to learn Chisel language and hopefully finish some solid CPU design on FPGA.  

## Implement MU0 CPU using Chisel
### Initial reaserch and FPGA set up:  
I have already implemented this CPU on Quartus last year using block digram design, therefore to implmented again using Chisel will be a excellent way to start the tutorial.  
First need to make sure that the design can run on Cyclone10 FPGA successfully. I am using Cyclone10 for the project.  
In order to run the MU0 design on FPGA, I need to change the current Quartus file to the suitable version to make sure the designed CPU can run on Cyclone10 FPGA. When trying to connect the FPGA to Quartus vis USB blaster, Quartus cannot recognize the FPGA board. After searching online, I found out that this maybe caused by other USB devices connected to the PC(from Intel community).![image](https://user-images.githubusercontent.com/59866887/124550922-ff393580-de63-11eb-8a4a-ea62713121fc.png) This problem cause a lot of time to find the problem and fix, which makes the project slightly behind the scheduled time.  

- The logic diagrams of MU0 is shown below:  
![image](https://user-images.githubusercontent.com/59866887/126938739-4815c741-feed-448c-a997-710c2fb807d2.png)  
- The detailed block diagram version with all the individual modules are shown below(top level design on Quartus):  
![image](https://user-images.githubusercontent.com/59866887/126939010-83d284b1-9fda-4c96-a3f3-74bcb8cad541.png)
- With the following instructions:
![image](https://user-images.githubusercontent.com/59866887/126984500-08d65ecf-f881-4501-a19f-6d56afabd827.png)

### Sending instruction from PC to FPGA

### Implement MU0 using Chisel:
#### Chisel Environment set up:
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
##### Simulation and Generating Verilog
I am using Vistual studio code as the text editor because it has Chisel syntax extention: 
![image](https://user-images.githubusercontent.com/59866887/126974995-2538c7c2-c795-4b60-9146-1230937c940c.png)  
Inserting the generated verilog file to Quartus and run Modelsim testbench is a good way to debug on the design, this is faster than writting testbench and runs using Verilator in my opinion.


#### Individual module construction of MU0 (not all the module is listed), all modules were tested using modelsim on Quartus
The block digram of the circuit is shown below
##### Finite StateMachine
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

##### RAM
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
  ##### Top level Module (based on the block diagram above) 
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
I am trying to compile this top level module, however, I keep getting this error message which contains **no error description** and also returns success, firrtl file is generated but verilog can not be generated. Has anyone had this issue before?
```
[info] welcome to sbt 1.4.9 (Private Build Java 1.8.0_292)
[info] loading settings for project chisel-template-build from plugins.sbt ...
[info] loading project definition from /home/songyu/Documents/Chisel_project/Songyu_Huang-Chisel/Chisel_MU0/chisel-template/project
[info] loading settings for project root from build.sbt ...
[info] set current project to %NAME% (in build file:/home/songyu/Documents/Chisel_project/Songyu_Huang-Chisel/Chisel_MU0/chisel-template/)
[warn] multiple main classes detected: run 'show discoveredMainClasses' to see the list
[info] running test.CPU_GEN -td ./generated/CPU
Elaborating design...
Done elaborating.
[error]         at 
[success] Total time: 4 s, completed Jul 26, 2021 7:35:52 PM
```




