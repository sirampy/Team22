module pl3_mem (

    input  clock    i_clk,
    input  data_val i_alu_out_val,
    input  logic    i_mem_wr_en,
    input  data_val i_mem_wr_val,
    input  logic    i_mem_rd_en,
    input  l_s_sel  i_l_s_sel_val,
    input  reg_addr i_ff_addr,
    
    output data_val o_mem_rd_val,
    output reg_addr o_ff_addr,
    output data_val o_ff_val

);

data_val        mem_wr_val, mem_wr_val_d1, mem_rd_val_full, mem_rd_val;
logic           mem_wr_en_d1, mem_rd_en_d1;
l_s_sel         l_s_sel_val_d1;

assign o_ff_val = mem_rd_val;

always_ff @( posedge i_clk )
begin
    mem_wr_val_d1  <= i_mem_wr_val;
    mem_wr_en_d1   <= i_mem_wr_en;
    mem_rd_en_d1   <= i_mem_rd_en;
    l_s_sel_val_d1 <= i_l_s_sel_val;
    o_mem_rd_val   <= mem_rd_val;
    o_ff_addr      <= i_ff_addr;
end

always_comb
    if ( mem_rd_en_d1 ) // selecting the byted to write to is done in teh memory iteslf
        case ( l_s_sel_val_d1 )
            L_S_BYTE:
                mem_rd_val = { { 24 { mem_rd_val_full [ 7 ] } }, mem_rd_val_full [ 7 : 0 ] };
            L_S_HALF:
                mem_rd_val = { { 16 { mem_rd_val_full [ 15 ] } }, mem_rd_val_full [ 15 : 0 ] };
            L_S_WORD:
                mem_rd_val = mem_rd_val_full;
            L_S_BYTE_U:
                mem_rd_val = { 24'h000000, mem_rd_val_full [ 7 : 0 ] };
            L_S_HALF_U:
                mem_rd_val = { 16'h0000, mem_rd_val_full [ 15 : 0 ] };
            default: mem_rd_val = 0;
        endcase
    else
        mem_rd_val = i_alu_out_val;

main_mem main_mem_ (

    .i_clk    ( i_clk ),
    .i_addr   ( i_alu_out_val ),
    .i_wr_en  ( mem_wr_en_d1 ),
    .i_wr_val ( mem_wr_val ),
    .i_wr_type( l_s_sel_val_d1),

    .o_val    ( mem_rd_val_full )

);

endmodule
