module pc_top(
    input logic imm_op,
    input logic clk,
    input logic rst,
    input logic pc_src,
    output logic pc
);

logic next_pc;

next_pc = pc_src ? pc+imm_op : pc+4 ;

pc_reg reg (
    .next_pc(next_pc),
    .clk(clk),
    .rst(rst)
    .pc(pc)
);

endmodule

