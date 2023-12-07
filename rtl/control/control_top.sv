module control_top (

    input logic [6:0]    op_i,
    input logic [2:0]    funct3_i,
    input logic          funct7_i,

// control output signals
    output logic [1:0]   result_src_o,    // select write input - NOTE: decoder currently only 1 bit, change
    output logic         mem_write_o,     // memory write enable
    output logic         alu_src_o,       // select rd2 or imm
    output logic         reg_write_o,     // register write enable
    output logic [2:0]   alu_ctrl_o,      // input to alu
    output logic [1:0]   imm_src_o,
    output logic [1:0]   jump_o, // not yet set up
    output logic         branch_o
);

    logic [1:0]          alu_op;   // select alu operation

    main_decoder main_decoder (
       // .eq_i (eq_i),
        .op_i (op_i),
       // .pc_src_o (pc_src_o),
        .result_src_o (result_src_o),
        .mem_write_o (mem_write_o),
        .alu_src_o (alu_src_o),
        .imm_src_o (imm_src_o),
        .reg_write_o (reg_write_o),
        .alu_op_o (alu_op),
        .branch_o (branch_o),
        .jump_o(jump_o)
    );

    alu_decoder alu_decoder (
        .op5_i (op_i[5]),
        .funct3_i (funct3_i),
        .funct7_i (funct7_i),
        .alu_op_i (alu_op),
        .alu_control_o (alu_ctrl_o)
    );

endmodule
