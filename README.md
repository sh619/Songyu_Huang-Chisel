# Songyu_Huang-Chisel
A project on implementing CPU on FPGA using Chisel
## Implement MU0 CPU using Chisel
The initial attempt is to set up the Chisel bootcamp
### Initial reaserch:
Initial reaserch on MU0 cpu and organising Quartus file. In order to run the MU0 design on FPGA, I need to change the current Quartus file to the suitable version to make sure the designed CPU can run on MAX10 PFGA. When trying to connect the FPGA to Quartus vis USB blaster, Quartus cannot recognize the FPGA board. After searching online, I found out that this maybe caused by other USB devices connected to the PC(from Intel community).![image](https://user-images.githubusercontent.com/59866887/124550922-ff393580-de63-11eb-8a4a-ea62713121fc.png) This problem cause a lot of time to find the problem and fix, which makes the project slightly behind the scheduled time. I am currently working on the connection between the CPU and the FPGA. 
-The logic diagrams of MU0 is shown below:
![image](https://user-images.githubusercontent.com/59866887/126938739-4815c741-feed-448c-a997-710c2fb807d2.png)
-The detailed block diagram version with all the individual modules are shown below:
![image](https://user-images.githubusercontent.com/59866887/126939010-83d284b1-9fda-4c96-a3f3-74bcb8cad541.png)

### Implement MU0 using Chisel:
Environment set up:
The chisel enviroment set up was finished based on the tutorial https://blog.csdn.net/qq_34291505/article/details/86744581
