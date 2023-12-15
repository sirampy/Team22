### Pipelining
Note: This branch was branched off from SINGLE-CYCLE for pipelining. The updated pipeline-2.0 uses logic and code from this branch and was created in order to debug issues. Thus, this branch is currently not fully working but is kept in order for us to be able to trace back past commits and the original code. 

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
