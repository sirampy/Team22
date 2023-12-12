#include "Vtwo_way.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env) {

    Verilated::commandArgs(argc, argv);
    Vtwo_way* top = new Vtwo_way;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("two_way.vcd");


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