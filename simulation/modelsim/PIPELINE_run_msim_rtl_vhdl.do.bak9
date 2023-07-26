transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/projects/Pipeline_RISCV/PIPELINE.vhd}
vcom -93 -work work {D:/projects/Pipeline_RISCV/X_REG.vhd}
vcom -93 -work work {D:/projects/Pipeline_RISCV/genImm32.vhd}
vcom -93 -work work {D:/projects/Pipeline_RISCV/PC.vhd}
vcom -93 -work work {D:/projects/Pipeline_RISCV/MD.vhd}
vcom -93 -work work {D:/projects/Pipeline_RISCV/MI.vhd}
vcom -93 -work work {D:/projects/Pipeline_RISCV/Mux21.vhd}
vcom -93 -work work {D:/projects/Pipeline_RISCV/Controle.vhd}
vcom -93 -work work {D:/projects/Pipeline_RISCV/ULA.vhd}
vcom -93 -work work {D:/projects/Pipeline_RISCV/Somador8bits.vhd}

vcom -93 -work work {D:/projects/Pipeline_RISCV/PIPELINE_TB.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  PIPELINE_TB

add wave *
view structure
view signals
run -all
