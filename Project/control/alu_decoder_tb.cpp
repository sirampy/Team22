#include "Valu_decoder.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <bitset>

void printBinary(int value, int bits) {
    for (int i = bits - 1; i >= 0; i--) {
        std::cout << ((value >> i) & 1);
    }
}

void verify(Valu_decoder* top){
    std::cout << "FUNCT3:    " << std::bitset<3>(top->funct3)
    << "\nFUNCT7:    " << std::bitset<1>(top->funct7) 
    << "\nALU_OP:    " << std::bitset<2>(top->alu_op) << std::endl;
    std::cout << "ALU_CONTROL: ";
    printBinary(top->alu_control, 3);
    std::cout << std::endl << std::endl;
}


int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    Valu_decoder* top = new Valu_decoder;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("alu_decoder.vcd");
  /*  top->funct3 = 0b010;
    top->funct7 = 0;
    top->alu_op = 0b10;
    top->eval();
    std::cout << "Output alu_control: ";

    printBinary(top->alu_control,3);
    std::cout << std::endl;
*/

    std::vector<int> funct3_cases = {0b000, 0b001, 0b010, 0b100, 0b101, 0b110, 0b111};
    std::vector<int> alu_op_cases = {0b00, 0b01, 0b10};

    for (int funct3 : funct3_cases) {
        for (int alu_op : alu_op_cases) {
            for (int funct7 = 0; funct7 <= 1; ++funct7) {
                top->funct3 = funct3;
                top->funct7 = funct7;
                top->alu_op = alu_op;

                top->eval();
                verify(top);
            }
        }
    }



    if (Verilated::gotFinish()) 
        exit(0); // exit if finish OR 'q' pressed
    
    tfp->close();
    exit(0);
}
