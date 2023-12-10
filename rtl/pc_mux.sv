module pc_mux #(
    parameter PC_WIDTH = 32
)(
    input logic [PC_WIDTH-1:0] pc_i,
    input logic [PC_WIDTH-1:0] imm_op_i,
    input logic pc_src_i, //signal for branch and jal 
    input logic [PC_WIDTH-1:0] pc_jalr_i, //pc from jalr register
    input logic jalr_pc_src_i, //control signal for jalr
    output logic [PC_WIDTH-1:0] next_pc_o
);


logic [PC_WIDTH-1:0] jalBranch_pc;
logic [PC_WIDTH-1:0] inc_pc;
assign jalBranch_pc = pc_i +imm_op_i; //assigning for readability
assign inc_pc = pc_i + 4;//assigning for readability
assign next_pc_o = jalr_pc_src_i ? pc_jalr_i : (pc_src_i ? jalBranch_pc : inc_pc);

endmodule
