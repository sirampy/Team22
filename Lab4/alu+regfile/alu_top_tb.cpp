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
    tfp->open("alu_top.vcd"); 


   //testing bne: rs1=rs2 - works, verified on GTKWave
    top->clk = 1; //clk is high
    top->rs1 = 0x0; //00000
    top->rs2 = 0x0; //00000
    top->rd = 0x3; //dont care, register not being rewritten
    top->reg_write = 0; //not needed
    top->alu_src = 0;
    top->imm_op = 5; //dont care for this case
    top->alu_ctrl = 001; //for beq

    //testing bne: rs1 = immediate- works, verified on GTKWave
    top->clk = 1; //clk is high
    top->rs1 = 0x0; //00000
    top->rs2 = 0x5; //dont care for this case
    top->rd = 0x3; //dont care, register not being rewritten
    top->reg_write = 0; //not needed
    top->alu_src = 1;
    top->imm_op = 5; 
    top->alu_ctrl = 001; //for beq   

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