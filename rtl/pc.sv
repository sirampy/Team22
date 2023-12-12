module pc (

    input  clock     i_clk,        // Clock
    input  instr_val i_pc_val_inc, // Incremented value of PC
    input  data_val  i_imm_val,    // Immediate value
    input  data_val  i_reg_val,    // Register value
    input  pc_sel    i_sel,        // Operation select

    output instr_val o_pc_val      // Current PC value

);

always_ff @( posedge i_clk )
    case ( i_sel )
    PC_RST:
        o_pc_val <= 0;
    PC_INCR:
        o_pc_val <= i_pc_val_inc;
    PC_IMM_OFFSET:
        o_pc_val <= o_pc_val + data_val_to_instr_val(i_imm_val);
    PC_ALU_OUT:
        o_pc_val <= data_val_to_instr_val(i_reg_val) + data_val_to_instr_val(i_imm_val);
    endcase

endmodule
