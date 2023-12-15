module pl2_exec (

    input  clock    i_clk,
    input  data_val i_alu_opnd_1,
    input  data_val i_alu_opnd_2,
    input  alu_optr i_alu_optr_val,
    input  logic    i_alu_use_optr,
    input  data_val i_alu_alt_out_val,
    input  reg_addr i_ff_addr,
    input  logic    i_funct3_0,

    output data_val o_alu_out_val,
    output reg_addr o_ff_addr,
    output data_val o_ff_val,
    output data_val o_ff_alu_out_val,
    output logic    o_funct3_2XOR0

);

data_val alu_out_val;

assign alu_out_val    = i_alu_use_optr ? o_ff_alu_out_val : i_alu_alt_out_val;
assign o_ff_addr      = i_ff_addr;
assign o_ff_val       = alu_out_val;
assign o_funct3_2XOR0 = i_funct3_0 ^ i_alu_optr_val [ 1 ]; // For B-type, alu_optr [ 1 : 0 ] = funct3 [ 2 : 1 ]

always_ff @( posedge i_clk )
    o_alu_out_val  <= alu_out_val;

alu alu_ (

    .i_opnd1 ( i_alu_opnd_1 ),
    .i_opnd2 ( i_alu_opnd_2 ),
    .i_optr  ( i_alu_optr_val ),
    
    .o_out   ( o_ff_alu_out_val )

);

endmodule
