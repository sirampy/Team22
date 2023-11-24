module control_top #(
    param INSTR_WIDTH = 32;
    param REG_ADDR_WIDTH = 5;
)(
    input  logic [15:0]   pc,           // program counter
    input  logic          eq,           // equal/zero flag

// control output signals
    output logic          pc_src,       // select pc next
    output logic          result_src,   // select write input
    output logic          mem_write,    // memory write enable
    output logic          alu_src,      // select rd2 or imm
    output logic          reg_write,    // register write enable
    output logic [1:0]    alu_ctrl,     // input to alu
    output logic [31:0]   imm_op,       //sign extended imm

// parts of instruction
    output logic [REG_ADDR_WIDTH-1:0]    rs1,
    output logic [REG_ADDR_WIDTH-1:0]    rs2,
    output logic [REG_ADDR_WIDTH-1:0]    rd,
    output logic [23:0]                  imm
);

logic [INSTR_WIDTH-1:0]   instr;    //instruction from mem
logic [1:0]    imm_src;  // imm select - depends on if I/S/B type
logic [1:0]    alu_op;   // select alu operation

instr_mem instr_mem (
    .a (pc),
    .rd (instr)
);

main_decoder main_decoder (
    .eq (eq),
    .op (instr[6:0]),
    .pc_src (pc_src),
    .result_src (result_src),
    .mem_write (mem_write),
    .alu_src (alu_src),
    .imm_src (imm_src),
    .reg_write (reg_write),
    .alu_op (alu_op)
);

alu_decoder alu_decoder (
    .op5 (instr[5]),
    .funct3 (instr[12:14]),
    .funct7 (instr[30]),
    .alu_op (alu_op),
    .alu_control (alu_ctrl)
);

sign_extend sign_extend (
    .instr (instr[31:7]),
    .imm_src (imm_src),
    .imm_ext (imm_op)
);

assign rs1 = instr[19:15]
assign rs2 = instr[24:20]
assign rd = instr[11:7]
assign imm = instr[31:7]

endmodule
