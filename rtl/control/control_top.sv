module control_top #(
    parameter INSTR_WIDTH = 32,
    parameter REG_ADDR_WIDTH = 5
)(
    input  logic [6:0]    op,                    
    input  logic [2:0]    funct3,                
    input  logic          funct7,          
    input  logic [31:0]   pc,           // program counter            
    input  logic          eq,           // equal/zero flag

// control output signals
    output logic          pc_src,       // control signal for JAL and branch
    output logic          result_src,   // select write input
    output logic          mem_write,    // memory write enable
    output logic          alu_src,      // select rd2 or imm
    output logic          reg_write,    // register write enable
    output logic          jalr_pc_src,  //control signal for JALR
    output logic [2:0]    alu_ctrl,     // input to alu                       
    output logic [31:0]   imm_op,       //sign extended imm
    output logic [1:0]    imm_src,
    output logic [INSTR_WIDTH-1:0]   instr,    //instruction from mem   
// parts of instruction
    output logic [REG_ADDR_WIDTH-1:0]    rs1,
    output logic [REG_ADDR_WIDTH-1:0]    rs2,
    output logic [REG_ADDR_WIDTH-1:0]    rd
);

logic [1:0] alu_op; 


assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign rd = instr[11:7];

instr_mem instr_mem (
    .a (pc),
    .rd (instr)
);

main_decoder main_decoder (
    .eq (eq),
    .op (op),
    .pc_src (pc_src),
    .result_src (result_src),
    .mem_write (mem_write),
    .alu_src (alu_src),
    .imm_src (imm_src),
    .reg_write (reg_write),
    .jalr_pc_src (jalr_pc_src),
    .alu_op (alu_op),
    .funct3 (funct3)
);

alu_decoder alu_decoder (
    .op5 (op[5]),
    .funct3 (funct3),
    .funct7 (funct7),
    .alu_op (alu_op),
    .alu_control (alu_ctrl)
);

sign_extend sign_extend (
    .instr31_20 (instr[31:20]),
    .instr11_7 (instr[11:7]),
    .instr19_12(instr[19:12]),
    .imm_src (imm_src),
    .imm_ext (imm_op)
);

endmodule
