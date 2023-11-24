module alu_top (
    input logic     clk,        // clock
    input logic     rs1,        // address of register 1
    input logic     rs2,        // address of register 2
    input logic     rd, 
    input logic     reg_write,   // write enable
    input logic     imm_op,      // immediate value
    input logic     alu_src,     // selects second input
    input logic     alu_ctrl,
    output logic    eq,
);

logic alu_op2;   // input 1
logic alu_op2;   // input 2
logic alu_out;   // output of ALU
logic reg_op2;   // second register

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
