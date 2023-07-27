transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/projects/Pipeline/PIPE_FETCH.vhd}
vcom -93 -work work {D:/projects/Pipeline/PIPELINE.vhd}
vcom -93 -work work {D:/projects/Pipeline/MI.vhd}
vcom -93 -work work {D:/projects/Pipeline/PC.vhd}
vcom -93 -work work {D:/projects/Pipeline/Mux21.vhd}
vcom -93 -work work {D:/projects/Pipeline/PIPE_IF_ID.vhd}
vcom -93 -work work {D:/projects/Pipeline/PIPE_DECODE.vhd}
vcom -93 -work work {D:/projects/Pipeline/Controle.vhd}
vcom -93 -work work {D:/projects/Pipeline/X_REG.vhd}
vcom -93 -work work {D:/projects/Pipeline/genImm32.vhd}
vcom -93 -work work {D:/projects/Pipeline/PIPE_ID_EX.vhd}
vcom -93 -work work {D:/projects/Pipeline/PIPE_EXECUTE.vhd}
vcom -93 -work work {D:/projects/Pipeline/ULA.vhd}
vcom -93 -work work {D:/projects/Pipeline/PIPE_EX_MEM.vhd}
vcom -93 -work work {D:/projects/Pipeline/PIPE_MEM.vhd}
vcom -93 -work work {D:/projects/Pipeline/MD.vhd}
vcom -93 -work work {D:/projects/Pipeline/PIPE_WB.vhd}
vcom -93 -work work {D:/projects/Pipeline/ADD_PC.vhd}

vcom -93 -work work {D:/projects/Pipeline/PIPELINE_TB.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  PIPELINE_TB

add wave *
view structure
view signals
run -all
