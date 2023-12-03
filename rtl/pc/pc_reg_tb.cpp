#include "Vpc_reg.h"
#include "verilated.h"
#include "verilated_vcd_c.h" 

int main(int argc,char **argv, char **env){
    int simcyc;     // simulation clock count
    int tick;       // each clk cycle has two ticks for two edges

    Verilated::commandArgs(argc, argv);
    //init top verilog instance 
    Vpc_reg* top = new Vpc_reg;
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp= new VerilatedVcdC;
    top->trace (tfp,99);
    tfp->open ("pc_reg.vcd");

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 1;
    top->pc_src = 0; 
    top->imm_op = 0xFF;
    
    //run simulation for many clock cycles
    for (simcyc=0; simcyc<300; simcyc++) {
        for (tick=0; tick<2; tick++) {
            tfp->dump (2*simcyc+tick);
            top->clk = !top->clk;
            top->eval ();
        }

        top->rst = (simcyc < 2);  // assert reset for 1st cycle
        top->pc_src = (simcyc == 4); //tests if imm_op is added

        if (Verilated::gotFinish())  exit(0);
    }

    tfp->close();
    exit(0);

}