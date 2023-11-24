module alu_top #(
    param ADDR_WIDTH = 5;
    param DATA_WIDTH = 32;
)(
    input logic                   clk,           // clock
    input logic [ADDR_WIDTH:0]    rs1,           // address of register 1
    input logic [ADDR_WIDTH:0]    rs2,           // address of register 2
    input logic [ADDR_WIDTH:0]    rd,            // address of file to be written to
    input logic                   reg_write,     // write enable
    input logic [DATA_WIDTH:0]    imm_op,        // immediate value
    input logic                   alu_src,       // selects second input
    input logic [2:0]             alu_ctrl,      // determines operation in alu
    output logic                  eq             // equal flag
);

logic [DATA_WIDTH:0] alu_op2;   // input 1
logic [DATA_WIDTH:0] alu_op2;   // input 2
logic [DATA_WIDTH:0] alu_out;   // output of ALU
logic [DATA_WIDTH:0] reg_op2;   // second register

reg_file regfile (
    .clk (clk),
    .AD1 (rs1),
    .AD2 (rs2),
    .AD3 (rd),
    .WE3 (reg_write),
    .WD3 (alu_out),
    .RD1 (alu_op2),
    .RD2 (reg_op2)
);

alu_op2 = alu_src ? reg_op2 : imm_op;

alu alu (
    .alu_op2 (alu_op2),
    .aluOp2 (alu_op2),
    .aluCtrl (alu_ctrl),
    .sum (alu_out),
    .eq (eq)
);

endmodule
