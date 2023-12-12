module regs #(

    parameter ADDR_WIDTH = 5

) (

    input  clock    i_clk,       // Clock
    input  reg_addr i_rd_addr_1, // Read address 1
    input  reg_addr i_rd_addr_2, // Read address 2
    input  reg_addr i_wr_addr,   // Write address
    input  logic    i_wr_en,     // Write enable
    input  data_val i_wr_val,    // Write value

    output data_val o_val_1,     // Value at address 1
    output data_val o_val_2      // Value at address 2

);

data_val reg_words [ ( 2 ** ADDR_WIDTH ) - 1 : 0 ];

assign reg_words [ 0 ] = 0; // Zero register

always_ff @( posedge i_clk )
    if ( i_wr_en ) reg_words [ i_wr_addr ] <= i_wr_val;

assign o_val_1 = reg_words [ i_rd_addr_1 ];
assign o_val_2 = reg_words [ i_rd_addr_2 ];

endmodule
