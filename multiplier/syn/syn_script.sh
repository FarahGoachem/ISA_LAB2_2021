analyze -f vhdl -lib WORK ../src/reg.vhd
analyze -f vhdl -lib WORK ../src/reg1bit.vhd

analyze -f vhdl -lib WORK ../src/MBE/packg.vhd
analyze -f vhdl -lib WORK ../src/MBE/half_adder.vhd
analyze -f vhdl -lib WORK ../src/MBE/full_adder.vhd
analyze -f vhdl -lib WORK ../src/MBE/booth_mux.vhd
analyze -f vhdl -lib WORK ../src/MBE/booth_encoder.vhd
analyze -f vhdl -lib WORK ../src/MBE/adder_gen.vhd
analyze -f vhdl -lib WORK ../src/MBE/dadda_l6.vhd
analyze -f vhdl -lib WORK ../src/MBE/dadda_l5.vhd
analyze -f vhdl -lib WORK ../src/MBE/dadda_l4.vhd
analyze -f vhdl -lib WORK ../src/MBE/dadda_l3.vhd
analyze -f vhdl -lib WORK ../src/MBE/dadda_l2.vhd
analyze -f vhdl -lib WORK ../src/MBE/dadda_l1.vhd
analyze -f vhdl -lib WORK ../src/MBE/dadda_tree.vhd
analyze -f vhdl -lib WORK ../src/MBE/MBE.vhd

analyze -f vhdl -lib WORK ../../common/unpackfp_unpackfp.vhd
analyze -f vhdl -lib WORK ../../common/fpround_fpround.vhd
analyze -f vhdl -lib WORK ../../common/fpnormalize_fpnormalize.vhd
analyze -f vhdl -lib WORK ../../common/packfp_packfp.vhd
analyze -f vhdl -lib WORK ../src/fpmul_stage1_struct.vhd
analyze -f vhdl -lib WORK ../src/fpmul_stage2_struct.vhd
analyze -f vhdl -lib WORK ../src/fpmul_stage3_struct.vhd
analyze -f vhdl -lib WORK ../src/fpmul_stage4_struct.vhd
analyze -f vhdl -lib WORK ../src/fpmul_pipeline.vhd

elaborate FPmul_pipeline -arch pipeline -lib WORK > ./reports/MBE_elaborate.txt

uniquify
link

create_clock -name MY_CLK -period 0  clk

set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clocks MY_CLK]

set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]

set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

ungroup -all -flatten

compile

report_timing -attributes > ./reports/MBE_report_timing_clk_max.txt

report_area > ./reports/MBE_report_area_max.txt

report_resources > ./reports/MBE_report_resources.txt
