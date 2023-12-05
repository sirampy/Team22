rm -rf obj_dir
rm -f control_top.vcd

verilator -Wall --cc --trace decoder.sv --exe hi

make -j -C obj_dir/ -f Vcontrol_top.mk Vcontrol_top

obj_dir/Vcontrol_top