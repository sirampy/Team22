[diagram]: images/main_diagram.png "Main diagram"
[waves]: images/waves.png "Waveforms"

# RISC-V simple single-cycle implementation:

## What is this?

This is a single cycle implementation of a RISC-V CPU according to the instructions provided in lectures. All instructions shown in lectures have been implemented (see lecture 6 for full tables). This comes with a testbench which tests every available instruction, and produces an expected waveform, which can then be used to compare against our other branches to verify they work.

![alt text][waves]

The full test code is in `rtl/top_tb.cpp`, where the comments show every assembled instruction and explain the intended result of that instruction. These are in `rtl/test.mem`, and corresponding main memory values for testing L and S instructions are in `rtl/test2.mem`. Keep in mind, to test, **you need to use the big endian instruction memory code, see **`rtl/instr_mem.sv`** for more details!**

**To run: make sure your terminal is in the **`Team22`** directory, then type:**
`./run.sh rtl top`
**You will be prompted to press enter twice, and, after doing so, you should see the waveform.**

## Alterations to design provided in lectures

This design was made to be as simple and minimal as possible, and this is the final design:

![alt text][main_diagram]

The goal was to remove redundant wires, decoders and modules from the design provided in lectures.

### ALU Decoder

An easy place to start was the ALU decoder (IMAGE???):

The main purpose of the ALU decoder was to translate `funct7` and `funct3` into an `ALUControl` signal, however they were both the same, just assigning different 4-bit values to ALU operations. Therefore, we can remove it completely, and just pass the instruction bits into the ALU.

### Decoder Outputs

The outputs of the main (and now only) decoder have been updated to reflect the new design, and these changes are discussed below. In the end, we decided that all we need is:

- A program counter write source select;
- A register write source select, and write enable;
- An ALU operand select (as discussed later, there is a select for operand 1 and operand 2);
- Memory write enable;
- Immediate value;

#### Program Counter Write

As we were adding more instructions, we realised that we need a multiplexer into the program counter. As in the previous design, it can increment by 4 (a single instruction) and an immediate value (for branching and JAL).

However, `JALR` does not work elegantly with this, as it requires adding an immediate value to a register. We noticed its similar format to `ADDI` (`funct3 = 000`) and that the ALU output would be the desired program counter value. To prevent adding redundant addition hardware, we therefore added the ALU output as another program counter write source, and use it for `JALR` (this is discussed more below).

#### Register Write Select

When writing the value to a register, our previous design already had the potential sources of the ALU output and memory read.

However, we needed to add 2 more:

- Immediate value: `LUI` requires us to write the immediate value to a register without performing any arithmetic. Another considered option to implement this was to add the immediate value to the zero register and storing the ALU output. However, `funct3` could be any value (as it is in the immediate) and this would be the only instruction requiring the ALU operator to not be `funct3`, resulting in an inelegant solution. It is much easier to just pass the immediate value directly to the register.
- Incremented program counter:` JAL` and `JALR` write the incremented program counter to a register. While we could do something similar to what we previously mentioned with `JALR`, and use the ALU, it isn't practical as `funct3` is again an immediate value. Also, `JALR` is already using the ALU, and cannot use it to also increment the program counter. It is much easier to just pass the incremented program counter value to the register.

#### ALU Operand Selects

Operand 2 remains unchanged, with its possible inputs being the register (`rs2`) or the immediate value.

However, we modified operand 1. Instead of just accepting a register value (`rs1`), it can also accept the program counter. This is because, as mentioned previously, we want to use the ALU hardware to perform the addition for the `JALR` instruction. This lets us pass the program counter and immediate value into the ALU, and provides an elegant implementation for `JALR`.

#### Immediate Value

The immediate value depends entirely on the instruction. Therefore,  we moved it to the `decoder` module from a stand-alone `sign-extend` module.

### Branching

We noticed that the branching conditions are very similar to existing ALU instructions, and they come in 3 pairs:

- `BEQ` has the opposite condition to `BNE`, and would require `SUB`,
- `BLT` has the opposite condition to `BGE`, and would require `SLT`,
- `BLTU` has the opposite condition to `BGEU`, and would require `SLTU`

These pairs have the same `funct3[2:1]` but different `funct3[0]`. In fact, `funct3[2:1]` for these branches is the same as `funct[1:0]` for the corresponding ALU instructions.

We also noticed that if we use our previously implemented zero flag (high when ALU output is zero, low otherwise), we see the following:

- `BEQ`: if `op1 == op2` we get `Z = 1`, otherwise we get `Z = 0`,
- `BLT`/`BLTU`: if `op1 < op2` we get `Z = 0`, otherwise we get `Z = 1`

And `funct3[2] = 0` for BEQ and BNE, but `1` for the other instructions.

This gives us our final branching algorithm:

- Pass the instruction to the ALU like a normal R-type instruction with `funct3` shifted logically left by 1 bit,
- `PERFORM_BRANCH = Z ^ funct3[2] ^ funct3[0]` (given, of course, that the current instruction is a B-type instruction)
