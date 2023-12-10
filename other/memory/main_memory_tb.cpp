#include "Vmain_memory.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env) {

    Verilated::commandArgs(argc, argv);
    Vmain_memory* top = new Vmain_memory;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("main_memory.vcd");

    int i = 0;

    top->clk = 0;
    top->eval();
    tfp->dump (i);

    // Write to word address 15
    top->write_enable_i = 1;
    top->address_i = 0xf << 2;
    top->write_value_i = 0x123;

    top->clk = 1;
    top->eval();
    tfp->dump (++i);
    top->clk = 0;
    top->eval();
    tfp->dump (++i);
    
    // Write to word address 14 without setting write_enable to 0
    top->address_i = 0xe << 2;
    top->write_value_i = 0x456;

    top->clk = 1;
    top->eval();
    tfp->dump (++i);
    top->clk = 0;
    top->eval();
    tfp->dump (++i);

    // Read word address 15 and attempt to write erroneous value without enable
    top->write_enable_i = 0;
    top->address_i = 0xf << 2;
    top->write_value_i = 0x789;

    top->clk = 1;
    top->eval();
    tfp->dump (++i);
    top->clk = 0;
    top->eval();
    tfp->dump (++i);
    
    // Read word address 14
    top->address_i = 0xe << 2;
    
    top->clk = 1;
    top->eval();
    tfp->dump (++i);
    top->clk = 0;
    top->eval();
    tfp->dump (++i);

    tfp->close();
    exit(0);

}