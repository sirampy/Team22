module pc_top(
    input logic ImmOp,
    input logic clk,
    input logic rst,
    input logic PCsrc,
    output logic pc
);
logic next_PC;

pc_multiplx multi(
    .branch_PC(pc+ImmOp),
    .inc_PC(pc+4),
    .PCsrc(PCsrc),
    .next_PC(next_PC),
);
pc_reg reg (
    .next_PC(next_PC),
    .clk(clk),
    .rst(rst)
    .pc(pc)
);


endmodule
