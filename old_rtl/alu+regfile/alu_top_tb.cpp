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


   //testing beq:rs1=rs2 - works, verified on GTKWave
    top->clk_i = 1; //clk is high
    top->rs1_i = 0x0; //00000
    top->rs2_i = 0x0; //00000
    top->rd_i = 0x3; //dont care, register not being rewritten
    top->reg_write_i = 0; //not needed
    top->alu_src_i = 0;
    top->imm_op_i = 5; //dont care for this case
    top->alu_src_i = 1; 
    top->imm_op_i = 0xFF;//dont care
    top->alu_ctrl_i = 001; //for beq

    //testing beq:rs1 = immediate - works, verified on GTKWave
    top->clk_i = 1; //clk is high
    top->rs1_i = 0x0; //00000
    top->rs2_i = 0x5; //dont care for this case
    top->rd_i = 0x3; //dont care, register not being rewritten
    top->reg_write_i = 0; //not needed
    top->alu_src_i = 1;
    top->imm_op_i = 5; 
    top->alu_ctrl_i = 001; //for beq   

    for (i=0; i<300; i++){

        for (clk=0; clk<2; clk++){
            tfp->dump (2*i + clk);
            top->clk_i = !top->clk_i;
            top->eval();
        }  

        if (Verilated::gotFinish()) 
            exit(0);                // ... exit if finish OR 'q' pressed
        

    }
    tfp->close();
    exit(0);
}