rm -rf obj_dir
rm -f control_top.vcd

verilator -Wall --cc --trace ../revised_microarch/top.sv --exe top_tp.cpp -y ../revised_microarch

make -j -C obj_dir/ -f Vcontrol_top.mk Vcontrol_top

obj_dir/Vcontrol_top