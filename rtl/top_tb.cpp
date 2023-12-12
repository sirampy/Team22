#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

void evalAndDump(VerilatedVcdC* tfp, Vtop* top, int& i) {

    for ( top->clk = 1; top->clk < 5; --top->clk ) {
    
        top->eval();
        tfp->dump(++i);
    
    }
}

int main(int argc, char **argv, char **env) {

    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("top.vcd");

    top->clk = 0;

    int i = 0;
    tfp->dump(i);

    




    //initalise and loop once
    evalAndDump(tfp, top, i);
    evalAndDump(tfp, top, i);
    evalAndDump(tfp, top, i);
    evalAndDump(tfp, top, i);
    evalAndDump(tfp, top, i);
    evalAndDump(tfp, top, i);
    evalAndDump(tfp, top, i);
    evalAndDump(tfp, top, i);
    evalAndDump(tfp, top, i);
    evalAndDump(tfp, top, i);
    evalAndDump(tfp, top, i);
    evalAndDump(tfp, top, i);


    tfp->close();
    exit(0);

}

