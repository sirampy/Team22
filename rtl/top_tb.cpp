#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vdata_memory_cache.h"
#include <iostream>

#define MAX_SIM_CYC 100

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);
    Vdata_memory_cache* top = new Vdata_memory_cache;
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("data_memory_cache.vcd");

    top->clk_i = 0;
    top->address_i = 0x12345678; // Example address
    top->write_value_i = 0xABCD; // Example data
    top->write_enable_i = 1;     // Enable write operation

    // Run simulation for a few cycles
    for (int simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++) {
        tfp->dump(simcyc);
        top->clk_i = !top->clk_i;
        top->eval();

        if (simcyc == 1) {
            // Disable write operation after first cycle
            top->write_enable_i = 0;
        }

        if (simcyc == 2) {
            // Read from the same address
            // Expect: Cache hit and data 0xABCD should be read
            if (top->read_value_o != 0xABCD) {
                std::cerr << "Mismatch at cycle " << simcyc << ": expected 0xABCD, got " << std::hex << top->read_value_o << std::endl;
                exit(1);
            }
        }

        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    delete top;
    exit(0);
}
