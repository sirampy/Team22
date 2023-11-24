#include "Vsign_extend.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>


int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    Vsign_extend* top = new Vsign_extend;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("sign_extend.vcd");

    //test case for 2'b01, imm_src = 1;
    /*top->instr = 0x12345678; //test case value
    top->imm_src = 1;        

    top->eval();             

    //expected output 
    int expected_imm_ext = (top->instr >> 7) & 0x1F;  //instr[11:7] bits
    expected_imm_ext |= ((top->instr >> 25) & 0x7F) << 5;  //instr[31:25] bits, shift left by 5

    //check if expected = output
    if (top->imm_ext != expected_imm_ext) {
        std::cerr << "Test Case  Failed: Expected 0x" << std::hex << expected_imm_ext 
                << ", got 0x" << top->imm_ext << std::endl;
    } else {
        std::cout << "Test Case Passed." << std::endl;
    }
    */

   //test case for when 2'b00, imm_src = 0;
    top->instr = 0x12345678;  // test case value
    top->imm_src = 0;

    top->eval();              

    //expected output for imm_src = 0
    int expected_imm_ext = (top->instr >> 20) & 0xFFF; //extracting instr[31:20] bits
    if (expected_imm_ext & 0x800) { //check if sign bit of 12 bit value is set
        expected_imm_ext |= 0xFFFFF000; //sign extend to 32 bits
    }

    //check if expected = output
    if (top->imm_ext != (expected_imm_ext & 0xFFF)) { //comparing only lower 12 bits
        std::cerr << "Test Case Failed: Expected 0x" << std::hex << (expected_imm_ext & 0xFFF)
                << ", got 0x" << top->imm_ext << std::endl;
    } else {
        std::cout << "Test Case Passed." << std::endl;
    }


    for (i=0; i<18; i++){

        for (clk=0; clk<2; clk++){
            tfp->dump (2*i + clk);
            top->clk = !top->clk;
            top->eval();
        }  

        if (Verilated::gotFinish()) 
            exit(0);                // ... exit if finish OR 'q' pressed
        

    }
    tfp->close();
    exit(0);
}