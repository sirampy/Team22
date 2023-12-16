 Alex's statement
## [Lab 4](https://github.com/sirampy/Team22/tree/lab4_done) 
To start the project off, I was assigned to work on the register file. Whilst I believe it has been changed since for readability purposes, at the time it was optimised to allocate minimal writable memory by not allocating value in the zero register as a literal as opposed to another entry in the register file. <br>
Other responisbilities I took on were the [extend unit](https://github.com/sirampy/Team22/commit/8046c70e6c0b46a0f447cb3f9c315dfc568c1c5e), which I wrote the original version of, and contributions to the [momories](https://github.com/sirampy/Team22/commit/06211f12d052c2f46c33523db0930d9b1946ce8c) (dont mind the word adressing - i fixed that leter). 
perhaps my largest contribution was refactoring the entire codebase to enforce a style guide (linked in main md).

## [Early caching](https://github.com/sirampy/Team22/commit/290ba29df5d0e37dceab914ae316e38cee569d93)
The task I was initially allocated wac to be in charge of the cache. I made plans for a basic direct maped cache that was highly parameterised as a basis to later build a more advanced 2-way set associative cache. I designed the interface to match the IO at the time used in the single-cycle memory, and just left gaps to be filled in with the interface with the memory, once i had figured out if I would need to spoof long memory read times (requiring a read/write queue) or not. I then realised that progress on the single-cycle CPU was poor and decided I aught to prioritise making a working processor before continuing with the cache memory.

## [Version 2](https://github.com/sirampy/Team22/tree/version-2) <- link to branch 
After thouroughly examining the instruction encoding I crafted a new decoding system that would minimise complexity when implemented in hardware. I did this by avoiding transcoding opcodes where posible and re-using the ALU adder for calculating address offsets. I started work on this branch before lab4 was complete after seeing that we did not yet have a working processor. <br> This branch was designed carefully to match the specification RiscV [manual (vol.1)](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf), meaning that is highly extendible, and implements all the quirks of the RV32I instruction set correctly (EG: shift instructions only look at lower 5 bits, even if its not an immediate instruction).
```sv
L_SHIFT: result_o = src1_i << src2_i [4:0];
```
The following snippet shows how the decoder sends an add instruction to the ALU, settig the alu sources to read form RS1 and the immediate. srcr (return source) and re_write_o then dictates that the rd should have the PC of the next instruction (sourced from outside the decoder as it can vary based on extension). to avoid corrupting the data memory and to specify that we want to use the ALU rsult rather than a memory read we set data_read and data_write to 0. finaly, we tell the bcu (branch control unit) to force a jump, selecting the next PC value to be sourced from the ALU output.
```sv
        I_JALR: begin // TODO: enforce funct3 - 0x0 (currently dosnt respect reserved instructions - fixing this is only necesarry to enable extensions)

            alu3_o = ADD;
            alu7_o = I_STD;

            src1_o = RS1;
            src2_o = IS_IMM12;
            imm12_o = i_imm;

            srcr_o = NEXT_PC;
            reg_write_o = 1;
            data_read_o = 0;
            data_write_o = 0;
            pc_control_o = JUMP;

        end 
```
To avoid "magic numbers" (a reall pet peev of mine) in my code, I made extensive use of [System Verilog's typing system](http://www.ece.uah.edu/~gaede/cpe526/SystemVerilog_3.1a.pdf), using enums and unions to show clarify what a signal means in a given context. 
For more details on how this CPU works, I urge you to read the [readme in the version 2 branch](https://github.com/sirampy/Team22/tree/version-2).
## [Testing version 2](https://github.com/sirampy/Team22/blob/version-2/testing_results.md)
This was the first CPU in the project to be able to be ready for top level testing, so I created a test suite using a makefile (one of my favorite tools for projects like this) that automated the assembly and build process. I used this testing setup to debug my cpu fully, getting it to run the pdf program (see above hyperlink). knowing that my CPU works, Sophie used my testing framework and cpu to verify the F1 lights program she was working on. I considered creating a more advanced suite of tools that used qemu and gdb to compare the state of an emulated cpu to our cpu, but decided my time was better used to help my team pipeline and cache the CPU. 

## A teamwork challenge
At this stage, our project became quite fragmented, as the pipelining and caching branches were both build on a still non-functional lab4 based CPU, and none of the other branches were properly tested. This posed several dilemmas. If we canned the original branch, manny commits would "go to waste", and they would be unable to take credit for the underlying V2 cpu as I had implemented fully myself. I could either pressure my team into learning my design so we could work together in pipelining and caching it, or I could get to work testing and fixing the existing pipelining branch. Not wanting my team-mates to have to re-adapt their work i decided to take a look at a single-cycle bassed pipelining branch, and run my tests to see where it was up to. I found the basic pipelining branch to be buggy, and my unfamiliarity with the branch made debugging difficult. I believe I found a bug relating to a value in a being used from the wrong stage, which I fixed to get some of my tests to pass. The issues in the underlying CPU became quickly apparant, however, as manny instructions were not implemented correctly. At the time Matteusz was in working on fixing the single-cycle processor, and he came to the same conclusion that I had a few days prior - The best idea was to rebuild the cpu from the ground up - which He then did (SINGLE-CYCLE-REDO / V3).

## [version 2 pipelined](https://github.com/sirampy/Team22/commits/v2-full)
Deciding that it may be a good idea to pipeline my working CPU, I started work with beth on a pipelined version of V2. At this time, Matteusz was making great progress on his V3 cpu, and decdied to start pipelining it, so it was decided that we aught to use his pipelined branch instead. 

## [more debugging]
Next, I helped matteusz debug V3 by using my test program and tracing back with gtkwave to find the source of errors. I found [several instructions that were implemented incorrectly](https://github.com/sirampy/Team22/commit/dca8e37341164e2bc947b2be00f10a04f59c5d2d) which I wrote a fix for, and found some deep routed pipeline bugs that Which i notified Matheusz of so he could fix them. 
## [One last attempt at caching](https://github.com/sirampy/Team22/tree/V3-PIPELINED%2BCACHED)
knowing that pipelining was in good hands, I decided to take a look at porting the work the caching team had done over to the promising V3 CPU. I found, however that the 2-way set associative cache didnt appear to talk to anny reall memeory, and worst of all, the interface for the memory had changed to properly implement the diferent typeds of load and store instructions. I decided to have a go at tackling this myself (with little time to spare before the deadline). The above branch shows the my work so far. I urge you to look at the [main memory](https://github.com/sirampy/Team22/blob/V3-PIPELINED%2BCACHED/rtl/main_mem.sv) to see the basic outlines I created. currently this branch does compile, but is both incomplete and untested.

## conclusion
I think I learned a lot from this project, especially with regards to working on a comple codebase in a large group. I have remarked jokingly to my group-mates in the past that a main takeway from the project for me was how to make effective of split screen in VS-code, but in truth I learned so much more than that. I learned some of the intricacies of make's pattern matching, how to use git, and manny lessons regarding project managment and avoiding a fragmented codebase. I belive I would communicate beter with my team aout the work I was doing if I were to do this project again, to try to avoid repeated work.