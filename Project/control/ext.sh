rm -rf obj_dir
rm -f controlunit.vcd

verilator -Wall --cc --trace  controlunit.sv --exe control_tb.cpp

make -j -C obj_dir/ -f Vcontrolunit.mk Vcontrolunit

obj_dir/Vcontrolunit