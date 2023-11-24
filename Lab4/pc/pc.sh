rm -rf obj_dir
rm -f pc_top.vcd

verilator -Wall --cc --trace pc_top.sv --exe pc_tb.cpp
make -j -C obj_dir/ -f Vpc_top.mk Vpc_top

obj_dir/Vpc_top