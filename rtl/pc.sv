module pc (

    input  clock     i_clk,    // Clock
    input  instr_val i_wr_val, // Write value

    output instr     o_val     // Current instruction

);

instr pc_mem;

always_ff @( posedge i_clk )
    pc_mem <= i_wr_val;

assign o_val = pc_mem;

endmodule
