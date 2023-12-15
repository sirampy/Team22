[diagram]: images/main_diagram.png "Main diagram"
[waves]: images/waves.png "Waveforms"

# RISC-V simple pipelined implementation:

## What is this?

This is a pipelined implementation of a RISC-V CPU according to the instructions provided in lectures. All instructions shown in lectures have been implemented (see lecture 6 for full tables). This comes with a testbench which tests every available instruction, and we can verify that it produces the desired outputs if we compare against our simple single-cycle implementation:

![alt text][waves]

**For more information about running, see the simple single-cycle implementation, as the steps are the same.**

## Alterations to single-cycle design

The priority with this design was to implement fetch, decode, execute, memory and write-back stages while minimising stalls and fully removing hazards:

![alt text][diagram]

Data hazards are removed using fast-forward paths from each of the stages, and control hazards are removed using stalls.

### Data hazards

In our CPU, this only occurs when:

- An instruction involves writing to a register,
- This instruction's output value doesn't yet reach and finish the write-back stage, hence is not written to a register,
- Another instruction uses this register's value as an operand, hence causing an out-of-date value to be read from the register.

We solved this problem with fast-forward paths from every cycle. While data is passed around synchronously between the different stages, all the outputs are asynchronously passed to the decode stage.

In practice this works as follows:

- An instruction is called which modifies register `X`.
- (Potentially other instructions are executed here),
- An instruction is executed which uses register `X` as an operand,
- We check if the execute stage* has an updated value for register `X` (which would be as recent as a value could be). If it does, we use it.
- If not, we check if the memory stage* has an updated value for register `X` (which would be the most recent possible value given the execute stage doesn't have a more recent one, which we know it doesn't). If it does, we use it.
- If not, we check the write-back stage, in the same way we did the other stages previously.
- If none of the stages have a more recent value for register `X`, we know we can safely assume the value of register `X` is the most recently set.

*(With a minor exception, see **L error** below)

With this method, we do not need to stall if we detect a data hazard, as we can always access the most recent value of the register, hence not requiring any further modifications to the design.

#### L error

Conceptually, the fast-forward must say which address they have a value for, and the updated value. However, when we call an L-type instruction, a problem arises.

If we want to load memory location `Z` into register `X`, we spend the execute stage performing addition to get `Z`, as it involves performing an equivalent operation to `ADDI`.

This means that we will have a fast-forward output from the execute stage claiming that the most recent value of register `X` is the memory address `Z`, which is obviously wrong, it should be the value read at memory address `Z`. However, we only obtain this value in the memory stage, which happens next.

This therefore means that we must stall the CPU for one cycle if:

- The previously loaded instruction loaded a value into register `X`;
- The current instruction uses register `X` as an operand;

In this instance, we do not perform the current instruction for 1 cycle, so we can wait until the load is complete.

### Control hazards

These arise when an instruction involves changing the program counter in a way which doesn't just involve the usual increment by 4. These are:

- B-type instructions,
- `JAL`,
- `JALR`

We consider each of these separately:

#### B-type

Because we are using the ALU and zero flag to determine whether or not a jump has been successful, we have to stall until at least that operation is performed, which would involve stalling for 2 cycles. We can make this only 1 cycle if we use our asynchronous fast-forward output which we created for data hazards.

#### JAL

The decoder immediately knows the desired offset for the program counter, and we do not need to write to the program counter and register file simultaneously. Therefore, we decided that the easiest solution is to make a fast-forward output from the decoder to the program counter, which means we do not need to stall. The register write can continue as usual.

#### JALR

We need to wait for the ALU to perform the equivalent of an `ADDI` instruction, to get the target value for the program counter. Therefore, this works similarly to the B-type instructions, only without the need for the zero flag, requiring only 1 stall cycle.

### Decoder changes

We had to do some minor alterations to the decoder to account for the different stages.

- The decoder no longer evaluates whether a branch has or hasn't occurred, that is now in the fetch stage. This means we need to output `funct3[0]` along with the operator to the execute stage so it can be passed back into the decode stage;
- The decoder no longer selects a register write source, as that would involve adding buffers for each of those sources, and complicates the fast-forward values. Instead, we added a flag to the execute stage which determines whether to pass on the ALU output, or an alternate value passed in from the decode stage (to which no arithmetic is performed). What would have previously been the register write source is now an ALU alternate input select;
- There is now a memory read enable. Memory is still read every time a value is input into the memory stage, the enable just toggles whether we pass out the ALU output or the just read memory value to the next stage;
- We now output a stall, which is used internally within the decode stage. This passes a null instruction into the pipeline (we write to register 0 with `write enable = 0`, and we have it hard-coded so we ignore fast-forward values for register 0);
- Similarly, we have to detect L errors, and force a stall if we detect one.
- Instead of outputting a select for what to write to the program counter, it now outputs a stall state. This can be any of:
	- Stall for 1 cycle and continue as usual (for L errors),
	- Stall for 1 cycle then do branch condition (for B-type instructions),
	- Use immediate value without stalling (for JAL),
	- Stall for 1 cycle then use ALU output (for JALR)
