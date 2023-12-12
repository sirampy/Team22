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
    tfp->open("top.vcd");
    
    if (vbdOpen()!=1) return (-1);
    vbdHeader("F1 Lights");

    top->clk = 1;
    top->rst = 1;


    vbdSetMode(1);


    for (i = 0; i < 10000; i++) {
        for (clk = 0; clk < 2; clk++) {
            tfp->dump(2 * i + clk);     // Write waveform data into the VCD file.
            top->clk = !top->clk;       // Toggle the clock signal.
            top->eval();                // Evaluate the counter module with the new clock value.

        }
        top->rst = 0;
        vbdHex(4, (int(top->a0_o) >> 16) & 0xF);
        vbdHex(3, (int(top->a0_o) >> 8) & 0xF);
        vbdHex(2, (int(top->a0_o) >> 4) & 0xF);
        vbdHex(1, int(top->a0_o) & 0xF);
        vbdCycle(i+1);
        vbdBar(top-> a0_o );
        top->rst = vbdFlag();


        if (Verilated::gotFinish()){     
            tfp->close();
            exit(0);
        }
    }
}
