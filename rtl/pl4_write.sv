module pl4_write (

    input  clock      i_clk,
    input  data_val   i_reg_wr_val,
    input  reg_addr   i_reg_wr_addr,
    input  logic      i_reg_wr_en,

    output logic      o_reg_wr_en,
    output reg_addr   o_ff_addr,
    output data_val   o_ff_val

);

logic    reg_wr_en_d1;

assign o_ff_val  = i_reg_wr_val;

always_ff @( posedge i_clk )
begin
    o_ff_addr <= i_reg_wr_addr;
    o_reg_wr_en    <= reg_wr_en_d1;
    reg_wr_en_d1   <= i_reg_wr_en;
end

endmodule
