Similarly to the branch pipelining, this one is kept for commit purposes and was the basis for the code of the fully working and debugged pipeline-2.0.

### Data Hazards
In order to deal with data hazards, the simplest way would be to add NOP instructions, which was done in the branch 'pipelining'. 

However, this not only wastes cycles but has to be written into the program directly. Thus, a better way to deal with it would be through forwarding data from earlier stages.

This required us to create a new branch 'pipelining-hazard' where we added a hazard unit that looks for data hazards. The hazard unit detects these data dependencies when the source register of the execute stage matches the destination register of the memory or writeback stage, sending signals to forwarding multiplexers to select the data from the respective stage.

However, an error occurs for the lw intruction as the correct value will not be produced until cycle 5. Thus, the execution of instructions using that value need to be stalled. To do this, stall signals were added to indicate when the existing values of the pipeline registers should be kept for that cycle. Flush signals were also introduced to create a bubble and clear the execute registers,

### Control Hazards
After that, we had to resolve control hazards, which occur when the next instruction may be fetched wrongly as the branch decision have not yet been made. This is dealt with by predicting that branches are not taken until pc_src in the execute stage determines which branch is taken. If the prediction is wrong, the predictions will be flushed.
