#include "Valu_decoder.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    Valu_decoder* top = new Valu_decoder;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("alu_decoder.vcd");
    top->funct3 = 0b010;
    top->funct7 = 0;
    top->alu_op = 0b10;

    std::cout << "Output alu_control: " << (int)top->alu_control << std::endl;



        if (Verilated::gotFinish()) 
            exit(0); // exit if finish OR 'q' pressed
    }
    tfp->close();
    exit(0);
}
