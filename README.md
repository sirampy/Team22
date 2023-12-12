# Team 22 - RISC-V RV32I Processor

## Group Details
---
| Name           | CID      | GitHub   | Email                     | Personal Statement|
|----------------|----------|----------|---------------------------|--------------|
| Alex Charlton |  | **sirampy**  |       | [Alex's Statement](https://github.com/sirampy/Team22/blob/main/statements/Alex%20Charlton.md) |
| Beth Cham    | 02193797 | **bethcham** | beth.cham22@imperial.ac.uk | [Beth's Statement](https://github.com/sirampy/Team22/blob/main/statements/Beth%20Cham.md) |
| Dell Saxena | 02258324 | **Dell-S** | dell.saxena22@imperial.ac.uk |  [Dell's Statement](https://github.com/sirampy/Team22/blob/main/statements/Dell%20Saxena.md) |
| Mateusz Pietrzkiewicz |  | **MateuszP137**  |  | [Mateusv's Statement](https://github.com/sirampy/Team22/blob/main/statements/Mateusz%20Pietrzkiewicz.md) |
| Sophie Jayson |  | **Slayque3n**  |  | [Sophie's Statement](https://github.com/sirampy/Team22/blob/main/statements/Sophie%20Jayson.md) |

## Division of Tasks
---
Main Sections
1. Testing (Testbenches for all individual components, only the main top-level module, coming up with machine code, testing for all instructions)
2. ALU (mostly done) + Data mem (actually still needs to be done my bad - create data mem module, add read_data mux, link it to alu+register file) + Implementing and testing F1 Vbuddy lights, test Lab4 code given by peter
3. Control unit (Implement all types of instructions - Load, Store, Jump, Branch etc) + PC
4. Pipelining
5. Cache

## What is observed

### CPU tasks allocations (main responsibilities):
**Alex:** Cache 

**Beth:** Pipelining

**Dell:** Testbench and verification of design

**Mateusv:** ALU, Data Mem, Implement F1 Lights algorithm

**Sophie:** Control Unit, PC

### Component split (currently incomplete list of modules):
---
| File Name     | Alex  | Beth | Dell | Mateusv |  Sophie  |
|:-----------|:-----------:|:----------:|:-----------:|:-----------:|:-----------:|
| alu_top.sv | | | | | 
| alu.sv | | | | | 
| reg_file.sv | | | | | 
| control_top.sv | | | | | 
| main_decoder.sv | | | | |
| alu_decoder.sv | | | | | 
| instr_mem.sv | | | | | 
| program_mem.sv | | | | | 
| sign_extend.sv | | | | | 
| pc_top.sv | | | | |
| pc_reg.sv | | | | |
| top.sv (singlecycle) | | | | | 
| top.sv (pipeline) | | | | | 
| cpu_tb.cpp | | | | | 
| F1Assembly.s | | | | | 

LEGEND :       `x` = full/main responsibility;  `p` = partial contribution; 

&nbsp;   
# Joint Statement 


## Repository Structure

## Summary of Approach

### Pipelining
#### Single-Cycle
In order to add pipelining to the single-cycle CPU, 4 pipeline registers were added in between the 5 different stages of the CPU. 

In order to do this, pc_mux, alu_top, and control_top had to be removed and combined into the top level module. This allowed signals such as pc_plus4 to be forwarded from stage to stage.

This required us to create new signals that had the same purpose but for different stages. In order to differentiate between them, those that had to be in mulitple stages were appended with the letter of the stage (ie F, D, E, M and W for fetch, decode, execute, memory, and writeback respectively). 

One change that had to be made was the writeback to register file had to be triggered on the negative edge rather than the postive edge. This allows the data to be written back in the first half of the cycle and be read back in the second half so that it can be used in the next instruction immediately.


#### Data Hazards
In order to deal with data hazards, the simplest way would be to add NOP instructions, which was done in the branch 'pipelining'. 

However, this not only wastes cycles but has to be written into the program directly. Thus, a better way to deal with it would be through forwarding data from earlier stages.

This required us to create a new branch 'pipelining-hazard' where we added a hazard unit that looks for data hazards. The hazard unit detects these data dependencies when the source register of the execute stage matches the destination register of the memory or writeback stage, sending signals to forwarding multiplexers to select the data from the respective stage.

However, an error occurs for the lw intruction as the correct value will not be produced until cycle 5. Thus, the execution of instructions using that value need to be stalled. To do this, stall signals were added to indicate when the existing values of the pipeline registers should be kept for that cycle. Flush signals were also introduced to create a bubble and clear the execute registers,

#### Control Hazards
After that, we had to resolve control hazards, which occur when the next instruction may be fetched wrongly as the branch decision have not yet been made. This is dealt with by predicting that branches are not taken until pc_src in the execute stage determines which branch is taken. If the prediction is wrong, the predictions will be flushed.

## Testing Instructions

as a team, we encounted some troubles when it came to creating the top file and putting the whole CPU together; as we had not previously discussed naming conventions. However, with a short discussion and a few simple changes these problems were easily overcome.


> instruction set reference: https://www.cs.sfu.ca/~ashriram/Courses/CS295/assets/notebooks/RISCV/RISCV_CARD.pdf <br>
> system verilog style guide: https://www.systemverilog.io/verification/styleguide/#variables
As expected, we have the sine wave read from memory. Since the sinerom is stored as bytes but we are reading words, and since we are using little endian, after every read we have the a0[7:0] be the current sine value, and the 24 remaining bits have extra readings (a potential optimisation to remove memory reads would be to read word, then logical shift right 3 times, meaning we only do 0.25x the reads). The code also never reads memory location 255, jumping back to main loop after reading 254 (which is a logical error in the provided code, not a hardware fault). When we are at the final memory locations we can see the undefined memory (in our case just 0's) fill the most significant bits of a0 (8 bits for 253, 16 bits for 254).
