# Mateusz Pietrzkiewicz - Personal contribution

## lab4-complete

My responsibility for this was to complete the stretch goal - the `LW` instruction.

However, after we failed to make a working `Lab 4` implementation in time, I split off from our team who were starting `Lab 5` to spend a week taking everyone's files and altering them into a working solution. I also tried to touch up the formatting and make the code slightly more readable.

I passed feedback back to the team and put my changes on a separate branch to help the team with debugging their code in `Lab 5`, which was an extension to what we had in `Lab 4`.

Once that was done, I implemented the main memory and added support for the `LW` instruction, finishing `Lab 4` completely.

## single-cycle

After completing `Lab4` I was misinformed as to which branch we were working on, so I helped debug and fix may problems in an abandoned branch. I also tidied up and majorly reformatted multiple files to be more readable and presentable for a submission.

## SINGLE-CYCLE

I was responsible for incorporating my fixes from `Lab 4` into our `Lab 5` code and for making a cache. As a consequence of my first of these responsibilities, I also ended up responsible for testing.

I began work on my top-level testing testbench which I use in my following contributions, and used it to test all the implemented instructions at the time (R-type, I-type, LW, SW and implemented tests for J-type).

In order to get those instructions working (not including J-type), I had to fix over 100 compile errors and several logical errors. However, by the end we had a working set of instructions.

I also spent a lot of time tidying up the formatting of our code. My goal was to improve the consistency of variable names across sheets, add comments for inputs and outputs (as many variable names were causing confusion) and spacing out very compact and difficult-to-read code which we knew we had to expand, without altering the code itself (as to not interfere with teammates).

Sadly, due to later pressure to implement all instructions, I did not manage to finish a functional cache, so I did not attach it to the CPU.

## SINGLE-CYCLE-REDO

I found that our SINGLE-CYCLE implementation was unnecessarily convoluted and adding new instructions was becoming difficult, as we were adding needless flags as opposed to using existing inputs and outputs. So I re-analyzed a lot of the design and the instruction set to create a new, simpler design. I removed multiple modules (`alu_decoder`, `alu_top`, `control_top`, `sign_extend`) and incorporated their functionality in ways which involved less wires and unnecessary connections.

The `README.md` in the branch discusses the major changes involved.

I also finished the previously mentioned testing testbench, which I used to verify that all waveforms were as expected for every instruction.

The goal with this branch was to have a fully functional baseline, as we were having difficulties implementing some instructions in our previous branch, and especially with pipelining it. This also gave an expected and consistent set of outputs to compare against a pipelined CPU.

## SINGLE-CYCLE-REDO-PIPELINED

Since we were struggling to make a working pipelined CPU, I tried to refactor my teammates' code and use my understanding of theory to make a pipelines implementation of `SINGLE-CYCLE-REDO`.

An explanation as to how it works is in the corresponding `README.md`.

I had help from teammates with finding edge-case errors, and it appears all instructions execute correctly.
