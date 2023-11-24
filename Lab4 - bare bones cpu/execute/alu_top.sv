module alu_top (
    input logic     clk,        // clock
    input logic     rs1,        // address of register 1
    input logic     rs2,        // address of register 2
    input logic     rd, 
    input logic     RegWrite,   // write enable
    input logic     ImmOp,      // immediate value
    input logic     aluSrc,     // selects second input
    input logic     aluCtrl,
    output logic    eq,
);

logic aluOp1;   // input 1
logic aluOp2;   // input 2
logic aluOut;   // output of ALU
logic regOp2;   // second register

reg_file regfile (
    .clk (clk),
    .AD1 (rs1),
    .AD2 (rs2),
    .AD3 (rd),
    .WE3 (RegWrite),
    .WD3 (aluOut),
    .RD1 (aluOp1),
    .RD2 (regOp2)
);

alu_mux multiplexer (
    .aluSrc (aluSrc),
    .regOp2 (regOp2),
    .ImmOp (ImmOp),
    .aluOp2 (aluOp2)
);

alu alu (
    .aluOp1 (aluOp1),
    .aluOp2 (aluOp2),
    .aluCtrl (aluCtrl),
    .sum (aluOut),
    .eq (eq)
);

endmodule
