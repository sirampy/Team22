rm -rf obj_dir
rm -f signextend.vcd

verilator -Wall --cc --trace  signextend.sv --exe signextend_tb.cpp

make -j -C obj_dir/ -f Vsignextend.mk Vsignextend

obj_dir/Vsignextend