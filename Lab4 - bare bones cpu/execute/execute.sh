rm -rf obj_dir
rm -f topALU.vcd

verilator -Wall --cc --trace  alu_rop.sv --exe topALU_tb.cpp

make -j -C obj_dir/ -f VtopALU.mk VtopALU

obj_dir/VtopALU