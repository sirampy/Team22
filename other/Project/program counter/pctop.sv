module pc_top #(
    parameter PC_WIDTH = 32;
)(
    input logic [31:0] imm_op,
    input logic clk,
    input logic rst,
    input logic pc_src,
    input logic [1:0] jump,
    input logic [PC_WIDTH-1:0] jalr_pc, //when asserted, decides pc
    output logic [PC_WIDTH-1:0] alu_pc,
    output logic [PC_WIDTH-1:0] pc
);

logic [PC_WIDTH-1:0] next_pc;
logic pc_jump; //checks if instruction is jump

assign pc_jump = jump[0] | pc_src;

always_comb begin
    if (jump[1]) next_pc = jalr_pc; //for jalr
    else begin
        next_pc = pc_src ? pc+imm_op : pc+32'h4 ;//pc_src = 1 for jal/branch
    end
end

pc_reg pc_reg (
    .next_pc(next_pc),
    .clk(clk),
    .rst(rst),
    .pc(pc)
);

endmodule
