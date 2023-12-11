#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env) {

    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("top.vcd");

    top->rst = 0;

    for (int i = 0; i < 1000; ++i) {

        for (int clk = 0; clk < 2; ++clk){
            tfp->dump (2 * i + clk);
            top->clk_i = !top->clk_i;
            top->eval();
        }

        if (Verilated::gotFinish()) break;
        
    }

    tfp->close();
    exit(0);

}