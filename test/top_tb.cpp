#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
// #include "vbuddy.cpp"

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("top.vcd");

    top->rst_i = 1;
    top->clk_i = 1;

    for (i=0; i<500000; i++){

        for (clk=0; clk<2; clk++){
            tfp->dump (2*i + clk);
            top->clk_i = !top->clk_i;
            top->eval();
        }   

        if (i == 0){
            top->rst_i = 0;
        }

        if (Verilated::gotFinish()) 
            exit(0);                // ... exit if finish OR 'q' pressed

    }
    tfp->close();
    exit(0);
}