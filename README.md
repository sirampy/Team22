# Team 22 - RISC-V RV32I Processor

## About this branch
This branch was created as a result of a decoder redesign intended to create a more robust microarchitecture desigened from the ground up to efficiently support the entire rv32i instruction set. Thhe V2 cpu also aims to solve code clarity issues with extensive usee of enums and unions for control signals to minimise "magic numbers" in the codebase. 

## Structure
V2 has been structured to seperate the RTL design and testing as much as possible:
### revised_microarch
This is where the RTL design lives. I recommend starting with top.sv and decoder.sv to get an idea of how the instructions are excecuted

### rom_bin
this directory contains .mem files which are loaded as ascii hex into the RTL modle when running a testbench. This also contains a dissasembled version of the elf for debugging purposes, and is used as the build folder by the assembler

### test
this contains a testbench that stimulates the top level module's clock, as well as source files for test programs. The idea is that diferent parts of the instruction set can be tested with diferent test programs and verified manually with gtkwave. this keeps testing simple and removes the need for highly specific testbenches.

### Makefile
this file contains scripts for building and testing the project.

### Other
The rest of the files / folders relate to documentation and explanation of tests, or are legacy code from v1.

## Architecture
![summary](images/microarch.jpeg)
The above photo shows a rough diagram of the microarhitecture. The design re-uses the ALU for anny instruction needing an adder, making the architecture highly efficient and closely taylored to the instruction set. The control signals generated by the decoder makes it easy for extensions to be added dont the line that may re-use components form the RV32I. to maximise efficiency, several control signals are taken directly from the opcode for certain instructions. 

This approach also lends itself nicely for decoder to be fited with [microcode](https://en.wikipedia.org/wiki/Microcode) rom (not to be mistaken with firmware), allowing for bug fixes post production, and even user customisable opcodes and instructions.

The pc is of width 16 in this branch as none of the test programs need the entire code space. It also reduces the ammount of memory we need to allocate.

## How to use
All of the scripts need to test / build this branch are in the makefile.
First initialise the program mems by building a test program:
```
make <program_name>
```
Then run the simulation 
```
make run
```
Finally, you can open gtkwave
```
make gtk
```
explore the makefile yourself for futher use cases.
for more info see [testing results](testing_results.md)
