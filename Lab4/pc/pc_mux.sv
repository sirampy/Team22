module pc_mux #(
    parameter PC_WIDTH = 32
)(
    input logic [PC_WIDTH-1:0] pc,
    input logic [PC_WIDTH-1:0] imm_op,
    input logic pc_src,
    input logic [PC_WIDTH-1:0] pc_jalr,
    input logic jalr_pc_src, //control signal for jalr
    output logic [PC_WIDTH-1:0] next_pc,
    output logic [PC_WIDTH-1:0] pc_plus4
);


logic [PC_WIDTH-1:0] jalBranch_pc;
logic [PC_WIDTH-1:0] inc_pc;
assign jalBranch_pc = pc +imm_op;
assign inc_pc = pc + 4;
assign next_pc = jalr_pc_src ? pc_jalr : (pc_src ? jalBranch_pc : inc_pc);
assign next_pc = pc_src ? pc+imm_op : pc+4 ;

endmodule
