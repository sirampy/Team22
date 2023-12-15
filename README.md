# Team 22 - RISC-V RV32I Processor
---
## Table of Contents
1. [Group Details](https://github.com/sirampy/Team22/tree/main?tab=readme-ov-file#group-details)
2. [Division of Tasks](https://github.com/sirampy/Team22/tree/main?tab=readme-ov-file#division-of-tasks)
3. [Repository Structure](https://github.com/sirampy/Team22/tree/main?tab=readme-ov-file#respository-structure)
4. [Testing instructions](https://github.com/sirampy/Team22/tree/main?tab=readme-ov-file#testing-instructions)
5. [Evidence](https://github.com/sirampy/Team22/tree/main?tab=readme-ov-file#evidence)

## Group Details
| Name           | CID      | GitHub   | Email                     | Personal Statement|
|----------------|----------|----------|---------------------------|--------------|
| Alex Charlton | 02226326 | **sirampy**  |    ac5522@ic.ac.uk   | [Alex's Statement](https://github.com/sirampy/Team22/blob/main/statements/Alex%20Charlton.md) |
| Beth Cham    | 02193797 | **bethcham** | beth.cham22@imperial.ac.uk | [Beth's Statement](https://github.com/sirampy/Team22/blob/main/statements/Beth%20Cham.md) |
| Dell Saxena | 02258324 | **Dell-S** | dell.saxena22@imperial.ac.uk |  [Dell's Statement](https://github.com/sirampy/Team22/blob/main/statements/Dell%20Saxena.md) |
| Mateusz Pietrzkiewicz | 02257454 | **MateuszP137**  | mp1622@ic.ac.uk | [Mateusv's Statement](https://github.com/sirampy/Team22/blob/main/statements/Mateusz%20Pietrzkiewicz.md) |
| Sophie Jayson |  | **Slayque3n**  |  | [Sophie's Statement](https://github.com/sirampy/Team22/blob/main/statements/Sophie%20Jayson.md) |

## Division of Tasks
### Work split by component
LEGEND :       `x` = full/main responsibility;  `p` = small/partial contribution; 
#### Single Cycle:
| Task | File Names    | Alex  | Beth | Dell | Mateusv |  Sophie  |
|:-----------|:-----------:|:----------:|:-----------:|:-----------:|:-----------:|:-----------:|
| ALU | alu.sv, alu_top.sv, reg_file.sv | p | | p | | |
| Control Unit | control_top.sv, main_decoder.sv, alu_decoder.sv, sign_extend.sv, | p | p | x | x |
| PC | pc_mux.sv, pc_reg.sv|  | | p | | x |
| Memory | instr_mem.sv, data_memory.sv | p | p | x | x | |
| Top | top.sv | | | | x | |
| Testbenches and debugging | top_tb.cpp | p | p | x | x | |
| Formatting | - | p | | | x | | 
| Setup | .gitignore, Makefile | x | | | p | |
| F1 Testing | f1_tb.cpp, f1.s |  | | p |  | x | 
| Other testing | alutest.s, counter.s, pdf.s, sine.s | x | p | p | | x |

#### Pipelining:
| Task | File Names    | Alex  | Beth | Dell | Mateusv |  Sophie  |
|:-----------|:-----------:|:----------:|:-----------:|:-----------:|:-----------:|:-----------:|
| Pipeline registers | pipe_reg1.sv, pipe_reg2.sv, pipe_reg3.sv, pipe_reg4.sv | | x | | | x |
| Hazard unit | hazard_unit.sv | | x | | | x |
| Top | top.sv (single-cycle pipeline), top.sv (full pipeline) | | x | | | x |
| Testbenches | cpu_tb.cpp | | | x | | x |
| Debugging | - | p | p | | | x |
| F1 Testing | f1.s, f1_tb.cpp | | | | | x |
| Other testing | alutest.s, counter.s, pdf.s, sine.s | p | | | | |

#### Cache:
| Task | File Names    | Alex  | Beth | Dell | Mateusv |  Sophie  |
|:-----------|:-----------:|:----------:|:-----------:|:-----------:|:-----------:|:-----------:|
| Direct cache | data_memory_cache.sv | | x | x | | |
| Two-way cache | two_way.sv | | | x | | 
| Testbenches and debugging | top_tb.cpp, direct_cache_tb.cpp | | x | x | | | 



#### Version-2 (Revised Microarchitecture):
| Task | File Names    | Alex  | Beth | Dell | Mateusv |  Sophie  |
|:-----------|:-----------:|:----------:|:-----------:|:-----------:|:-----------:|:-----------:|
| ALU | alu.sv, alu_top.sv, reg_file.sv | x | | | | 
| Control Unit | control_top.sv, main_decoder.sv, alu_decoder.sv, sign_extend.sv, | x | | | 
| PC | pc_mux.sv, pc_reg.sv| x | | | 
| Memory | instr_mem.sv, program_mem.sv | x | | | | p |
| Top | top.sv | x | | |
| Testbenches and debugging | x | | | | 
| Other testing | counter, sine, pdf | x | | |
| V2 Pipeline | all | p | | |

#### Lab 4:
| Task | File Names    | Alex  | Beth | Dell | Mateusv |  Sophie  |
|:-----------|:-----------:|:----------:|:-----------:|:-----------:|:-----------:|:-----------:|
| ALU | alu.sv, alu_top.sv, reg_file.sv | | x | | x | | 
| Control Unit | control_top.sv, main_decoder.sv, alu_decoder.sv, sign_extend.sv, | x | x | | x | |
| PC | pc_mux.sv, pc_reg.sv | | | | | x |
| Memory | instr_mem.sv, program.mem | x | | | x | |
| Top | top.sv | | | | x | |
| Testbenches and debugging | alu_top_tb.cpp, alu_decoder_tb.cpp, control_top_tb.cpp, sign_extend_tb.cpp | | | x | x | | 
| Run files | |  | | | p | |
| Formatting | | x | | | x | |

#### Single cycle redo (revised design):
| Task | File Names    | Alex  | Beth | Dell | Mateusv |  Sophie  |
|:-----------|:-----------:|:----------:|:-----------:|:-----------:|:-----------:|:-----------:|
| ALU | alu.sv, regs.sv | | | | x | |
| Control Unit | decoder.sv | | | | x | |
| PC | pc.sv | | | | x | p |
| Memory | instr_mem.sv, main_mem.sv | | | | x | |
| Top | top.sv | | | | x | |
| Testbenches and debugging | top_tb.cpp | | | | x | |

#### Single cycle redo pipelind (revised design):
| Task | File Names    | Alex  | Beth | Dell | Mateusv |  Sophie  |
|:-----------|:-----------:|:----------:|:-----------:|:-----------:|:-----------:|:-----------:|
| ALU | alu.sv, regs.sv | | | | x | |
| Control Unit | decoder.sv | | | | x | |
| PC | pc.sv | | | | x | p |
| Memory | instr_mem.sv, main_mem.sv | | | | x | |
| Top | top.sv | | | | x | |
| Fetch | pl0_fetch.sv | | | | x | |
| Decode | pl1_decode.sv | | | | x | |
| Execute | pl2_exec.sv | | | | x | |
| Memory | pl3_mem.sv | p | | | x | |
| Write back | pl4_write.sv | | | | x | |
| Testbenches and debugging | top_tb.cpp | p | | | x | |

&nbsp; 
## Repository Structure
For each new feature we added, a new branch was created. The final repo includes the following branches:

| Branch name and link | Summary | 
| -----------------|-------------|
|1. **[`lab4_done`](https://github.com/sirampy/Team22/tree/lab4_done#)**|The original structure of Lab 4 was moved to a separate branch to preserve it, as we realised that many changes would have to be made for the full RISC-V CPU.|
|2. **[`SINGLE-CYCLE`](https://github.com/sirampy/Team22/tree/SINGLE-CYCLE#)**|Original implemented lab 4 based RISC-V RV32I Processor. |
|3. **[`pipelining`](https://github.com/sirampy/Team22/tree/pipelining#)**|Original Pipelined CPU <u>without</u> hazard handling. |
|4. **[`pipelining-hazards`](https://github.com/sirampy/Team22/tree/pipelining-hazards#)**|Original Pipelined CPU <u>with</u> hazard handling, including forwarding and stalls.|
|5. **[`cache`](https://github.com/sirampy/Team22/tree/cache#)**|This branch contains both direct mapped cache and 2-way associative cache, with implementation of direct mapped cache in the original pipelined CPU.  |
|6. **[`version-2`](https://github.com/sirampy/Team22/tree/version-2#)**|While creating the single cycle CPU, we realised the microarchitecture could be further improved on with a few changes. Thus, version-2 was created as a way to explore what in the CPU could be upgraded to become more efficient beyond what we were taught. This CPU is stable and tested to run the pdf program|
|7. **[`v2-full`](https://github.com/sirampy/Team22/tree/v2-full#)**|Version-2 with pipelining and cache incorporated. work on this branch was stopped before completion to focus on other pipelining branches|
|8. **[`pipeline-2.0`](https://github.com/sirampy/Team22/tree/pipeline-2.0#)**| the working single - cycle cpu with pipelining and hazard detection.|
|8. **[`SINGLE-CYCLE-REDO`](https://github.com/sirampy/Team22/tree/SINGLE-CYCLE-REDO#)**|a full implementation of the instruction set provided in lecture 6, with a revised minimalist design|
|8. **[`SINGLE_CYCLE-REDO-PIPELINED`](https://github.com/sirampy/Team22/tree/SINGLE-CYCLE-REDO-PIPELINED#)**|a 5-stage pipelined version of SINGLE-CYCLE-REDO, using fast-forwards to prevent data hazards and only occassional single-cycle stalls|
&nbsp; 
> A more in-depth explanation of each of the branches can be found in their individual READMEs linked above. 

The main branch is purely used for README and statement purposes.

&nbsp; 
## Testing Instructions


## Evidence

## References
> instruction set reference: https://www.cs.sfu.ca/~ashriram/Courses/CS295/assets/notebooks/RISCV/RISCV_CARD.pdf <br>
> system verilog style guide: https://www.systemverilog.io/verification/styleguide/#variables
