#include "Vdata_memory.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env) {
    int i;
    int clk_i;

    Verilated::commandArgs(argc, argv);
    Vdata_memory* top = new Vdata_memory;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("data_memory.vcd");


    for (i=0; i<1000; i++){

        for (clk_i=0; clk_i<2; clk_i++){
            tfp->dump (2*i + clk_i);
            top->clk_i = !top->clk_i;
            top->eval();
        }   


        if (Verilated::gotFinish()) 
            exit(0);                // ... exit if finish OR 'q' pressed
        

    }
    tfp->close();
    exit(0);
}