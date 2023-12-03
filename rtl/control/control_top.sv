module control_top #(
    parameter INSTR_WIDTH = 32,
    parameter REG_ADDR_WIDTH = 5
)(
    input logic          clk_i,
    input logic [6:0]    op_i,
    input logic [2:0]    funct3_i,
    input logic          funct7_i,
    input logic [15:0]   pc_i,          // program counter
    input logic          eq_i,          // equal/zero flag

// control output signals
    output logic         pc_src_o,        // select pc next
    output logic         result_src_o,    // select write input
    output logic         mem_write_o,     // memory write enable
    output logic         alu_src_o,       // select rd2 or imm
    output logic         reg_write_o,     // register write enable
    output logic [1:0]   alu_ctrl_o,      // input to alu
    output logic [31:0]  imm_op_o,        //sign extended imm
    output logic [1:0]   imm_src_o,
    output logic [INSTR_WIDTH-1:0]   instr_o,    //instruction from mem
    output logic [1:0]               alu_op_o,   // select alu operation
    output logic         branch_o,


// parts of instruction
    output logic [REG_ADDR_WIDTH-1:0]    rs1_o,
    output logic [REG_ADDR_WIDTH-1:0]    rs2_o,
    output logic [REG_ADDR_WIDTH-1:0]    rd_o
);


//logic [1:0]               imm_src;  // imm select - depends on if I/S/B type

assign rs1_o = instr_o[19:15];
assign rs2_o = instr_o[24:20];
assign rd_o = instr_o[11:7];

instr_mem instr_mem (
    .a_i (pc_i),
    .rd_o (instr_o)
);

main_decoder main_decoder (
    .eq_i (eq_i),
    .op_i (op_i),
    .pc_src_o (pc_src_o),
    .result_src_o (result_src_o),
    .mem_write_o (mem_write_o),
    .alu_src_o (alu_src_o),
    .imm_src_o (imm_src_o),
    .reg_write_o (reg_write_o),
    .alu_op_o (alu_op_o),
    .branch_o (branch_o)
);

alu_decoder alu_decoder (
    .op5_i (op_i[5]),
    .funct3_i (funct3_i),
    .funct7_i (funct7_i),
    .alu_op_i (alu_op_o),
    .alu_control_o (alu_ctrl_o)
);

sign_extend sign_extend (
    .instr_i (instr_o[31:0]),
    .imm_src_i (imm_src_o),
    .imm_ext_o (imm_op_o)
);

endmodule
