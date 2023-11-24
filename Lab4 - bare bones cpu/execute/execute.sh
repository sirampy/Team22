rm -rf obj_dir
rm -f alu_top.vcd

<<<<<<< HEAD
verilator -Wall --cc --trace  alu_top.sv --exe alu_top_tb.cpp
=======
verilator -Wall --cc --trace  alu_rop.sv --exe topALU_tb.cpp
>>>>>>> 0def940533e9b61ece8b69008b20372cf1ff84fa

make -j -C obj_dir/ -f Valu_top.mk Valu_top

obj_dir/Valu_top