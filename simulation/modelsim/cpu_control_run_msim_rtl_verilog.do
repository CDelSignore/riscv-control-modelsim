transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/colli/OneDrive/Fall23/331/Labs/lab3 {C:/Users/colli/OneDrive/Fall23/331/Labs/lab3/cpu_control.v}

vlog -vlog01compat -work work +incdir+C:/Users/colli/OneDrive/Fall23/331/Labs/lab3 {C:/Users/colli/OneDrive/Fall23/331/Labs/lab3/cpu_control_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  cpu_control_tb

add wave *
view structure
view signals
run -all
