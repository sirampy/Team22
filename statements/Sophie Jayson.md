# Sophie Statement

##  Lab 4
For lab 4 I built the pc and its appropriate files, and helped with the debugging, formatting testing of each of the files.

## single - cycle
For the single-cycle CPU I built the pc and its appropriate files, the control unit, and worked on some of the extra instructions in the ALU, however, most of this work was lost during merging and committing branches, and was later replaced with the finished lab 4 model. Only a few of the extra instructions ( the shifts and set less/more than) remained in the final copy.
## pipelining
Originally I was tasked only with debugging the original pipeline, however when I started I discovered it was so erroneous that I instead had to start again from scratch. To do this I had to create the pipelining registers, the hazard perception unit and altering almost all the top files in order to create a system that would allow for smooth pipelining, fast-forwarding, flushing and stalling.  This started with planning an over-all architecture for how the final pipelining was going to come together (seen in the read me for the pipeline), creating 4 different pipe-line registers for the different stages of the FDE cycle,  then working out the possible hazards that could occur, figuring out what respective inputs can be used to calculate the hazards and the necessary solutions to overcome said hazards, and finally, editing the top file to "plug in" the new components.

## testing
I worked on many of the testing files, such as creating tests for ALU to check each individual instruction worked, creating the F1 lights test, created tests to check the branch instructions worked correctly an, creating pipelining tests to check for the different hazard tests, and debugged accordingly.
