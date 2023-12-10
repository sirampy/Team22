module control_top #(
    parameter INSTR_WIDTH = 32,
    parameter REG_ADDR_WIDTH = 5
)(
    input  logic [6:0]    op_i,                    
    input  logic [2:0]    funct3_i,                
    input  logic          funct7_i,          
    input  logic [31:0]   pc_i,           // program counter            
    input  logic          eq_i,           // equal/zero flag

// control output signals
    output logic          pc_src_o,       // control signal for JAL and branch
    output logic          result_src_o,   // select write input
    output logic          mem_write_o,    // memory write enable
    output logic          alu_src_o,      // select rd2 or imm
    output logic          reg_write_o,    // register write enable
    output logic          jalr_pc_src_o,  //control signal for JALR
    output logic [3:0]    alu_ctrl_o,     // input to alu                       
    output logic [31:0]   imm_op_o,       //sign extended imm
    output logic [1:0]    imm_src_o,
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
    .a (pc_i),
    .rd (instr)
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
    .jalr_pc_src_o (jalr_pc_src_o),
    .alu_op_o (alu_op),
    .funct3_i (funct3_i)
);

alu_decoder alu_decoder (
    .op5_i (op_i[5]),
    .funct3_i (funct3_i),
    .funct7_i (funct7_i),
    .alu_op_i (alu_op),
    .alu_control_o (alu_ctrl_o)
);

sign_extend sign_extend (
    .instr31_20 (instr[31:20]),
    .instr11_7 (instr[11:7]),
    .instr19_12(instr[19:12]),
    .imm_src (imm_src_o),
    .imm_ext (imm_op_o)
);

endmodule
