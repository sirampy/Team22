#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vdata_memory_cache.h"

#define MAX_SIM_CYC 100

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);

    Vdata_memory_cache* top = new Vdata_memory_cache;
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    top->trace(tfp, 99);
    tfp->open("data_memory_cache.vcd");

    top->clk_i = 0;
    top->address_i = 0;
    top->write_value_i = 0;
    top->write_enable_i = 0;

    for (int simcyc = 0; simcyc < MAX_SIM_CYC; ++simcyc) {
        // Toggle clock and capture the state at every edge
        for (int tick = 0; tick < 2; ++tick) {
            top->clk_i = (tick == 0) ? 1 : 0; // Toggle clock
            top->eval(); // Evaluate the model
            tfp->dump(2 * simcyc + tick); // Dump the state at this moment
        }

        // Your simulation logic
        switch (simcyc) {
            case 1:
                top->address_i = 0x1000; // Address A
                top->write_value_i = 12345;
                top->write_enable_i = 1;
                break;
            case 3:
                top->address_i = 0x2000; // Address B (different)
                top->write_value_i = 67890;
                top->write_enable_i = 1;
                break;
            case 5:
                top->address_i = 0x1000; // Address A again (should be a hit if cache works)
                top->write_value_i = 22222;
                top->write_enable_i = 1;
                break;
            case 7:
                top->address_i = 0x3000; // Address C (different)
                top->write_value_i = 33333;
                top->write_enable_i = 1;
                break;
            case 9:
                top->address_i = 0x2000; // Address B again (should be a hit)
                top->write_value_i = 44444;
                top->write_enable_i = 1;
                break;
            default:
                top->write_enable_i = 0; // Ensure write_enable is low by default
                break;
        }

        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    delete top;
    delete tfp;
    exit(0);
}
