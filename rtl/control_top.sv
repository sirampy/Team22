module control_top #(

    parameter INSTR_WIDTH = 32,
    parameter REG_ADDR_WIDTH = 5

) (

    input  logic [ 6 : 0 ]  op_i,                               // Note: Delete. We have instruction already.
    input  logic [ 2 : 0 ]  funct3_i,                           // Note: Delete. We have instruction already.
    input  logic            funct7_i,                           // Note: Delete. We have instruction already.
    input  logic [ 31 : 0 ] pc_i,                          // Program counter
    input  logic            eq_i,                          // Equal/zero flag

    output logic                            pc_src_o,      // [0] - Let PC increment, [1] - Set PC to new value
    output logic                            result_src_o,  // [0] - Write ALU output to register, [1] - Write memory value to register
    output logic                            mem_write_o,   // Memory write enable
    output logic                            alu_src_o,     // [0] - Use rs2 as ALU input, [1] - Use imm_op as ALU input
    output logic                            reg_write_o,   // Register write enable
    output logic                            jalr_pc_src_o, // [0] - ?, [1] - ?
    output logic [ 3 : 0 ]                  alu_ctrl_o,    // ALU operation select
    output logic [ 31 : 0 ]                 imm_op_o,      // Immediate value
    output logic [ INSTR_WIDTH - 1 : 0 ]    instr_o,       // Current instruction to execute 
    output logic [ REG_ADDR_WIDTH - 1 : 0 ] rs1_o,              // ALU operand register address 1
    output logic [ REG_ADDR_WIDTH - 1 : 0 ] rs2_o,              // ALU operand register address 2
    output logic [ REG_ADDR_WIDTH - 1 : 0 ] rd_o                // Register write address

);

logic [ 1 : 0 ] alu_op;  // [00] - LW/SW, [01] - B-type, [10] - Mathematical expression (R-type or I-type)
logic [ 1 : 0 ] imm_src; // Immediate value type


assign rs1 = instr_o [ 19 : 15 ];      // Move to top
assign rs2 = instr_o [ 24 : 20 ];      // Move to top
assign rd = instr_o [ 11 : 7 ];        // Move to top

instr_mem instr_mem (

    .addr_i (pc_i),
    .rd_o   (instr_o)

);

main_decoder main_decoder (

    .eq_i (eq_i),
    .op_i (op_i),
    .funct3_i (funct3_i)

    .pc_src_o (pc_src_o),
    .result_src_o (result_src_o),
    .mem_write_o (mem_write_o),
    .alu_src_o (alu_src_o),
    .imm_src_o (imm_src),
    .reg_write_o (reg_write_o),
    .jalr_pc_src_o (jalr_pc_src_o),
    .alu_op_o (alu_op),

);

alu_decoder alu_decoder (

    .op5_i (op_i[5]),
    .funct3_i (funct3_i),
    .funct7_i (funct7_i),
    .alu_op_i (alu_op),

    .alu_control_o (alu_ctrl_o)

);

sign_extend sign_extend (

    .instr31_7_i ( instr[ 31 : 7 ] ),
    .imm_src_i   ( imm_src ),
    
    .imm_ext_o   ( imm_op_o )

);

endmodule
