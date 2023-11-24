rm -rf obj_dir
rm -f alu_top.vcd

verilator -Wall --cc --trace  alu_top.sv --exe alu_top_tb.cpp

make -j -C obj_dir/ -f Valu_top.mk Valu_top

obj_dir/Valu_top