transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/huang/OneDrive\ -\ Imperial\ College\ London/circuit\ and\ system/FPGA\ lab\ bakup/E2_circuit_system/mylib/bin2bcd_16.v {C:/Users/huang/OneDrive - Imperial College London/circuit and system/FPGA lab bakup/E2_circuit_system/mylib/bin2bcd_16.v/bin2bcd_16.v}
vlog -vlog01compat -work work +incdir+C:/Users/huang/OneDrive\ -\ Imperial\ College\ London/circuit\ and\ system/FPGA\ lab\ bakup/E2_circuit_system/mylib {C:/Users/huang/OneDrive - Imperial College London/circuit and system/FPGA lab bakup/E2_circuit_system/mylib/hex_to_7seg.v}
vlog -vlog01compat -work work +incdir+C:/Users/huang/OneDrive\ -\ Imperial\ College\ London/circuit\ and\ system/FPGA\ lab\ bakup/E2_circuit_system/mylib {C:/Users/huang/OneDrive - Imperial College London/circuit and system/FPGA lab bakup/E2_circuit_system/mylib/clktick.v}
vlog -vlog01compat -work work +incdir+C:/Users/huang/OneDrive\ -\ Imperial\ College\ London/circuit\ and\ system/FPGA\ lab\ bakup/E2_circuit_system/lab7/challenge\ 4 {C:/Users/huang/OneDrive - Imperial College London/circuit and system/FPGA lab bakup/E2_circuit_system/lab7/challenge 4/FSM.v}
vlog -vlog01compat -work work +incdir+C:/Users/huang/OneDrive\ -\ Imperial\ College\ London/circuit\ and\ system/FPGA\ lab\ bakup/E2_circuit_system/lab7/challenge\ 4 {C:/Users/huang/OneDrive - Imperial College London/circuit and system/FPGA lab bakup/E2_circuit_system/lab7/challenge 4/Delay.v}
vlog -vlog01compat -work work +incdir+C:/Users/huang/OneDrive\ -\ Imperial\ College\ London/circuit\ and\ system/FPGA\ lab\ bakup/E2_circuit_system/lab7/challenge\ 4 {C:/Users/huang/OneDrive - Imperial College London/circuit and system/FPGA lab bakup/E2_circuit_system/lab7/challenge 4/LFSR_7.v}
vlog -vlog01compat -work work +incdir+C:/Users/huang/OneDrive\ -\ Imperial\ College\ London/circuit\ and\ system/FPGA\ lab\ bakup/E2_circuit_system/lab7/challenge\ 4 {C:/Users/huang/OneDrive - Imperial College London/circuit and system/FPGA lab bakup/E2_circuit_system/lab7/challenge 4/reaction.v}
vlog -vlog01compat -work work +incdir+C:/Users/huang/OneDrive\ -\ Imperial\ College\ London/circuit\ and\ system/FPGA\ lab\ bakup/E2_circuit_system/lab7/challenge\ 4 {C:/Users/huang/OneDrive - Imperial College London/circuit and system/FPGA lab bakup/E2_circuit_system/lab7/challenge 4/lab7challenge4.v}

