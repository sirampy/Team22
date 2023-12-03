#include "Vsign_extend.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    Vsign_extend* top = new Vsign_extend;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("sign_extend.vcd");

    for (i=0; i<18; i++){
        for (clk=0; clk<2; clk++){
            tfp->dump (2*i + clk);
            top->clk = !top->clk;

            if (i < 6) { //imm_src = 0
                top->imm_src = 0;
                top->instr = 0x12345678;
            } else if (i < 12) { //imm_src = 1
                top->imm_src = 1;
                top->instr = 0x12345678; 
            } else { //imm_src = 2
                top->imm_src = 2;
                top->instr = 0x12345678; 
            }

            top->eval();

            std::cout << "Cycle: " << i << " clk: " << clk 
                      << " imm_src: " << (int)top->imm_src 
                      << " imm_ext: " << std::hex << top->imm_ext << std::dec 
                      << std::endl;
        }  

        if (Verilated::gotFinish()) 
            exit(0); // exit if finish OR 'q' pressed
    }
    tfp->close();
    exit(0);
}
