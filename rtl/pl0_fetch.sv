module pl0_fetch (

    input  clock           i_clk,
    input  pl0_stall_state i_stall_state,
    input  logic           i_funct3_2XOR0,
    input  data_val        i_imm_val,
    input  data_val        i_alu_out_val,

    output instr           o_cur_instr_val,
    output instr_val       o_pc_val

);

instr_val       pc_wr_val;
logic           flg_z, use_imm_mem;
pc_sel          pc_sel_val;
pl0_stall_state stall_state, next_stall_state;
data_val        imm_val_mem;

assign flg_z    = i_alu_out_val == 0 ? 1 : 0;

always_ff @( posedge i_clk )
begin
    stall_state <= next_stall_state;
    imm_val_mem <= i_imm_val;
end

always_comb
    case ( i_stall_state == PL0_STALL_NONE ? stall_state : i_stall_state )
    PL0_STALL_NONE:
    begin
        next_stall_state = PL0_STALL_NONE;
        pc_sel_val       = PC_INCR;
        use_imm_mem      = 0;
    end
    PL0_STALL_IMM:
    begin
        next_stall_state = PL0_STALL_NONE;
        pc_sel_val       = PC_IMM_OFF;
        use_imm_mem      = 0;
    end
    PL0_STALL_BRANCH:
    begin
        next_stall_state = PL0_STALL_NONE;
        pc_sel_val       = flg_z ^ i_funct3_2XOR0
                           ? PC_IMM_OFF : PC_INCR;
        use_imm_mem      = 1;
    end
    PL0_STALL_1_BRANCH:
    begin
        next_stall_state = PL0_STALL_BRANCH;
        pc_sel_val       = PC_FREEZE;
        use_imm_mem      = 0;
    end
    PL0_STALL_ALU:
    begin
        next_stall_state = PL0_STALL_NONE;
        pc_sel_val       = PC_ALU_OUT;
        use_imm_mem      = 1;
    end
    PL0_STALL_1_ALU:
    begin
        next_stall_state = PL0_STALL_ALU;
        pc_sel_val       = PC_FREEZE;
        use_imm_mem      = 0;
    end
    PL0_STALL_1:
    begin
        next_stall_state = PL0_STALL_NONE;
        pc_sel_val       = PC_FREEZE;
        use_imm_mem      = 0;
    end
    default:
    begin
        next_stall_state = 0;
        pc_sel_val       = 0;
        use_imm_mem      = 0;
    end
    endcase

always_comb
    case ( pc_sel_val )
    PC_FREEZE:
        pc_wr_val = o_pc_val;
    PC_INCR:
        pc_wr_val = o_pc_val + 4;
    PC_IMM_OFF:
        pc_wr_val = use_imm_mem == 1
                    ? o_pc_val + data_val_to_instr_val ( imm_val_mem )
                    : o_pc_val + data_val_to_instr_val ( i_imm_val );
    PC_ALU_OUT:
        pc_wr_val = data_val_to_instr_val ( i_alu_out_val );
    endcase

pc pc_ (

    .i_clk    ( i_clk ),
    .i_wr_val ( pc_wr_val ), 

    .o_val    ( o_pc_val )
data_val
);

instr_mem instr_mem_ (

    .i_addr ( o_pc_val ),
    
    .o_val  ( o_cur_instr_val )

);

endmodule
