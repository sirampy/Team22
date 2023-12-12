#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
// #include "vbuddy.cpp"

int main(int argc, char **argv, char **env) {
    int i;
    int clk_i;

    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("top.vcd");

    top->clk_i = 1;

    for (i=0; i<50000; i++){

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