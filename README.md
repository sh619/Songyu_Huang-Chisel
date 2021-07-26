# Chisel Project 
This is project that for myself to learn Chisel languge and hopefully finish some solid CPU design.  

## Implement MU0 CPU using Chisel
### Initial reaserch and FPGA set up:  
I have already implemented this CPU on Quartus last year using block digram design, therefore to implmented again using Chisel will be a excellent way to start the tutorial.  
First need to make sure that the design can run on MAX10 FPGA successfully. I am using MAX10 DE10 lite for the project.  
In order to run the MU0 design on FPGA, I need to change the current Quartus file to the suitable version to make sure the designed CPU can run on MAX10 FPGA(I am using MAX10). When trying to connect the FPGA to Quartus vis USB blaster, Quartus cannot recognize the FPGA board. After searching online, I found out that this maybe caused by other USB devices connected to the PC(from Intel community).![image](https://user-images.githubusercontent.com/59866887/124550922-ff393580-de63-11eb-8a4a-ea62713121fc.png) This problem cause a lot of time to find the problem and fix, which makes the project slightly behind the scheduled time.  

- The logic diagrams of MU0 is shown below:  
![image](https://user-images.githubusercontent.com/59866887/126938739-4815c741-feed-448c-a997-710c2fb807d2.png)  
- The detailed block diagram version with all the individual modules are shown below(top level design on Quartus):  
![image](https://user-images.githubusercontent.com/59866887/126939010-83d284b1-9fda-4c96-a3f3-74bcb8cad541.png)

### Implement MU0 using Chisel:
#### Chisel Environment set up:
The chisel enviroment set up was finished based on the tutorial > https://blog.csdn.net/qq_34291505/article/details/86744581, this is a detailed tutorial starts from learning scala to familiarize Chisel3.  
The following reports should appear after running "sbt test"  
```
@requires_authorization
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
This means that Chisel has set up successfully on your Computer
#### Individual module construction  
##### Finite StateMachine 




