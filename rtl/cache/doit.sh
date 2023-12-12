#!/bin/sh

# cleanup
rm -rf obj_dir
rm -f *.vcd

# run Verilator to translate Verilog into C++, including C++ testbench
verilator -Wall --cc --trace direct_mapped_cache.sv --exe top_tb.cpp

# build C++ project via make automatically generated by Verilator
make -j -C obj_dir/ -f Vdirect_mapped_cache.mk Vdirect_mapped_cache

# run executable simulation file
echo "\nRunning simulation"
obj_dir/Vdirect_mapped_cache
echo "\nSimulation completed"