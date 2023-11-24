rm -rf obj_dir
rm -f pc_top.vcd

verilator -Wall --cc --trace pc_top.sv pc_reg.sv pc_multiplx.sv --exe pc_tb.cpp
<<<<<<< HEAD
make -j -C obj_dir/ -f Vpc_top.mk Vpc_top
=======
make -j -C obj_dir/ -f Vpctop.mk Vpctop
>>>>>>> 0def940533e9b61ece8b69008b20372cf1ff84fa

obj_dir/Vpc_top