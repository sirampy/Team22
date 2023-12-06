rm -rf obj_dir
rm -f alu.vcd

verilator -Wall --cc --trace alu.sv --exe alu_tb.cpp 

make -j -C obj_dir/ -f Valu.mk Valu

obj_dir/Valu