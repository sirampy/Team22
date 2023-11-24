rm -rf obj_dir
rm -f sign_extend.vcd

verilator -Wall --cc --trace  sign_extend.sv --exe sign_ext_tb.cpp

make -j -C obj_dir/ -f Vsign_extend.mk Vsign_extend

obj_dir/Vsign_extend