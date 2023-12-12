module pc_mux #(

    parameter PC_WIDTH = 32

) (

    input logic [ PC_WIDTH - 1 : 0 ] pc_i,          // Program counter
    input logic [ PC_WIDTH - 1 : 0 ] imm_op_i,      // Immediate value
    input logic                      pc_src_i,      // [0] - Increment PC as usual, [1] - Write imm to PC
    input logic [ PC_WIDTH - 1 : 0 ] pc_jalr_i,     // PC from JALR register
    input logic                      jalr_pc_src_i, // [1] Write JALR register to PC, [0] Otherwise

    output logic [PC_WIDTH-1:0]      next_pc_o,      // Next PC value
    output logic [PC_WIDTH-1:0]      pc_plus4_o       //pc+4 output to write into reg_file.sv

);

logic [ PC_WIDTH - 1 : 0 ] jal_branch_pc; // Program counter incremented by immediate value

assign jal_branch_pc = pc_i + imm_op_i;
assign pc_plus4_o = pc_i + 4;
assign next_pc_o = jalr_pc_src_i ? pc_jalr_i : (pc_src_i ? jal_branch_pc : pc_plus4_o);

endmodule
