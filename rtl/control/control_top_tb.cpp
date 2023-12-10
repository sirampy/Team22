#include "Vcontrol_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    Vcontrol_top* top = new Vcontrol_top;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("control_top.vcd");
    
    //testing addi a1, a1, 1
    top->op = 0x33; //opcode is the last 7 bits of the instruction
    top->funct3 = 000;
    top->funct7 = 0; //not relevant


    for (i=0; i<11; i++){

        for (clk=0; clk<2; clk++){
            tfp->dump (2*i + clk);
            top->clk = !top->clk;
            top->eval();
            //check if the instruction at PC = 10 is '00 15 85 93'
            if (top->op == 0x13) {
                //check if the decoder output is correct for 'addi'
                assert(top->reg_write == 1); //reg write should be enabled
                assert(top->alu_src == 0);   //arithmetic operator
                assert(top->alu_op == 2);   //for arithmetic operation

                std::cout << "Instruction decoded correctly at PC = 10\n";
            } else {
                std::cout << "Instruction at PC = 10 is not '00 15 85 93'\n";
            }
         

        }


        if (Verilated::gotFinish()) 
            exit(0);                // ... exit if finish OR 'q' pressed
        

    }
    tfp->close();
    exit(0);
}
