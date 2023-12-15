module decoder (

    input  instr           i_cur_instr_val,       // Instruction to decode
    input  instr_val       i_pc_val,
    
    output pl0_stall_state o_pl0_stall_state_val, 
    output logic           o_reg_wr_en,           // Register write enable
    output alu_opnd_1_sel  o_alu_opnd_1_sel_val,  // Select ALU operand 1
    output alu_opnd_2_sel  o_alu_opnd_2_sel_val,  // Select ALU operand 2
    output alu_optr        o_alu_optr_val,        // Select ALU operator
    output logic           o_alu_use_optr,
    output data_val        o_alu_alt_out_val,
    output logic           o_mem_wr_en,           // Memory write enable
    output logic           o_mem_rd_en,           // Memory read enable
    output data_val        o_imm_val,             // Immediate value
    output logic           o_stall

);

typedef enum logic [ 2 : 0 ] {
    IMM_DECODER_I,
    IMM_DECODER_I_SHIFT,
    IMM_DECODER_S,
    IMM_DECODER_B,
    IMM_DECODER_U,
    IMM_DECODER_JAL
} imm_decoder_sel;

logic           funct7_5;
imm_decoder_sel imm_decoder_sel_val;

assign funct7_5    = i_cur_instr_val.body.R.funct7 [ 5 ];
assign o_mem_wr_en = i_cur_instr_val.opc == OPC_S ? 1 : 0;
assign o_mem_rd_en = i_cur_instr_val.opc == OPC_L ? 1 : 0;

always_comb
    case ( i_cur_instr_val.opc )
        OPC_L:
            begin
                imm_decoder_sel_val   = IMM_DECODER_I;
                o_pl0_stall_state_val = PL0_STALL_NONE;
                o_alu_opnd_1_sel_val  = ALU_OPND_1_REG;
                o_alu_opnd_2_sel_val  = ALU_OPND_2_IMM;
                o_alu_optr_val        = 4'b0000; // Has to be add
                o_alu_use_optr        = 1;
                o_alu_alt_out_val     = 0; // Don't care
                o_reg_wr_en           = 1;
                o_stall               = 0;
            end
        OPC_I:
            begin
                imm_decoder_sel_val   = i_cur_instr_val.body.R.funct3 == ALU_SLL
                                       || i_cur_instr_val.body.R.funct3 == ALU_SRL
                                       ? IMM_DECODER_I_SHIFT
                                       : IMM_DECODER_I;
                o_pl0_stall_state_val = PL0_STALL_NONE;
                o_alu_opnd_1_sel_val  = ALU_OPND_1_REG;
                o_alu_opnd_2_sel_val  = ALU_OPND_2_IMM;
                o_alu_optr_val        = { i_cur_instr_val.body.R.funct3 == ALU_SRL ? funct7_5 : 1'b0,
                                         i_cur_instr_val.body.R.funct3 };
                o_alu_use_optr        = 1;
                o_alu_alt_out_val     = 0; // Don't care
                o_reg_wr_en           = 1;
                o_stall               = 0;
            end
        OPC_S:
            begin
                imm_decoder_sel_val   = IMM_DECODER_S;
                o_pl0_stall_state_val = PL0_STALL_NONE;
                o_alu_opnd_1_sel_val  = ALU_OPND_1_REG;
                o_alu_opnd_2_sel_val  = ALU_OPND_2_IMM;
                o_alu_optr_val        = 4'b0000; // Has to be add
                o_alu_use_optr        = 1;
                o_alu_alt_out_val     = 0; // Don't care
                o_reg_wr_en           = 0;
                o_stall               = 0;
            end
        OPC_R:
            begin
                imm_decoder_sel_val   = 0; // Don't care
                o_pl0_stall_state_val = PL0_STALL_NONE;
                o_alu_opnd_1_sel_val  = ALU_OPND_1_REG;
                o_alu_opnd_2_sel_val  = ALU_OPND_2_REG;
                o_alu_optr_val        = { funct7_5, i_cur_instr_val.body.R.funct3 };
                o_alu_use_optr        = 1;
                o_alu_alt_out_val     = 0; // Don't care
                o_reg_wr_en           = 1;
                o_stall               = 0;
            end
        OPC_B:
            begin
                imm_decoder_sel_val   = IMM_DECODER_B;
                o_pl0_stall_state_val = PL0_STALL_1_BRANCH;
                o_alu_opnd_1_sel_val  = ALU_OPND_1_REG;
                o_alu_opnd_2_sel_val  = ALU_OPND_2_REG;
                o_alu_optr_val        = { 2'b10, i_cur_instr_val.body.R.funct3 [ 2 : 1 ] };
                o_alu_use_optr        = 0; // Don't care
                o_alu_alt_out_val     = 0; // Don't care
                o_reg_wr_en           = 0;
                o_stall               = 1;
            end
        OPC_AUIPC:
            begin
                imm_decoder_sel_val   = IMM_DECODER_U;
                o_pl0_stall_state_val = PL0_STALL_NONE;
                o_alu_opnd_1_sel_val  = ALU_OPND_1_PC;
                o_alu_opnd_2_sel_val  = ALU_OPND_2_IMM;
                o_alu_optr_val        = 4'b0000; // Has to be add
                o_alu_use_optr        = 1;
                o_alu_alt_out_val     = 0; // Don't care
                o_reg_wr_en           = 1;
                o_stall               = 0;
            end
        OPC_LUI:
            begin
                imm_decoder_sel_val   = IMM_DECODER_U;
                o_pl0_stall_state_val = PL0_STALL_NONE;
                o_alu_opnd_1_sel_val  = 0; // Don't care
                o_alu_opnd_2_sel_val  = 0; // Don't care
                o_alu_optr_val        = 0; // Don't care 
                o_alu_use_optr        = 0;
                o_alu_alt_out_val     = o_imm_val;
                o_reg_wr_en           = 1;
                o_stall               = 0;
            end
        OPC_JAL:
            begin
                imm_decoder_sel_val   = IMM_DECODER_JAL;
                o_pl0_stall_state_val = PL0_STALL_IMM;
                o_alu_opnd_1_sel_val  = 0; // Don't care
                o_alu_opnd_2_sel_val  = 0; // Don't care
                o_alu_optr_val        = 0; // Don't care
                o_alu_use_optr        = 0;
                o_alu_alt_out_val     = i_pc_val + 4;
                o_reg_wr_en           = 1;
                o_stall               = 0;
            end
        OPC_JALR:
            begin
                imm_decoder_sel_val   = IMM_DECODER_I;
                o_pl0_stall_state_val = PL0_STALL_1_ALU;
                o_alu_opnd_1_sel_val  = ALU_OPND_1_REG;
                o_alu_opnd_2_sel_val  = ALU_OPND_2_IMM;
                o_alu_optr_val        = 4'b0000; // Has to be add
                o_alu_use_optr        = 0;
                o_alu_alt_out_val     = i_pc_val + 4;
                o_reg_wr_en           = 1;
                o_stall               = 1;
            end
        default: // Should occur only when program finishes
            begin
                imm_decoder_sel_val   = 0;
                o_pl0_stall_state_val = PL0_STALL_NONE;
                o_alu_opnd_1_sel_val  = 0;
                o_alu_opnd_2_sel_val  = 0;
                o_alu_optr_val        = 0; 
                o_alu_use_optr        = 0;
                o_alu_alt_out_val     = 0;
                o_reg_wr_en           = 0;
                o_stall               = 0;
            end
    endcase

always_comb
    case ( imm_decoder_sel_val )
        IMM_DECODER_I:
            o_imm_val = { { 20 { i_cur_instr_val.body [ 24 ] } },
                          i_cur_instr_val.body.I.imm_11_0 };
        IMM_DECODER_I_SHIFT:
            o_imm_val = { { 27'h0000000 },
                          i_cur_instr_val.body.I.imm_11_0 [ 4 : 0 ] };
        IMM_DECODER_S:
            o_imm_val = { { 20 { i_cur_instr_val.body [ 24 ] } },
                          i_cur_instr_val.body.S.imm_11_5,
                          i_cur_instr_val.body.S.imm_4_0 };
        IMM_DECODER_B:
            o_imm_val = { { 19 { i_cur_instr_val.body [ 24 ] } },
                          i_cur_instr_val.body.B.imm_12,
                          i_cur_instr_val.body.B.imm_11,
                          i_cur_instr_val.body.B.imm_10_5,
                          i_cur_instr_val.body.B.imm_4_1,
                          1'h0 };
        IMM_DECODER_U:
            o_imm_val = { i_cur_instr_val.body.U.imm_31_12,
                          12'h00 };
        IMM_DECODER_JAL:
            o_imm_val = { { 12 { i_cur_instr_val.body [ 24 ] } },
                          i_cur_instr_val.body.JAL.imm_19_12,
                          i_cur_instr_val.body.JAL.imm_11,
                          i_cur_instr_val.body.JAL.imm_10_1,
                          1'h0 };
        default: o_imm_val = 0; // Should never occur
    endcase

endmodule
