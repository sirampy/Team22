# example usage:
# make - verilates and opens waveform
# make counter - build counter and prepare roms
# make run - runs verilator without opening gtk

.PHONY: all clean clean_build clean_asssemble gtk

all : run gtk


run: clean_build
	verilator -Wall --cc -Irtl --trace rtl/top.sv --exe test/top_tb.cpp 

	make -j -C obj_dir/ -f Vtop.mk Vtop

	obj_dir/Vtop


gtk: 
	gtkwave top.vcd


clean: clean_build clean_assemble
	@echo cleaned all

clean_build: 
	rm -rf obj_dir
	rm -f control_top.vcd

clean_assemble:
	@echo "cleaning assembly build"
	rm -f *.hex rom_bin/*.asm rom_bin/*.out rom_bin/*.bin


# assemble a test (sadly make dosnt like phony patterns - would require a funk function)
# TODO: make this work for programs with a proper .text section instead of generate.py
%:
	@echo $@
	rm -f rom_bin/*.asm

	python3 test/$@/generate.py

	riscv64-unknown-elf-as -march=rv32im -o rom_bin/$@.out test/$@/$@.s
	riscv64-unknown-elf-ld -melf32lriscv -e 0xBFC00000 -Ttext 0xBFC00000 -o rom_bin/$@-reloc.out rom_bin/$@.out
	riscv64-unknown-elf-objcopy -O binary -j .text rom_bin/$@-reloc.out rom_bin/$@.bin
	riscv64-unknown-elf-objdump -D -S -l -F -Mno-aliases rom_bin/$@-reloc.out > rom_bin/$@.asm

	set -eu pipefail
	od -v -An -t x1 rom_bin/$@.bin | tr -s '\n' | awk '{$@=$@};1' > rom_bin/program.mem

	rm rom_bin/*.out
	rm rom_bin/*.bin

