### Pipelining
Note: This branch was branched off from SINGLE-CYCLE for pipelining. The updated pipeline-2.0 uses logic and code from this branch and was created in order to debug issues. Thus, this branch is currently not fully working but is kept in order for us to be able to trace back past commits and the original code. 

#### Single-Cycle
In order to add pipelining to the single-cycle CPU, 4 pipeline registers were added in between the 5 different stages of the CPU. 

In order to do this, pc_mux, alu_top, and control_top had to be removed and combined into the top level module. This allowed signals such as pc_plus4 to be forwarded from stage to stage.

This required us to create new signals that had the same purpose but for different stages. In order to differentiate between them, those that had to be in mulitple stages were appended with the letter of the stage (ie F, D, E, M and W for fetch, decode, execute, memory, and writeback respectively). 

One change that had to be made was the writeback to register file had to be triggered on the negative edge rather than the postive edge. This allows the data to be written back in the first half of the cycle and be read back in the second half so that it can be used in the next instruction immediately.
