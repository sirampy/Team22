# example usage:
# make - verilates and opens waveform
# make counter - build counter and prepare roms
# make run - runs verilator without opening gtk

.PHONY: all counter

all : run gtk


run: clean
	verilator -Wall --cc -Irevised_microarch --trace revised_microarch/top.sv --exe test/top_tb.cpp 

	make -j -C obj_dir/ -f Vtop.mk Vtop

	obj_dir/Vtop


gtk: 
	gtkwave top.vcd


# build counter
counter:
	python3 test/counter/generate.py

	riscv64-unknown-elf-as -march=rv32im -o rom_bin/counter.out test/counter/counter.s
	riscv64-unknown-elf-ld -melf32lriscv -e 0xBFC00000 -Ttext 0xBFC00000 -o rom_bin/counter-reloc.out rom_bin/counter.out
	riscv64-unknown-elf-objcopy -O binary -j .text rom_bin/counter-reloc.out rom_bin/counter.bin
	riscv64-unknown-elf-objdump -D -S -l -F -Mno-aliases rom_bin/counter-reloc.out > rom_bin/counter.asm

	set -eu pipefail
	od -v -An -t x1 rom_bin/counter.bin | tr -s '\n' | awk '{counter=counter};1' > rom_bin/program.mem

	rm rom_bin/*.out
	rm rom_bin/*.bin


clean: 
	rm -rf obj_dir
	rm -f control_top.vcd
	rm -f *.hex rom_bin/*.asm rom_bin/*.out rom_bin/*.bin
