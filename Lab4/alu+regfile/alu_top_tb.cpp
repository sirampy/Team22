#include "Valu_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    Valu_top* top = new Valu_top;


    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("alu_top.vcd"); //C++ executable of the system verilog file


   //testing bne
   //expected output: eq = 1, a1 != a0
    top->clk = 1; //clk is high
    top->rs1 = 0x1; //00000
    top->rs2 = 0x1; //00001
    top->rd = 0x3; //dont care, register not being rewritten
    top->reg_write = 0; //not needed
    top->alu_src = 0; //not needed, we are selecting register file
    top->imm_op = 0xFF;//dont care
    top->alu_ctrl = 001; //for bne
    

    for (i=0; i<300; i++){

        for (clk=0; clk<2; clk++){
            tfp->dump (2*i + clk);
            top->clk = !top->clk;
            top->eval();
        }  

        if (Verilated::gotFinish()) 
            exit(0);                // ... exit if finish OR 'q' pressed
        

    }
    tfp->close();
    exit(0);
}