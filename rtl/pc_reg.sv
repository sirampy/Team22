module pc_reg #(

    parameter PC_WIDTH = 32

) (

    input  logic                       clk_i,     // Clock
    input  logic                       rst_i,     // Reset
    input  logic [ PC_WIDTH - 1 : 0 ]  next_pc_i, // Write value for PC

    output logic [ PC_WIDTH - 1 : 0 ]  pc_o       // Current value of PC

);

always_ff @( posedge clk_i, posedge rst_i )
    if ( rst_i ) pc_o <= { PC_WIDTH { 1'b0 } };
    else pc_o <= next_pc_i;

endmodule
