#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

void evalAndDump(VerilatedVcdC* tfp, Vtop* top, int& i) {

    for ( top->clk = 1; top->clk < 5; --top->clk ) {
    
        top->eval();
        tfp->dump(++i);
    
    }
}

int main(int argc, char **argv, char **env) {

    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("top.vcd");

    top->rst = 0;
    top->clk = 0;

    int i = 0;
    tfp->dump(i);

    // Note: Using R0 - R31 notation, as we are just testing functionality, and it makes it easier to write binary

    // Testing I-Type arithmetic:
    // Implemented:         ADDI, SLTI, XORI, ORI, ANDI
    // Not implemented:     SLLI, SLTIU, SRLI, SRAI
    // Tested and working:  ADDI, SLTI, XORI, ORI, ANDI
    // Tested and broken:   

    evalAndDump(tfp, top, i); // ADDI R1, R0, 0x05      - Expect R1 = 0x5           -> ...00101 00000 000 00001 0010011       -> 00 50 00 93
    evalAndDump(tfp, top, i); // SLTI R2, R1, 0x05      - Expect R2 = 0x0           -> ...00101 00001 010 00010 0010011       -> 00 50 a1 13
    evalAndDump(tfp, top, i); // SLTI R3, R1, 0x06      - Expect R3 = 0x1           -> ...00110 00001 010 00011 0010011       -> 00 60 a1 93
    evalAndDump(tfp, top, i); // XORI R1, R1, 0x0f      - Expect R1 = 0xa           -> ...01111 00001 100 00001 0010011       -> 00 f0 c0 93
    evalAndDump(tfp, top, i); // ORI R1, R1, 0x04       - Expect R1 = 0xe           -> ...00100 00001 110 00001 0010011       -> 00 40 e0 93
    evalAndDump(tfp, top, i); // ANDI R1, R1, 0x08      - Expect R1 = 0x8           -> ...01000 00001 111 00001 0010011       -> 00 80 f0 93

    // Testing I-type loads:
    // Implemented:         LW
    // Not implemented:     LB, LH, LBU, LHU
    // Tested and working:  LW
    // Tested and broken:  

    evalAndDump(tfp, top, i); // LW R2, 0x5(R3)         - Expect R2 = 0x09080706    -> ...00101 00011 010 00010 0000011       -> 00 51 a1 03

    // Testing S-type:
    // Implemented:         SW
    // Not implemented:     SB, SH
    // Tested and working:  SW
    // Tested and broken:    

    evalAndDump(tfp, top, i); // ADDI R2, R2, 0x321     - Expect R2 = 0x09081027    -> 001100100001 00010 000 00010 0010011   -> 32 11 01 13
    evalAndDump(tfp, top, i); // SW R2, 5(R3)           - Expect no changes         -> ...00010 00011 010 00101 0100011       -> 00 21 a2 a3
    evalAndDump(tfp, top, i); // ADDI R2, R0, 0x0       - Expect R2 = 0x0           -> ...00010 0010011                       -> 00 00 01 13
    evalAndDump(tfp, top, i); // LW R2, 6(R0)           - Expect R2 = 0x09080706    -> ...00101 00011 010 00010 0000011       -> 00 51 a1 03

    // Testing R-Type:
    // Implemented:         ADD, SUB, SLT, XOR, OR, AND
    // Not implemented:     SLL, SLTU, SRL, SRA
    // Tested and working:  ADD, SUB, SLT, XOR, OR, AND
    // Tested and broken:  

    evalAndDump(tfp, top, i); // ADDI R1, R0, 0x05      - Expect R1 = 0x5           -> ...00101 00000 000 00001 0010011       -> 00 50 00 93
    evalAndDump(tfp, top, i); // ADD R2, R0, R1         - Expect R2 = 0x5           -> ...001 00000 000 00010 0110011         -> 00 10 01 33
    evalAndDump(tfp, top, i); // ADDI R2, R2, 0x8       - Expect R2 = 0xd           -> ...001000 00010 000 00010 0010011      -> 00 81 01 13
    evalAndDump(tfp, top, i); // SUB R3, R2, R1         - Expect R3 = 0x3           -> 0100000 00001 00010 000 00011 0110011  -> 40 11 01 b3
    evalAndDump(tfp, top, i); // SLT R3, R2, R1         - Expect R3 = 0x0           -> ...001 00010 010 00011 0110011         -> 00 11 21 b3
    evalAndDump(tfp, top, i); // SLT R3, R1, R2         - Expect R3 = 0x1           -> ...0010 00001 010 00011 0110011        -> 00 20 a1 b3
    evalAndDump(tfp, top, i); // XOR R3, R1, R2         - Expect R3 = 0x8           -> ...0010 00001 100 00011 0110011        -> 00 20 c1 b3
    evalAndDump(tfp, top, i); // OR R3, R1, R2          - Expect R3 = 0xd           -> ...0010 00001 110 00011 0110011        -> 00 20 e1 b3
    evalAndDump(tfp, top, i); // AND R3, R1, R2         - Expect R3 = 0x5           -> ...0010 00001 111 00011 0110011        -> 00 20 f1 b3

    // Testing B-Type:
    // Implemented:         BEQ, BNE
    // Not implemented:     BLT, BGE, BLTU, BGEU
    // Tested and working:  
    // Tested and broken:  
    
    evalAndDump(tfp, top, i); //ADDI R1, R0, 0x3                                       -> 00 30 00 93
    evalAndDump(tfp, top, i); //ADDI R2, R0, 0x5                                       -> 00 50 01 13
    evalAndDump(tfp, top, i); //ADDI R1, R1, 0x2                                       -> 00 20 80 93
    evalAndDump(tfp, top, i); //BEQ  R1, R2, -1 (if r1==r2, go back a line to addi)    -> FE 11 0F E3 
    evalAndDump(tfp, top, i); //ADDI R1, R1, -1                                        -> FF F0 80 93
    evalAndDump(tfp, top, i); //BNE  R1, R2, -1  (if r1!=r2, go back a line to addi)   -> FE 11 1F E3
    
    // Testing U&I-type:
    // Implemented:         JALR, JAL
    // Not implemented:     AUIPC?, LUI?
    // Tested and working:  
    // Tested and broken:  

    
    evalAndDump(tfp, top, i); // JALR
    evalAndDump(tfp, top, i); // JAL

    evalAndDump(tfp, top, i);

    tfp->close();
    exit(0);

}

