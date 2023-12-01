# Team 22 - RISC-V RV32I Processor
## Joint Statement

as a team, we encounted some troubles when it came to creating the top file and putting the whole CPU together; as we had not previously discussed naming conventions. However, with a short discussion and a few simple changes these problems were easily overcome.


> instruction set reference: https://www.cs.sfu.ca/~ashriram/Courses/CS295/assets/notebooks/RISCV/RISCV_CARD.pdf <br>
> system verilog style guide: https://www.systemverilog.io/verification/styleguide/#variables

### Group Details
---
| Name           | CID      | GitHub   | Email                     | Personal Statement|
|----------------|----------|----------|---------------------------|--------------|
| Alex Charlton |  | **sirampy**  |       | 
| Beth Cham    |  | **bethcham** |    | 
| Dell Saxena |  | **Dell-S** |  | 
| Mateusz Pietrzkiewicz |  | **MateuszP137**  |  |
| Sophie Jayson |  | **Slayque3n**  |  |

### Work Split
---
Main Sections
1. Testing (Testbenches for all individual components, only the main top-level module, coming up with machine code, testing for all instructions)
2. ALU (mostly done) + Data mem (mostly done) + Implementing and testing F1 Vbuddy lights, test Lab4 code given by peter
3. Control unit (Implement all types of instructions - Load, Store, Jump, Branch etc) + PC
4. Pipelining
5. Cache

Note: Testbenches written by Person 1, but all other members utilize and change testbenches as needed when testing their own portion

#### CPU tasks allocations (main responsibilities):
Alex:
* ALU
* Data Mem
* Implement F1 Lights algorithm

Beth:
* Pipelining

Dell:
* Testbench and verification of design

Mateusv:
* Cache

Sophie:
* Control Unit
* PC

currently incomplete list of modules:
---
| File Name     | Alex  | Beth | Dell | Mateusv |  Sophie  |
|:-----------|:-----------:|:----------:|:-----------:|:-----------:|:-----------:|
| alu.sv | | | | | 
| alu.sv | | | | | 
| control.sv | | | | | 
| ram_i.sv | | | | | 
| ram_o.sv | | | | | 
| ram.sv | | | | | 
| rom.sv | | | | | 
| register_file.sv | | | | | 
| memory.sv | | | | | 
| extend.sv | | | | | 
| fetch_reg_file.sv | | | | | 
| decode_reg_file.sv | | | | | 
| execute_reg_file.sv | | | | | 
| mem_reg_file.sv | | | | | 
| top.sv (singlecycle) | | | | | 
| top.sv (pipeline) | | | | | 
| cpu_tb.cpp | | | | | 
| F1Assembly.s | | | | | 

LEGEND :       `x` = full responsibility;  `p` = partial contribution; 