module pctop(
    input logic ImmOp,
    input logic clk,
    input logic rst,
    input logic PCsrc,
    output logic pc
);
logic next_PC;

pcmultiplx multi(
    .branch_PC(pc+ImmOp),
    .inc_PC(pc+4),
    .PCsrc(PCsrc),
    .next_PC(next_PC),
);
PCreg reg (
    .next_PC(next_PC),
    .clk(clk),
    .rst(rst)
    .pc(pc)
);


endmodule
