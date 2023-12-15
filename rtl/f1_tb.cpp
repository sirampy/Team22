#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"


int main(int argc, char **argv, char **env) {
    int i;
    int clk;


    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    top->trace(tfp, 99);
    tfp->open ("top.vcd");

    if (vbdOpen()!=1) return (-1);
    vbdHeader("Team 22: F1");

    top->clk = 0;
    top->rst = 0;

    vbdSetMode(1);
    vbdBar(0);

    for (i=0; i<1000; i++) {

        for (clk=0; clk<2; clk++) {
            tfp->dump (2*i+clk);
            top->clk = !top->clk;
            top->eval ();
        }

        vbdFlag();

        vbdBar(top->a0 & 0xFF);
        vbdCycle(i);
        

        if (Verilated::gotFinish()){     
            tfp->close();
            exit(0);
        }

    }

}