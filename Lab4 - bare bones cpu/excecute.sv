module topAlu (
    input logic     rs1,        // address of register 1
    input logic     rs2,        // address of register 2
    input logic     rd, 
    input logic     RegWrite,   // write enable
    input logic     ImmOp,      // immediate value
    input logic     aluSrc;     // selects second input
    input logic     clk,        // clock
    output logic    eq,
);

logic aluOp1;   // input 1
logic aluOp2;   // input 2
logic aluOut;   // output of ALU
logic regOp2;   // second register

endmodule
