## methods
### scope
testing the entire instruction set that I have implemented exhaustively is a large and tedious task. Without using a pre-existing verification library (eg: https://github.com/SymbioticEDA/riscv-formal) the easiest way to easiest way to test that all parts of the processor work as intended is to test them together as one with some test programs. this may miss some edge cases, and not cover all instructions, it allows us to simply look at the output of the program to verify that it has run correctly without necesarily having to look at the program excecution on a single cycle basis
### prerequisites
to run the tests properly, you must have all the required tools installed. these include verilator, the gnu riscv toolchain and gcc targeting the machine you are building the project with. 
### running the tests
to run the tests, you first need to assemble the program to generate the correct .mem files:
```bash
make counter
```
then you need to build the cpu and run the modle:
```bash
make
make run
```
the diference between the above 2 make targets is that all will run gtkwave (this is likely the most commonly used test methood) to allow you to verify the results, whereas run will simply build the cpu (useful for getting the cpu to compile correctly). 
## test programs
### 1. Counter
![Counter program running](images/counter_working.png)
![Counter program running](images/counter_code.png)
we can see that the program is running and branching as intended. this test implies the successful implementation of some basic instructions, and demostrates that the architecture as a whole works
### 2. alu+regfile
![ALU testing](image.png)
![GTKWave](<WhatsApp Image 2023-11-30 at 20.41.51_ee4dc1b7.jpg>)
![GTKWave2](image-1.png)
Tested alu_top.sv with alu_top_tb.cpp by directly putting input signals and checking if the output signals were as expected - verified this on GTKWave.