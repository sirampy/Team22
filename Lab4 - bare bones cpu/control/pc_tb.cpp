#include "Vpctop.h"
#include "verilated.h"
#include "verilated_vcd_c.h" 

int main(int argc,char **argv, char **env){
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    //init top verilog instance 
    Vpctop* top = new Vpctop;
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp= new VerilatedVcdC;
    top->trace (tfp,99);
    tfp->open ("pctop.vcd");

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 1;
    top->PCsrc = 0; 
    top->ImmOp = 0xFF;
    
    //run simulation for many clock cycles
    for (i=0; i<300; i++){ 
            for (clk=0; clk<2; clk++) {
                tfp->dump (2*i+clk);
                top->clk = !top->clk;
                top->eval();
            }

            top->rst = (i<2) | (i==15);
            if (Verilated::gotFinish())  
            exit(0);
    }
    tfp->close();
    exit(0);

}