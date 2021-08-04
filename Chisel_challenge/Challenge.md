# Update：
7.27 —— 8.1 Complete the f1 LED challenge using chisel
# Description
The goal in this Challenge is to design a Formula 1 style of race starting lights.  
The link below is to a YouTube video on a similar light with sound. (Sound is not required for this Challenge.  
> https://www.youtube.com/watch?v=FtT9IV1Q7Dg
Use chisel to complete the challenge
     
The specification of the circuit is:  
1. The circuit is triggered (or started) by pressing KEY[1];  
2. The 10 LEDs (above the slide switches) will then start lighting up from left to right at 0.5 second interval, until all LEDs are ON;  
3. The circuit then waits for a random period of time between 0.25 and 16 seconds before all LEDs turn OFF;  
4. You should also display the random delay period in milliseconds on five 7-segment displays.
5. The circuit should count the time between all the LEDs turning OFF and you pressing KEY[0]. The reaction time should be displayed on the 7-segment displays in milliseconds in place of the random delay   
## Errors encountered during the design
I tried to use >  chisel3.Driver.execute(args, () => new ) to run the design at first, However, sometimes it cannot generate verilog and does not produce the correct error description.
``` 
[info] welcome to sbt 1.4.9 (Private Build Java 1.8.0_292)
[info] loading settings for project chisel-template-build from plugins.sbt ...
[info] loading settings for project root from build.sbt ...
Elaborating design...
Done elaborating.
[error]         at 
[success] Total time: 4 s, completed Jul 26, 2021 7:35:52 PM 
```
I then tried to change the execute instruction, 
```
import chisel3.stage.{ChiselStage, ChiselGeneratorAnnotation}
object CPU_Gen extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(new FSM,args)
}
``` 
The "emitverilog" is better than the old version of the instuction. Then it produced the error below:
```
[error] (run-main-0) firrtl.transforms.CheckCombLoops$CombLoopException: : [module FSM] Combinational loop detected:
```
After searching online, I found 


