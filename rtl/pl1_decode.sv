module pl1_decode (

    input  clock           i_clk,
    input  instr_val       i_pc_val,
    input  instr           i_cur_instr_val,
    input  data_val        i_ff_val_2,
    input  reg_addr        i_ff_addr_2,
    input  data_val        i_ff_val_3,
    input  reg_addr        i_ff_addr_3,
    input  data_val        i_ff_val_4,
    input  reg_addr        i_ff_addr_4,
    input  logic           i_reg_wr_en,
    input  reg_addr        i_reg_wr_addr,
    input  data_val        i_reg_wr_val,

    output data_val        o_alu_opnd_1,
    output data_val        o_alu_opnd_2,
    output alu_optr        o_alu_optr_val,
    output logic           o_alu_use_optr,
    output data_val        o_alu_alt_out_val,
    output logic           o_reg_wr_en,
    output reg_addr        o_reg_wr_addr,
    output pl0_stall_state o_pl0_stall_state_val,
    output logic           o_mem_wr_en,
    output data_val        o_mem_wr_val,
    output logic           o_mem_rd_en,
    output l_s_sel         o_l_s_sel_val,
    output logic           o_funct3_0,
    output data_val        o_ff_val_1

);

data_val        reg_rd_val_1, reg_rd_val_2, reg_val_1, reg_val_2, alu_opnd_1, alu_opnd_2, imm_val, mem_wr_val, alu_alt_out_val;
reg_addr        reg_rd_addr_1, reg_rd_addr_2, reg_wr_addr;
logic           reg_wr_en, mem_wr_en, mem_rd_en, funct3_0, was_l, l_error, stall, stall_dec, stall_dec_d1, alu_use_optr, prev_stall;
alu_opnd_1_sel  alu_opnd_1_sel_val;
alu_opnd_2_sel  alu_opnd_2_sel_val;
alu_optr        alu_optr_val;
l_s_sel         l_s_sel_val;
pl0_stall_state pl0_stall_state_val;

assign reg_rd_addr_1 = cur_instr_val.body.R.rs1;
assign reg_rd_addr_2 = cur_instr_val.body.R.rs2;
assign l_s_sel_val   = cur_instr_val.body.R.funct3;
assign reg_wr_addr   = cur_instr_val.body.R.rd;
assign mem_wr_val    = reg_val_2;
assign o_pl0_stall_state_val  = stall == 0 ? ( l_error == 0 ? pl0_stall_state_val : PL0_STALL_1 ) : 0;
assign funct3_0      = cur_instr_val.body.R.funct3 [ 0 ];
assign stall         = ( l_error || stall_dec ) && !prev_stall;
assign o_ff_val_1      = imm_val;

always_ff @( posedge i_clk )
begin
    o_alu_opnd_1      <= alu_opnd_1;
    o_alu_opnd_2      <= alu_opnd_2;
    o_alu_optr_val    <= alu_optr_val;
    o_alu_use_optr    <= stall == 0 ? alu_use_optr : 0;
    o_alu_alt_out_val <= stall == 0 ? alu_alt_out_val : 0;
    o_reg_wr_en       <= stall == 0 ? reg_wr_en : 0;
    o_reg_wr_addr     <= ( ( stall == 0 ) && ( reg_wr_en == 1 ) ) ? reg_wr_addr : 0;
    o_mem_wr_en       <= stall == 0 ? mem_wr_en : 0;
    o_mem_wr_val      <= mem_wr_val;
    o_mem_rd_en       <= stall == 0 ? mem_rd_en : 0;
    o_l_s_sel_val     <= l_s_sel_val;
    o_funct3_0        <= funct3_0;
    stall_dec         <= stall_dec_d1;
    was_l             <= cur_instr_val.opc == OPC_L ? 1 : 0;
    prev_stall        <= stall;
end

always_comb
    if ( reg_rd_addr_1 != 0 )
    begin
        if ( reg_rd_addr_1 == i_ff_addr_2 )
            reg_val_1 = i_ff_val_2;
        else if ( reg_rd_addr_1 == i_ff_addr_3 )
            reg_val_1 = i_ff_val_3;
        else if ( reg_rd_addr_1 == i_ff_addr_4 )
            reg_val_1 = i_ff_val_4;
        else
            reg_val_1 = reg_rd_val_1;
    end
    else
        reg_val_1 = 0;

always_comb
    if ( reg_rd_addr_2 != 0 )
    begin
        if ( reg_rd_addr_2 == i_ff_addr_2 )
            reg_val_2 = i_ff_val_2;
        else if ( reg_rd_addr_2 == i_ff_addr_3 )
            reg_val_2 = i_ff_val_3;
        else if ( reg_rd_addr_2 == i_ff_addr_4 )
            reg_val_2 = i_ff_val_4;
        else
            reg_val_2 = reg_rd_val_2;
    end
    else
        reg_val_2 = 0;

always_comb
    case ( alu_opnd_1_sel_val )
        ALU_OPND_1_REG:
            alu_opnd_1 = reg_val_1;
        ALU_OPND_1_PC:
            alu_opnd_1 = i_pc_val;
    endcase

always_comb
    case ( alu_opnd_2_sel_val )
        ALU_OPND_2_REG:
            alu_opnd_2 = reg_val_2;
        ALU_OPND_2_IMM:
            alu_opnd_2 = imm_val;
    endcase

always_comb
    if ( was_l == 1 )
        if ( ( alu_opnd_1_sel_val == ALU_OPND_1_REG ) && ( reg_wr_addr == reg_rd_addr_1 ) && ( reg_wr_en == 1 ) )
            l_error = 1;
        else if ( ( alu_opnd_2_sel_val == ALU_OPND_2_REG ) && ( reg_wr_addr == reg_rd_addr_2 ) && ( reg_wr_en == 1 ) )
            l_error = 1;
        else
            l_error = 0;
    else
        l_error = 0;

decoder decoder_ (

    .i_cur_instr_val       ( i_cur_instr_val ),
    .i_pc_val              ( i_pc_val ),

    .o_pl0_stall_state_val ( pl0_stall_state_val ),
    .o_reg_wr_en           ( reg_wr_en ),
    .o_alu_opnd_1_sel_val  ( alu_opnd_1_sel_val ),
    .o_alu_opnd_2_sel_val  ( alu_opnd_2_sel_val ),
    .o_alu_optr_val        ( alu_optr_val ),
    .o_alu_use_optr        ( alu_use_optr ),
    .o_alu_alt_out_val     ( alu_alt_out_val ),
    .o_mem_wr_en           ( mem_wr_en ),
    .o_mem_rd_en           ( mem_rd_en ),
    .o_imm_val             ( imm_val ),
    .o_stall               ( stall_dec_d1 )

);

regs regs_ (

    .i_clk       ( i_clk ),
    .i_rd_addr_1 ( reg_rd_addr_1 ),
    .i_rd_addr_2 ( reg_rd_addr_2 ),
    .i_wr_addr   ( i_reg_wr_addr ),
    .i_wr_en     ( i_reg_wr_en ),
    .i_wr_val    ( i_reg_wr_val ),

    .o_val_1     ( reg_rd_val_1 ),
    .o_val_2     ( reg_rd_val_2 )

);

endmodule
