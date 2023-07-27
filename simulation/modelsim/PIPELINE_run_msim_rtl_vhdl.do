transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/projects/Pipeline1/PIPE_FETCH.vhd}
vcom -93 -work work {D:/projects/Pipeline1/PIPELINE.vhd}
vcom -93 -work work {D:/projects/Pipeline1/MI.vhd}
vcom -93 -work work {D:/projects/Pipeline1/PC.vhd}
vcom -93 -work work {D:/projects/Pipeline1/Mux21.vhd}
vcom -93 -work work {D:/projects/Pipeline1/PIPE_IF_ID.vhd}
vcom -93 -work work {D:/projects/Pipeline1/PIPE_DECODE.vhd}
vcom -93 -work work {D:/projects/Pipeline1/Controle.vhd}
vcom -93 -work work {D:/projects/Pipeline1/X_REG.vhd}
vcom -93 -work work {D:/projects/Pipeline1/genImm32.vhd}
vcom -93 -work work {D:/projects/Pipeline1/PIPE_ID_EX.vhd}
vcom -93 -work work {D:/projects/Pipeline1/PIPE_EXECUTE.vhd}
vcom -93 -work work {D:/projects/Pipeline1/ULA.vhd}
vcom -93 -work work {D:/projects/Pipeline1/PIPE_EX_MEM.vhd}
vcom -93 -work work {D:/projects/Pipeline1/PIPE_MEM.vhd}
vcom -93 -work work {D:/projects/Pipeline1/MD.vhd}
vcom -93 -work work {D:/projects/Pipeline1/PIPE_WB.vhd}
vcom -93 -work work {D:/projects/Pipeline1/ADD_PC.vhd}

vcom -93 -work work {D:/projects/Pipeline1/PIPELINE_TB.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  PIPELINE_TB

add wave *
view structure
view signals
run -all
