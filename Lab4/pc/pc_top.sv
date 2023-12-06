module pc_top #(
    parameter PC_WIDTH = 32
)(
    input logic [PC_WIDTH-1:0] imm_op,
    input logic clk,
    input logic rst,
    input logic pc_src,
    output logic [PC_WIDTH-1:0] pc
);

logic [PC_WIDTH-1:0] next_pc;

assign next_pc = pc_src ? pc+imm_op : pc+4 ;

pc_reg pc_reg (
    .next_pc(next_pc),
    .clk(clk),
    .rst(rst),
    .pc(pc)
);

endmodule
