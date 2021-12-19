analyze -f vhdl -lib work ../src/packg.vhd
analyze -f vhdl -lib work ../src/full_adder.vhd
analyze -f vhdl -lib work ../src/half_adder.vhd
analyze -f vhdl -lib work ../src/booth_mux.vhd
analyze -f vhdl -lib work ../src/booth_encoder.vhd
analyze -f vhdl -lib work ../src/adder_gen.vhd
analyze -f vhdl -lib work ../src/dadda_l6.vhd
analyze -f vhdl -lib work ../src/dadda_l5.vhd
analyze -f vhdl -lib work ../src/dadda_l4.vhd
analyze -f vhdl -lib work ../src/dadda_l3.vhd
analyze -f vhdl -lib work ../src/dadda_l2.vhd
analyze -f vhdl -lib work ../src/dadda_l1.vhd
analyze -f vhdl -lib work ../src/dadda_tree.vhd
analyze -f vhdl -lib work ../src/MBE.vhd

elaborate MBE -arch struct -lib work

report_timing > ./report_timing.txt
report_area > ./report_area.txt

