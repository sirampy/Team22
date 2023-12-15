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

data_val        mem_wr_val_d1, mem_rd_val_full, mem_rd_val;
logic           mem_wr_en_d1, mem_rd_en_d1;
l_s_sel         l_s_sel_val_d1;

data_val alu_out_reg;

assign o_ff_val = mem_rd_val;

always_ff @( posedge i_clk )
begin
    mem_wr_val_d1  <= i_mem_wr_val;
    mem_wr_en_d1   <= i_mem_wr_en;
    mem_rd_en_d1   <= i_mem_rd_en;
    l_s_sel_val_d1 <= i_l_s_sel_val;
    o_ff_addr      <= i_ff_addr;
    alu_out_reg    <= i_alu_out_val;
end
always_comb
    o_mem_rd_val    = mem_rd_val; // mem_rd_val is driven by async logic in main_mem_

always_comb
    if ( mem_rd_en_d1 ) // selecting the byted to write to is done in teh memory iteslf
        mem_rd_val = mem_rd_val_full;
    else
        mem_rd_val = alu_out_reg;

main_mem main_mem_ (

    .i_clk    ( i_clk ),
    .i_addr   ( i_alu_out_val ),
    .i_wr_en  ( mem_wr_en_d1 ),
    .i_wr_val ( mem_wr_val_d1 ),
    .i_wr_type_sync( i_l_s_sel_val ),
    .i_wr_type_async( l_s_sel_val_d1 ),

    .o_val    ( mem_rd_val_full )

);

endmodule
