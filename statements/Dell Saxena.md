## RISC-V RV32I Processor Coursework


## Personal Statement of Contributions
**Dell Saxena**

## Overview

- Testing and Debugging
	- Control Unit
	- Sign Extend
* Implementing JAL and JALR
* Sign Extend
* Memory
* Cache
	* Direct Mapped Cache
	* Two Way Set Associative Cache
* Implementing F1 Lights on Vbuddy

___
### Testing and Debugging

___
**Relevant commits:** 
* [Decoder Testing](https://github.com/sirampy/Team22/commits/lab4_done/Lab4/alu%2Bregfile/alu_top_tb.cpp)
* [Sign Extend Unit Testing](https://github.com/sirampy/Team22/commit/16bf407438f4fdf9d924bef613255babd0a9c609)
* [Control Unit Testing](https://github.com/sirampy/Team22/commit/bbc1896ccc22fdc66781b7b7deb0b83b88ea9016)
* [Debugging ALU Decoder](https://github.com/sirampy/Team22/commit/02c55557dbf31b660b00e59058354655968cb95e)

My main responsibility in Lab 4 - Reduced RISC-V Architecture was to test and debug components to verify that the design works and for my understanding of the processor as a whole. I also took on this role initially as part of the project to make sure the Lab 4 files functioned well enough for us to build upon during the coursework.
##### Control Unit

I created a testbench control_tb.cpp for the control_top.sv module to verify that the instructions implemented in the ALU Decoder and Main Decoder work as expected. I used GTKWave to analyse the signals to then confirm that the decoders were giving the right outputs as well as printing outputs onto the console. 

I began by setting the opcode, `funct3`, and `funct7` fields to represent, in this case, the `addi` instruction. The opcode `0x13` specifically identifies the instruction type.

``` c++ 
top->op = 0x13; 
top->funct3 = 000; 
top->funct7 = 0; 
```

The test runs through a simulation loop, toggling the clock signal and evaluating the CPU state at each step. This mimics the real-time operation of the CPU. The core of the test involves verifying the `addi` instruction at a specific program counter (PC) value. This is done by checking the opcode and ensuring the decoder outputs are as expected:

- `reg_write` should be enabled, indicating a write operation to the register file.
- `alu_src` should indicate an arithmetic operation.
- `alu_op` should be set to the value corresponding to arithmetic operations

```c++
if (top->op == 0x13) {
    assert(top->reg_write == 1);
    assert(top->alu_src == 0);
    assert(top->alu_op == 2);
    std::cout << "Instruction decoded correctly at PC = 10\n";
}
```

The console output confirmed whether the `addi` instruction is decoded correctly, providing immediate feedback on the test status. Adopting this testing strategy, I systematically modified the testbench to check other instructions. By altering the opcode, `funct3`, and `funct7` fields, I could simulate different instructions under various scenarios. This granular approach allowed me to pinpoint and rectify specific issues, ensuring robustness and reliability in the CPU's instruction handling

##### Sign Extend

I also tested the extension unit and my testing strategy focused on validating the sign extension logic, addressing potential issues related to bit widths and the correct usage of bit fields. I did this through the sign_ext_tb.cpp testbench where I set the `instr` register with a test value and `imm_src` to `0`. 

The expected output was calculated by extracting the relevant bits from the `instr` register, considering the sign bit for correct extension. I then compared the modules output with the expected value for which it would tell me if the test case has passed or failed.

```c++
//test case for when 2'b00, imm_src = 0;
    top->instr = 0x12345678;  // test case value
    top->imm_src = 0;

    top->eval();              

    //expected output for imm_src = 0
    int expected_imm_ext = (top->instr >> 20) & 0xFFF;
    if (expected_imm_ext & 0x800) { //check if sign bit of 12 bit value is set
        expected_imm_ext |= 0xFFFFF000; //sign extend to 32 bits
    }
    //check if expected = output
    if (top->imm_ext != (expected_imm_ext & 0xFFF)) { //comparing lower 12 bits
        std::cerr << "Test Case Failed: Expected 0x" << std::hex << (expected_imm_ext & 0xFFF) << ", got 0x" << top->imm_ext << std::endl;
    } else {
        std::cout << "Test Case Passed." << std::endl;
    }

```

---
### Implementing JAL and JALR

---
**Relevant commits:** 
* [J-type Implementation](https://github.com/sirampy/Team22/commit/b9cb80bf8685482a6666d8b78d636ef06cdee179)
* [Implementing J-type in relevant modules](https://github.com/sirampy/Team22/commit/4716c1069742e3d46032d51112a7d58ddf88149a)

As part of the RISC-V RV32I Processor coursework, I also implemented the J-type instructions. The `JAL` instruction writes `PC+4` (the address following the jump instruction) to a designated register (`rd`) and updates the Program Counter (PC) to the jump target address, which is `PC + imm`. This instruction is important for the execution of subroutines and returning control to the correct point in the program after a subroutine has completed.

To accommodate this instruction, I focused on two main aspects of the processor: the datapath and the control unit. The instruction implementation was achieved by adding the PC to a 21-bit signed immediate, extracted and sign-extended from the instruction itself. The immediate's least significant bit is always 0, and the next 20 bits are sourced from `Instr[31:12]`. The existing hardware in the datapath, which already had the capability to add the PC to a sign-extended immediate and compute `PC+4`, was leveraged for this purpose. However, I had to modify the Extend unit to ensure it could accurately sign-extend the 21-bit immediate as shown below:

```systemverilog

3'b011: imm_ext_o = { { 12 { instr31_7_i [ 31 ] } }, instr31_7_i [ 19 : 12 ], instr31_7_i [ 20 ], instr31_7_i [ 30 : 21 ], 1'b0 };
```

The control signal `PcSrc`, used for branch instructions, was also configured to be high for the `JAL` instruction, ensuring the correct selection of the next PC value.
```SystemVerilog
always_comb
    if ( jal == 1'b1 )
        pc_src_o = 1'b1;
    else
        case ( funct3_i )
            3'b000: // BEQ
                pc_src_o = ( branch && eq_i ) ? 1'b1 : 1'b0;
            3'b001: // BNE
                pc_src_o = ( branch && !(eq_i )) ? 1'b1 : 1'b0;
            default: pc_src_o = 1'b0; // By default, do not jump
        endcase

endmodule
```

The final step in fully integrating these jump instructions was to enable the CPU to write `PC+4` to the register file. This required an additional output from the `PC_Next` component, consistently providing the current PC value plus 4. To facilitate this, I created another multiplexer at the write data input of the register file.

```SystemVerilog
 Jstore_i ? pc_plus4_i : (reg_write_src_i ? mem_read_val_i : alu_out_o)
```

When `Jstore` is high, `PC+4` is written to the register file. 

Implementing these jump instructions was driven by the project brief's requirement to support code that uses subroutines. The successful integration of `JAL` and `JALR` fulfilled this requirement and significantly enhanced the processor's capability, enabling it to handle a broader range of instructions and more complex control flows.

---
### Sign Extend

---
**Relevant commits:** 
* [Fixed Sign Extend Unit logical error](https://github.com/sirampy/Team22/commit/ed659445b656e5b90565ae800f426c3c1ad1f416)

In the development of the sign extension module for the RISC-V single-cycle processor, I encountered an issue with the handling of U-type instructions, specifically `LUI` and `AUIPC`. Initially, the sign extension for these instructions was incorrectly implemented as 

`3'b100: imm_ext_o = { instr31_7_i [ 31 : 20 ], instr31_7_i [ 19 ] };`. 

This configuration erroneously included the 19th bit of the instruction in the immediate extension, leading to incorrect immediate values being generated.

Recognising this, I revised the implementation to 
`3'b100: imm_ext_o = { instr31_7_i [ 31 : 12 ], {12{1'b0}}};`. 

This is because U-type instructions like `LUI` and `AUIPC` are designed to operate with the upper 20 bits of the immediate value. The corrected implementation accurately reflects this behaviour by extracting the upper 20 bits from `instr31_7_i[31:12]` and concatenating them with 12 zero bits. This change ensured that the immediate values for `LUI` and `AUIPC` were correctly formed, allowing these instructions to function as intended.

---
### Memory

---
**Relevant commits:** 
* [Updated Data Memory](https://github.com/sirampy/Team22/commit/16b9c22277cab0c6b58faabba4707c4f79232b3b)
* [Updated Instruction Memory](https://github.com/sirampy/Team22/commit/524c3c0ec66a978b9a668199946e13fa1e4c20ee)

I had modified the instruction and data memory modules to specify the memory range as given in the project brief's memory map. As well as this the updated memory modules are structured with clearer separation of concerns (e.g., address calculation, read/write operations), making the code easier to understand and maintain.

---
### Cache

---
**Relevant commits:** 
* [Implemented Direct Mapping ](https://github.com/sirampy/Team22/commit/1aec741cd328f6118dae257b7b9b050eface6765)
##### Direct Mapped Cache 
In the ongoing development of our group's RISC-V RV32I processor, I worked with Beth on cache implementation. I integrated a direct mapped cache into the data memory module and adding signals in the relevant modules. Direct mapped cache is a straightforward and efficient caching strategy where each block of main memory maps to exactly one cache line. This one-to-one mapping simplifies the cache design and lookup process, making it a suitable choice for our processor architecture.

The module, named data_memory_cache, is parameterized with DATA_WIDTH set to 60 bits, aligning with the cache entry size that includes 32 bits of data, 27 bits of tag, and 1 bit for the valid flag. The module interface consists of a 32-bit memory address input (mem_address_i), a 32-bit data input (data_in_i), a write enable signal for the cache (write_en_cache_i), a clock input (clk_i), and a 32-bit data output (data_out_o).

  ```SystemVerilog
module data_memory_cache #(
    parameter   DATA_WIDTH = 60
)(
    input logic     [31:0]        mem_address_i,
    input logic     [31:0]        data_in_i,
    input logic                   write_en_cache_i,
    input logic                   clk_i,
    output logic    [31:0]        data_out_o
);
```

The cache is implemented as an array of 8 entries (ram_array), each 60 bits wide, corresponding to the 8 possible cache locations derived from the 3-bit index in the memory address. This structure aligns with the direct mapping approach, where each memory address maps directly to a specific cache location.

`logic [DATA_WIDTH-1:0] ram_array [7:0];`

Two main always blocks govern the cache operation: combinational (always_comb) and sequential (always_ff).

This block is responsible for checking if the data requested by the memory address is present in the cache (cache hit) or not (cache miss). The tag comparison and valid bit check are performed here. If a cache hit occurs, the data is immediately output; otherwise, the input data (data_in_i) is set as the output.

``` SystemVerilog
always_comb begin
    tag = (mem_address_i[31:5] == ram_array[mem_address_i[4:2]][58:32]);
    valid = ram_array[mem_address_i[4:2]][59];
    hit = (tag & valid);
    if(hit)
        data_out_o = ram_array[mem_address_i[4:2]][31:0];
    else
        data_out_o = data_in_i;
end

```

This block updates the cache on a cache miss when the write enable signal is active. It updates the valid bit, data, and tag of the respective cache entry.


```SystemVerilog
always_ff @(posedge clk_i) begin
    if (hit == 1'b0 & write_en_cache_i == 1'b1)
    begin
        ram_array[mem_address_i[4:2]][59] <= 1'b1;
        ram_array[mem_address_i[4:2]][31:0] <= data_in_i;
        ram_array[mem_address_i[4:2]][58:32] <= mem_address_i[31:5];
    end
end
```

##### Two Way Set Associative Cache
`two_way.sv` was created as a separate module for a two-way set-associative cache. This module is not integrated into the processor but was made to better my understanding of cache memory. However if I had more time, I would have liked to implement this due to improved cache utilisation and reduced miss rates.

---
### Implementing F1 Lights on Vbuddy

---
**Relevant commits:** 
* [F1 lights testing on Vbuddy](https://github.com/sirampy/Team22/commit/7ac6198f642235d1cf70d54631d70ca906210d59)

To verify that the jump instructions were working and all other relevant ones, I made a testbench `f1_tb.cpp` to display the F1 lights on Vbuddy whilst also modifying the assembly code to cause a 1 second delay. After a few iterations and debugging of the testbench, we were successful in displaying the expected output. 

---
