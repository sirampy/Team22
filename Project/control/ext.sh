rm -rf obj_dir
rm -f alu_decoder.vcd

verilator -Wall --cc --trace  alu_decoder.sv --exe alu_decoder_tb.cpp

make -j -C obj_dir/ -f Valu_decoder.mk Valu_decoder

obj_dir/Valu_decoder