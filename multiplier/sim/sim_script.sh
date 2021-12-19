vcom ../src/reg.vhd
vcom ../src/reg1bit.vhd
vcom ../tb/data_maker.vhd
vcom ../tb/clk_gen.vhd
vcom ../tb/data_sink.vhd
vlog ../tb/mult_tb.v

vcom ../../common/unpackfp_unpackfp.vhd
vcom ../../common/fpround_fpround.vhd
vcom ../../common/fpnormalize_fpnormalize.vhd
vcom ../../common/packfp_packfp.vhd


vcom ../src/MBE/packg.vhd
vcom ../src/MBE/*
vcom ../src/fpmul_stage1_struct.vhd
vcom ../src/fpmul_stage2_struct_MBE.vhd
vcom ../src/fpmul_stage3_struct.vhd
vcom ../src/fpmul_stage4_struct.vhd
vcom ../src/fpmul_pipeline.vhd

vsim -t 100ps work.mult_tb

add wave *
run 200ns
