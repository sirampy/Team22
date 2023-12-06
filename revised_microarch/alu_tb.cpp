#include "Valu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

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

            top->src1_i = src1;
            top->src2_i = src2;

            top->alu3_i = control_types::ADD; 
            top->alu7_i = control_types::I_STD; 

            top->eval();

        //checking result
        if (clk == 1) { 
            switch (top->alu3_i) {
                case control_types::ADD:
                    if (top->result_o != (src1 + src2)) {
                        std::cerr << "Test failed for ADD operation" << std::endl;
                        return -1;
                    }
                    break;

                case control_types::L_SHIFT:
                    if (top->result_o != (src1 << (src2 & 0x1F))) {
                        std::cerr << "Test failed for L_SHIFT operation" << std::endl;
                        return -1;
                    }
                    break;

                case control_types::SLT:
                    if (top->result_o != (src1 < src2 ? 1 : 0)) {
                        std::cerr << "Test failed for SLT operation" << std::endl;
                        return -1;
                    }
                    break;

                case control_types::U_SLT:
                    if (top->result_o != (static_cast<uint32_t>(src1) < static_cast<uint32_t>(src2) ? 1 : 0)) {
                        std::cerr << "Test failed for U_SLT operation" << std::endl;
                        return -1;
                    }
                    break;

                case control_types::XOR:
                    if (top->result_o != (src1 ^ src2)) {
                        std::cerr << "Test failed for XOR operation" << std::endl;
                        return -1;
                    }
                    break;

                case control_types::R_SHIFT:
                    if (top->result_o != (src1 >> (src2 & 0x1F))) {
                        std::cerr << "Test failed for R_SHIFT operation" << std::endl;
                        return -1;
                    }
                    break;

                case control_types::OR:
                    if (top->result_o != (src1 | src2)) {
                        std::cerr << "Test failed for OR operation" << std::endl;
                        return -1;
                    }
                    break;

                case control_types::AND:
                    if (top->result_o != (src1 & src2)) {
                        std::cerr << "Test failed for AND operation" << std::endl;
                        return -1;
                    }
                    break;

                default:
                    std::cerr << "Unknown ALU operation" << std::endl;
                    return -1;
            }
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
