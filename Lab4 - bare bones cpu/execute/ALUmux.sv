module ALUmux(
    input logic     aluSrc,    //select
    input logic     regOp2,    //if 0
    input logic     ImmOp,     //if 1
    output logic    aluOp2     //outputs second alu input
);

assign aluOp2 = aluSrc ? regOp2:ImmOp;

endmodule