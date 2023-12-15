module reg_file #(

    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32

) (

    input                         clk_i, // Clock
    input [ ADDR_WIDTH - 1 : 0 ]  ad1_i, // Read address 1
    input [ ADDR_WIDTH - 1 : 0 ]  ad2_i, // Read address 2
    input [ ADDR_WIDTH - 1 : 0 ]  ad3_i, // Write address
    input                         we3_i, // Write enable
    input [ DATA_WIDTH - 1 : 0 ]  wd3_i, // Write data

    output [ DATA_WIDTH - 1 : 0 ] rd1_o, // Value at ad1
    output [ DATA_WIDTH - 1 : 0 ] rd2_o,  // Value at ad2
    output logic [DATA_WIDTH-1:0]   a0   

);

logic [ DATA_WIDTH - 1 : 0 ] reg_data [ 2 ** ADDR_WIDTH - 1 : 0 ];

assign reg_data [ 0 ] = { DATA_WIDTH { 1'b0 } }; // Zero register

always_ff @( posedge clk_i ) begin
    if ( we3_i ) begin
        reg_data [ ad3_i ] <= wd3_i;
    end 

end 

assign rd1_o = reg_data [ ad1_i ];
assign rd2_o = reg_data [ ad2_i ];
assign a0 = reg_data [ 15 ];
 

endmodule
