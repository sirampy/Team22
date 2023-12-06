#include "Valu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "control_types.sv"

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);
    Valu* top = new Valu;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("alu.vcd");
    
    top->clk = 0;

    //test values
    int32_t src1 = 10;
    int32_t src2 = 5;

    //Testing each ALU operation
    for (int i = 0; i < 300; i++) {
        for (int clk = 0; clk < 2; clk++) {
            tfp->dump(2*i + clk);
            top->clk = !top->clk;

            // Set inputs for each cycle
            top->src1_i = src1;
            top->src2_i = src2;

            // Set ALU operation (you need to define these based on your control_types)
            top->alu3_i = control_types::ADD; // Replace with actual control signal for ADD
            top->alu7_i = I_STD; // Replace with actual control signal for I_STD

            top->eval();

            // Check the result for each operation
            if (clk == 1) { // Check on the falling edge
                if (top->result_o != (src1 + src2)) {
                    std::cerr << "Test failed for ADD operation" << std::endl;
                    return -1;
                }

                // Add similar checks for other operations
                // ...

            }
        }

        if (Verilated::gotFinish()) 
            exit(0);
    }

    tfp->close();
    delete top;
    delete tfp;
    return 0;
}
