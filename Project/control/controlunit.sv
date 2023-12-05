module controlunit(
    input logic [31:0] instr,
    input logic zero,
    output logic result_src,
    output logic mem_write,
    output logic alu_src,
    output logic[1:0] imm_src,
    output logic reg_write,
    output logic  pc_src,
    output logic[3:0]  alu_control_o,
    output logic[1:0]  jump
);
//split up the instruction into its needed parts
logic op[6:0] = instr[6:0];
logic funct3[2:0] = instr[14:12];
logic funct7 = instr[30];
logic alu_op[1:0];

maindecoder maindecoder(
    .op(op),
    .zero(zero),
    .branch(branch),
    .jump(jump),
    .result_src(result_src),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .imm_src(imm_src),
    .reg_write(reg_write),
    .alu_op(alu_op)
    );
aludecoder aludecoder
(
    .op_i(op_i[5]),
    .funct3_i(funct3_i),
    .funct7_i(funct7_i),
    .alu_op_i(alu_op_i),
    .alu_control_o(alu_control_o)
);


endmodule
