# RISC-V RV32I Processor Coursework
## Personal Statement of Contributions

_**Beth Cham**_

### Overview
1. ALU - alu.sv, alu_top.sv, reg_file.sv
2. Control Unit - control_top.sv, main_decoder.sv, alu_decoder.sv
	a. implemented LB, LBU, SB
3. Pipelining (single-cycle) - pipe_reg1.sv, pipe_reg2.sv, pipe_reg3.sv, pipe_reg4.sv
4. Pipelining (with hazard handling) - hazard_unit.sv
5. Direct mapped cache
6. Testing - sine wave

Note: Unfortunately, there was an issue with the commits at the start where my changes were recorded under "root" rather than my username. Thus, a few of the links here to my commits may be seen as attributed to "root". 
### 1. ALU (Lab 4)
---
Link to relevant commits:
- [Implemented basic alu operations](https://github.com/sirampy/Team22/commit/de17671e4410a8ed0039ed3dee58fcdfadefcbc7)
- [Zero flag](https://github.com/sirampy/Team22/commit/f8311fed772947ec3ae294630155ddc5b650c4ba)
- [Register File](https://github.com/sirampy/Team22/commit/30f3e1a41d11a9b913f1dbb27c426cb727811f41)
- [Setting zero register](https://github.com/sirampy/Team22/commit/b5bc1f1b5077cbc847e0bb8f5105a8b3793779de#diff-6d3fa4d1b4459f5f641f10ac86cc1d81cb593c08f1e0d5e8bc1d9f1fca8de405)

In Lab 4, I created a basic alu.sv, where I implemented the following instructions: 

| aluCtrl | name | operation|
|----|----|---|
|3'b000| ADD| aluOp1 + aluOp2
|3'b001| SUB|aluOp1 - aluOp2
|3'b010 |AND |aluOp1 & aluOp2
|3'b010| OR | aluOp1 | aluOp2

For BEQ and BNE, I also created a zero flag called `eq = (sum == 0) ? 1'b1 : 1'b0` .

I also worked on reg_file.sv, where I created reg_data to have 32 registers each of 32-bits, and ensured that the write port is synchronous while the read ports are asynchronous. Additionally, the zero register had to set so that it could not be written to.

alu_top.sv incorporated both of these and included the mulitplexer `assign alu_op2 = alu_src ? imm_op : reg_op2;`, where alu_src is 1 for imm_op and 0 for reg_op2.

### 2. Control Unit (Lab 4 + load instructions)
Link to relevant commits:
- [Decoders](https://github.com/sirampy/Team22/commit/052de84daf58c2c373ebb13dedc117dc44ea08e1)

I added the decoder for the control unit, splitting it into alu_decoder and main_decoder. 

For the main_decoder, I added in control signals that were determined based on which type of instruction it was. 

| opcode | type of instruction |
|----|----|
|7'b0000011| I-type load |
|7'b0010011| I-type arithmetic|
|7'b0100011| S-type |
|7'b1100011| B-type|

From there, the alu_decoder uses the alu_op determined by the main_decoder to set what sort of operation would be carried out. For example, for the lw instruction, the alu_op is set to 000 in order to carry out an addition. 

#### Load instructions
- [Adding mem_type and mem_sign, albeit with errors](https://github.com/sirampy/Team22/commit/7c3ef4dfb16b02be1f89a1d6c402fe72a0acbad7)
- [Fixing data_mem to run LB and LBU correctly](https://github.com/sirampy/Team22/commit/1ac1d110a20095a54c07324735d83f454ffdbbc4#diff-0366265af69cf6606f2d0cbdf13fd04b5a43dd063fab44763967fce385963221)
- [Adding SB to data_mem](https://github.com/sirampy/Team22/commit/91cb5507986511a8a59b453a2e414d32ef8fc459#diff-0366265af69cf6606f2d0cbdf13fd04b5a43dd063fab44763967fce385963221)

The load instructions had to have additional control signals implemented in order to differentiate handling of LW, LB, and LBU. 

This was done by introducing the control signals mem_type and mem_sign. 

| mem_type | mem_sign | type of instruction |
|----|----|---|
| 0 | x | LW |
| 1 | 1 | LB |
| 1 | 0 | LBU |

These signals were then used to control data_mem as seen below:
```
case (mem_type_i)
	1'b1: // byte
		case (mem_sign_i)
			1'b0: read_value_o = {24'b0, read_value[7:0]}; // zero ext
			1'b1: read_value_o = {{24{read_value[7]}}, read_value[7:0]}; // sign ext
		endcase   
	1'b0: read_value_o = read_value; // word
	default: read_value_o = read_value;
endcase 
```

For LB, the value read to the register would be the least significant byte which is then sign extended, while for LBU, the least significant byte is zero extended. Load word reads the value from memory as normal.

This could also be easily further extended to including LH and LHU instructions if there was more time.

Similarly for store, SW and SB had to be differentiated, as seen in the code below:

### Pipelining (single-cycle)
Note for pipelining: I created the original structure and logic of the pipelined CPU, which can all be found on the [pipelining] and [pipelining-hazards] branches. However, for debugging purposes, a new branch was created called [pipeline2.0] where it was reformatted. I will be linking to commits made in the original branch and thus these may have different names from the final submission.

Link to relevant commits:
- [Pipeline registers (initially named flip_flops)](https://github.com/sirampy/Team22/commit/2bd4fa2b9abef1027c52ef75517ac5257748ea73)
- [Merging alu_top with top.sv](https://github.com/sirampy/Team22/commit/d7667dde7bf317dafb9c9d5500f51df4ede99921)

Firstly, in order to pipeline the single-cycle CPU, 4 pipeline registers were added in between the 5 different stages of the CPU. This allowed signals to read at each individual stage simultaneously. 
- pipe_reg1: fetch to decode
- pipe_reg2: decode to execute
- pipe_reg3: execute to memory
- pipe_reg4: memory to writeback

For example, pipe_reg1 pipelines the signals below:
```
instrD_o    <= rd_i;
pcD_o       <= pcF_i;
pc_plus4D_o <= pc_plus4F_i;
```

These are signals used in both the fetch and decode stage. As seen above, this required me to create new signals that had the same purpose but for different stages. In order to differentiate between them, each signal was appended with the letter of the stage (ie F, D, E, M and W for fetch, decode, execute, memory, and writeback respectively).

As I implemented the pipelining, I realised that some of the intermediate tops, such as: `pc_mux, alu_top, and control_top,` had to be removed and combined directly into the top level module. This allowed signals such as pc_plus4 to be accessed in all stages simultaneously.

Additionally, another change that had to be made was the writeback to register file being set to trigger on the negative edge rather than the positive edge. This allows the data to be written back in the first half of the cycle and be read back in the second half so that it can be used in the next instruction immediately.

### Pipelining (with hazard handling)
Links to relevant commits:
- [Hazard unit](https://github.com/sirampy/Team22/commit/45986c25317efc5619122a0ba7d12cf42bd3c3b4)
- [Forwarding multiplexers](https://github.com/sirampy/Team22/commit/9c26987fe579a70303832c024128e71e1e668b4d)
- [top.sv with pipelining registers](https://github.com/sirampy/Team22/commit/c7a06c0e2a5e16c75de9ce28251d4ced2018848d#diff-945c3ec93ea6ef0f51080f36affd2d30b7da4c55c397d49f113d3dff29902273)

In other to deal with data hazards, I implemented a hazard unit which looks for data hazards and forwards data from earlier stages when a data dependency is detected.

The hazard unit detects these data dependencies when the source register of the execute stage matches the destination register of the memory or writeback stage, sending signals to forwarding multiplexers to select the data from the respective stage.

For example, the logic for rs1 is as below:

```
// if destination register (m) = register (e) --> forward from mem
if (((rs1E_i == rdM_i) & reg_writeM_i) & (rs1E_i != 0)) forward_aE_o = 2'b10;

// same for w
else if (((rs1E_i == rdW_i) & reg_writeW_i) & (rs1E_i != 0)) forward_aE_o = 2'b01;
else forward_aE_o = 2'b00; // do not forward
```

The signal forward_aE_o uses the following logic to determine which data to forward:

| forward_aE_o| data to forward |
|---|---|
|00|rd1E|
|01|resultW|
|10|alu_resultM|

However, an error occurs for the lw intruction as the correct value will not be produced until cycle 5. Thus, the execution of instructions using that value need to be stalled. To do this, I added stall signals to indicate when the existing values of the pipeline registers should be kept for that cycle. Flush signals were also introduced to create a bubble and clear the execute registers.

After that, we had to resolve control hazards, which occur when the next instruction may be fetched wrongly as the branch decision have not yet been made. This is dealt with by predicting that branches are not taken until pc_src in the execute stage determines which branch is taken. If the prediction is wrong, the predictions will be flushed.

```
lw_stall = result_srcE_i & ((rs1D_i == rdE_i) | (rs2D_i == rdE_i));
stallF_o = lw_stall;
stallD_o = lw_stall;
flushD_o = pc_srcE_i;
flushE_o = lw_stall | pc_srcE_i;
```


### Direct mapped cache
Links to relevant commits
- [Debugging cache](https://github.com/sirampy/Team22/commit/c979fefc9dbf8535e6ffdc01da553bef166199c4)
- [Completing and testing cache](https://github.com/sirampy/Team22/commit/c10e8c9b898b3136efd9751006228e92113ec368#diff-68b2116bb310c237dbb209fe6c21c5270101ecf7dcf5922cb12299d103c0870c)
- [Merging cache signals into pipelining](https://github.com/sirampy/Team22/commit/871f6554ec6fc9ce8c57de170aa65c9965063da4)

I worked with Dell to complete and debug the direct mapped cache. The direct mapped cache has the following components:

Firstly, the cache consists of 8 cache sets, each made out of the actual content stored, a valid bit, and the most-significant 27 bits of the address of the memory called a tag.
```
logic v [CACHE_LENGTH-1:0];
logic [TAG_WIDTH-1:0] tag [CACHE_LENGTH-1:0];
logic [DATA_WIDTH-1:0] data [CACHE_LENGTH-1:0];
```

When there is a cache hit, as seen below, the data output will be from what is stored in cache
```
assign hit_o = (tag[current_set] == current_tag) && v[current_set];
always_latch begin
        if(hit_o) data_out_o = data[current_set];
    end
```

However, if it doesn't match, the cache entry for the current set will be updated. 
```
if(current_tag != tag[current_set]) begin
	tag [current_set] <= current_tag;
	data [current_set] <= data_in_i;
	v [current_set] <= 1'b1;
end
```

### Testing - Simple instructions and sine wave
Links to relevant commits:
- [Tested sine wave](https://github.com/sirampy/Team22/commit/1ac1d110a20095a54c07324735d83f454ffdbbc4#diff-8ad7920fa4da363e71856f37fd7cc370cae2779fa8e9ba6d76e93e32ba0ac127)
- [General testing](https://github.com/sirampy/Team22/commit/51326594390bbfa0efc0c8694f2d5d706c467582)

Once everything was completed in single-cycle, I tested different instructions to ensure they were working. Additionally, I tested the sine wave programme and used it to help with debugging.
