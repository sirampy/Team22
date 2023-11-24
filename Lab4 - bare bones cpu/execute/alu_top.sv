module alu_top #(
    param ADDR_WIDTH = 5;
    param DATA_WIDTH = 32;
)(
    input logic                   clk,        // clock
    input logic [ADDR_WIDTH:0]    rs1,        // address of register 1
    input logic [ADDR_WIDTH:0]    rs2,        // address of register 2
    input logic [ADDR_WIDTH:0]    rd,         // address of file to be written to
    input logic                   RegWrite,   // write enable
    input logic [DATA_WIDTH:0]    ImmOp,      // immediate value
    input logic                   aluSrc,     // selects second input
    input logic [2:0]             aluCtrl,    // determines operation in alu
    output logic                  eq          // equal flag
);

logic [DATA_WIDTH:0] aluOp1;   // input 1
logic [DATA_WIDTH:0] aluOp2;   // input 2
logic [DATA_WIDTH:0] aluOut;   // output of ALU
logic [DATA_WIDTH:0] regOp2;   // second register

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
