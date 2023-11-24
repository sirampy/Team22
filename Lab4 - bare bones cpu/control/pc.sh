rm -rf obj_dir
rm -f pctop.vcd

verilator -Wall --cc --trace pc_top.sv pc_reg.sv pc_multiplx.sv --exe pc_tb.cpp
make -j -C obj_dir/ -f Vpctop.mk Vpctop

obj_dir/Vpctop