# PIPELINING 2.0
When beginning testing and debugging of the original pipeline-hazards branch, we noticed lots of errors, mostly within the top level file and the use of an old, uncompleted control unit, but also from  within the logic of the hazard unit. And so, in order to get pipelining working for the original SINGLE-CYCLE branch, we, as a team, decided it would be best to start again; which created this branch.

This branch aims to create and run the architecture seen below:

![cpu](Documents/Team22/images/cpu.png)

## Hazard unit logic
### forwarding 

One hazard that could evolve is data depndancies to combat this the results and other data would have to be fast forwarded. If the the registers in the execute stage match the Rd in the memmory stage, then the mem stage needs to be fast forwarded. Otherwise if the the registers in the execute stage match the Rd in the store stage, then the store stage needs to be fast forwarded. Finally, if 
anything else is happening the cycle just continues on normally.


### stalling 
An error will occur typically when a lw instruction takes place, as the correct value will not be fully passed through the system for 5 clock cycles. Therefore the system has to be paused (stalled) to allow the instruction to pass through the pipelining registers, and the execute registers will be flushed in order to create a bubble for it.
 
### flushing
if the system has predicted the wrong next instruction (aka a jump or branch instruction has occured) then the system needs to be flushed to remove the wrong data loaded into the pipeline