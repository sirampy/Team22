#include "Vcontrolunit.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"
using namespace std;
void display(Vcontrolunit* top) {
    cout << "\nINPUTS\n\n";

    cout << "OP: " << bitset<7>(top->op_i) << " , FUNCT3: " 
    << bitset<3>(top->funct3_i) << " , FUNCT7: " 
    << bitset<1>(top->funct7_i) << endl << endl;

    cout << "OUTPUTS\n\n";

    cout << "Result Source: \t" << bitset<1>(top->result_src) << endl;
    cout << "Memory Write: \t" << bitset<1>(top->mem_write) << endl;
    cout << "ALU Source: \t" << bitset<1>(top->alu_src) << endl;
    cout << "Immediate Source: \t" << bitset<3>(top->imm_src) << endl;
    cout << "Register Write: \t" << bitset<1>(top->reg_write) << endl;
    cout << "PC Source: \t" << bitset<1>(top->pc_src) << endl;
    cout << "ALU Control: \t" << bitset<4>(top->alu_control_o) << endl;
    cout << "Jump: \t" << bitset<2>(top->jump) << endl;
}

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    Vcontrolunit* top = new Vcontrolunit;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("controlunit.vcd");

    vector<int> funct3{0b000, 0b001, 0b010, 0b011, 0b100, 0b101, 0b110, 0b111};
    vector<int> funct3_ls{0b000, 0b001, 0b010, 0b100, 0b101};
    vector<int> funct3_branch{0b000, 0b001, 0b100, 0b101, 0b110, 0b111};

    cout << "\n \nR-TYPE INSTRUCTIONS\n \n " << endl;

    top->op_i = 0b0110011; //R-Type instructions
    for(int i = 0; i < 8; i++){
        top->funct3_i = funct3[i];
        if (funct3[i] == 0b101){
            top->funct7_i = 0b1;
            top->eval();
            display(top);
            top->funct7_i = 0b0;
        }
        top->eval();
        display(top);
    }

    cout << "\n \nI-TYPE BITWISE INSTRUCTIONS\n \n " << endl;

    top->op_i = 0b0010011;  //I-Type Bitwise Instructions
    for(int i = 0; i < 8; i++){
        top->funct3_i = funct3[i];
        if (funct3[i] == 0b101){
            top->funct7_i = 0b1;
            top->eval();
            display(top);
            top->funct7_i = 0b0;
        }
        top->eval();
        display(top);
    }

    cout << "\n \nI-TYPE LOAD INSTRUCTIONS\n \n " << endl;

    top->op_i = 0b0000011;  //I-Type Load Instructions
    for(int i = 0; i < 5; i++){
        top->funct3_i = funct3_ls[i];
        top->eval();
        display(top);
    }

    cout << "\n \nS-TYPE INSTRUCTIONS\n \n " << endl;

    top->op_i = 0b0100011;  //I-Type Store Instructions
    for(int i = 0; i < 3; i++){
        top->funct3_i = funct3_l[i];
        top->eval();
        display(top);
    }

    cout << "\n \nB-TYPE INSTRUCTIONS\n \n " << endl;

    top->op_i = 0b1100011;  //Branch Instructions
    for(int i = 0; i < 6; i++){
        top->funct3_i = funct3_branch[i];
        top->eval();
        display(top);
    }

    cout << "\n \nJAL INSTRUCTIONS\n \n " << endl;

    top->op_i = 0b1100111;  //jalr
    top->eval();
    display(top);

    top->op_i = 0b1101111; //jal
    top->eval();
    display(top);


    for (i=0; i<300; i++){

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