#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

void evalAndDump(VerilatedVcdC* tfp, Vtop* top, int& i) {

    for ( top->i_clk = 1; top->i_clk < 5; --top->i_clk ) {
    
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

    top->i_clk = 0;

    int i = 0;
    tfp->dump(i);

    // Note: Using R0 - R31 notation, as we are just testing functionality, and it makes it easier to write binary

    // Testing I-Type arithmetic:
    // Implemented:         ADDI, SLLI, SLTI, SLTIU, XORI, SRLI, SRAI, ORI, ANDI
    // Not implemented:     
    // Tested and working:  ADDI, SLLI, SLTI, SLTIU, XORI, SRLI, SRAI, ORI, ANDI
    // Tested and broken:   

    // Note: SLTI and SLTIU require more rigorous testing. This has been complete.

    evalAndDump(tfp, top, i); // ADDI R1, R0, 0x05      - Expect R1 = 0x5           -> ...00101 00000 000 00001 0010011       -> 00 50 00 93
    evalAndDump(tfp, top, i); // SLLI R4, R1, 0x1d      - Expect R4 = 0xa000...     -> ...00010 00001 001 00100 0010011       -> 01 d0 92 13
    evalAndDump(tfp, top, i); // SLTI R2, R1, 0x05      - Expect R2 = 0x0           -> ...00101 00001 010 00010 0010011       -> 00 50 a1 13
    evalAndDump(tfp, top, i); // SLTI R3, R1, 0x06      - Expect R3 = 0x1           -> ...00110 00001 010 00011 0010011       -> 00 60 a1 93
    evalAndDump(tfp, top, i); // SLTIU R2, R1, 0x05     - Expect R2 = 0x0           -> ...00101 00001 011 00010 0010011       -> 00 50 b1 13
    evalAndDump(tfp, top, i); // SLTIU R3, R1, 0x06     - Expect R3 = 0x1           -> ...00110 00001 011 00011 0010011       -> 00 60 b1 93
    evalAndDump(tfp, top, i); // XORI R1, R1, 0x0f      - Expect R1 = 0xa           -> ...01111 00001 100 00001 0010011       -> 00 f0 c0 93
    evalAndDump(tfp, top, i); // SRLI R5, R4, 0x02      - Expect R1 = 0xa           -> ...00010 00100 101 00101 0010011       -> 00 22 52 93
    evalAndDump(tfp, top, i); // SRAI R5, R4, 0x02      - Expect R1 = 0xa           -> 010000000010 00100 101 00101 0010011   -> 40 22 52 93
    evalAndDump(tfp, top, i); // ORI R1, R1, 0x04       - Expect R1 = 0xe           -> ...00100 00001 110 00001 0010011       -> 00 40 e0 93
    evalAndDump(tfp, top, i); // ANDI R1, R1, 0x08      - Expect R1 = 0x8           -> ...01000 00001 111 00001 0010011       -> 00 80 f0 93

    // Testing I-type loads:
    // Implemented:         LB, LH, LW, LBU, LHU
    // Not implemented:     
    // Tested and working:  LB, LH, LW, LBU, LHU
    // Tested and broken:  

    evalAndDump(tfp, top, i); // LB R2, 0x5(R3)         - Expect R2 = 0xffffff86    -> ...00101 00011 000 00010 0000011       -> 00 51 81 03
    evalAndDump(tfp, top, i); // LH R2, 0x5(R3)         - Expect R2 = 0xffff8786    -> ...00101 00011 001 00010 0000011       -> 00 51 91 03
    evalAndDump(tfp, top, i); // LBU R2, 0x5(R3)        - Expect R2 = 0x00000086    -> ...00101 00011 100 00010 0000011       -> 00 51 c1 03
    evalAndDump(tfp, top, i); // LHU R2, 0x5(R3)        - Expect R2 = 0x00008786    -> ...00101 00011 101 00010 0000011       -> 00 51 d1 03
    evalAndDump(tfp, top, i); // LW R2, 0x5(R3)         - Expect R2 = 0x09080706    -> ...00101 00011 010 00010 0000011       -> 00 51 a1 03

    // Testing S-type:
    // Implemented:         SB, SH, SW
    // Not implemented:     
    // Tested and working:  SB, SH, SW
    // Tested and broken:    

    evalAndDump(tfp, top, i); // ADDI R2, R2, 0x321     - Expect R2 = 0x09088aa7    -> 001100100001 00010 000 00010 0010011   -> 32 11 01 13
    evalAndDump(tfp, top, i); // SB R2, 5(R3)           - Expect no changes         -> ...00010 00011 000 00101 0100011       -> 00 21 82 a3
    evalAndDump(tfp, top, i); // ADDI R4, R0, 0x0       - Expect R4 = 0x0           -> ...00100 0010011                       -> 00 00 02 13
    evalAndDump(tfp, top, i); // LW R4, 6(R0)           - Expect R4 = 0x000000a7    -> ...00101 00011 010 00100 0000011       -> 00 51 a2 03
    evalAndDump(tfp, top, i); // SH R2, 5(R3)           - Expect no changes         -> ...00010 00011 001 00101 0100011       -> 00 21 92 a3
    evalAndDump(tfp, top, i); // ADDI R4, R0, 0x0       - Expect R4 = 0x0           -> ...00100 0010011                       -> 00 00 02 13
    evalAndDump(tfp, top, i); // LW R4, 6(R0)           - Expect R4 = 0x00008aa7    -> ...00101 00011 010 00100 0000011       -> 00 51 a2 03
    evalAndDump(tfp, top, i); // SW R2, 5(R3)           - Expect no changes         -> ...00010 00011 010 00101 0100011       -> 00 21 a2 a3
    evalAndDump(tfp, top, i); // ADDI R4, R0, 0x0       - Expect R4 = 0x0           -> ...00100 0010011                       -> 00 00 02 13
    evalAndDump(tfp, top, i); // LW R4, 6(R0)           - Expect R4 = 0x09088aa7    -> ...00101 00011 010 00100 0000011       -> 00 51 a2 03

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
    // Tested and working:  BEQ, BNE
    // Tested and broken:  
    
    evalAndDump(tfp, top, i); // ADDI R1, R0, 0x3       - Expect R1 = 0x3           -> ...00011 00000 000 00001 0010011       -> 00 30 00 93
    evalAndDump(tfp, top, i); // ADDI R2, R0, 0x5       - Expect R2 = 0x5           -> ...00101 00000 000 00001 0010011       -> 00 50 01 13
    evalAndDump(tfp, top, i); // ADDI R1, R1, 0x2       - Expect R1 = 0x5           -> ...00010 00001 000 00001 0010011       -> 00 20 80 93
    evalAndDump(tfp, top, i); // BEQ  R1, R2, -4        - Expect branch back 1 line -> 1111110 00001 00010 000 11101 1100011  -> fe 11 0e e3
    evalAndDump(tfp, top, i); //                        - Expect R1 = 0x7
    evalAndDump(tfp, top, i); //                        - Expect no jump
    evalAndDump(tfp, top, i); // ADDI R1, R1, -1        - Expect R1 = 6             -> 111111111111 00001 000 00001 0010011   -> ff f0 80 93
    evalAndDump(tfp, top, i); // BNE  R1, R2, -4        - Expect branch back 1 line -> 1111110 00001 00010 001 11101 1100011  -> fe 11 1e e3
    evalAndDump(tfp, top, i); //                        - Expect R1 = 5
    evalAndDump(tfp, top, i); //                        - Expect no jump
    
    // Testing U&I-type:
    // Implemented:         JALR, JAL
    // Not implemented:     AUIPC, LUI
    // Tested and working:  JALR, JAL
    // Tested and broken:  

    evalAndDump(tfp, top, i); // JAL R2, 0x8            - Expect jump forw. 2 lines -> ...00100000000000 00010 1101111        -> 00 80 01 6f
    evalAndDump(tfp, top, i); // ADDI R1, R0, 0x0       - Not expected to run       -> ...00000 000 00001 0010011             -> 00 00 00 93
    evalAndDump(tfp, top, i); // JALR R3, R2, 0xC       - Expect jump forw. 2 lines -> ...001100 00010 000 00011 1100111      -> 00 c1 01 e7
    evalAndDump(tfp, top, i); // ADDI R1, R0, 0x0       - Not expected to run       -> ...00000 000 00001 0010011             -> 00 00 00 93
    evalAndDump(tfp, top, i); // ADDI R1, R0, 0x10      - Expect R1 = 0x10          -> ...0010000 000 00001 0010011           -> 01 00 00 93
                              //                        - Note: Verify R2 after JAL and R3 after JALR equals PC + 4 both times

    evalAndDump(tfp, top, i);

    tfp->close();
    exit(0);

}

