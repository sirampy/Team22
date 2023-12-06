.PHONY: all counter

all : run

run:
	rm -rf obj_dir
	rm -f control_top.vcd

	verilator -Wall --cc -Irevised_microarch --trace revised_microarch/top.sv --exe test/top_tp.cpp 

	make -j -C obj_dir/ -f Vtop.mk Vtop

	obj_dir/Vcontrol_top