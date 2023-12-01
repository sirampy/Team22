module controlunit(
    input logic [31:0] instr;
    input logic zero,
    output logic result_src,
    output logic mem_write,
    output logic alu_src,
    output logic[1:0] imm_src,
    output logic reg_write,
    output logic  pc_src,
    output logic[2:0]     alucode
);
//split up the instruction into its needed parts
logic op[6:0] = instr[6:0];
logic funct3[2:0] = instr[14:12];
logic funct7 = instr[30];
logic alu_op[1:0];

maindecoder maindecoder(
    .op(op),
    .zero(zero),
    .result_src(result_src),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .imm_src(imm_src),
    .reg_write(reg_write),
    .alu_op(alu_op)
    );
aludecoder aludecoder
(
    .op(op),
    .funct3(funct3),
    .funct7(funct7),
    .alu_op(alu_op),
    .alu_control(alu_control)
);


endmodule
