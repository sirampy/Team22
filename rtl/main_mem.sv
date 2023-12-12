module main_mem # (
    
    parameter ACTUAL_ADDRESS_WIDTH = 16 // IF MODIFYING THIS, MODIFY convert_address FUNCTION BELOW

) (

    input  clock    i_clk,    // Clock
    input  data_val i_addr,   // Target address
    input  logic    i_wr_en,  // Write enable
    input  data_val i_wr_val, // Value to write

    output data_val o_val     // Value at address

);

byte mem_bytes [ 2 ** ACTUAL_ADDRESS_WIDTH - 1 : 0 ];

// The following is done to fix bit length errors
function logic [ ACTUAL_ADDRESS_WIDTH - 1 : 0 ] convert_address ( input data_val in );
    convert_address = in [ 31 : 16 ] + in [ 15 : 0 ]; // Addition performed to remove errors involving unused bits
endfunction


initial begin
        $display( "Loading main memory" );
        $readmemh( "test2.mem", mem_bytes ); // Choose correct .mem location here
end


always_ff @( posedge i_clk )
    if ( i_wr_en )
    begin
        mem_bytes [ convert_address( i_addr ) + 3 ] <= i_wr_val [ 31 : 24 ]; // Little endian
        mem_bytes [ convert_address( i_addr ) + 2 ] <= i_wr_val [ 23 : 16 ];
        mem_bytes [ convert_address( i_addr ) + 1 ] <= i_wr_val [ 15 : 8 ];
        mem_bytes [ convert_address( i_addr ) ] <= i_wr_val [ 7 : 0 ];
    end

assign o_val = { mem_bytes [ convert_address( i_addr ) + 3 ], // Little endian
                 mem_bytes [ convert_address( i_addr ) + 2 ],
                 mem_bytes [ convert_address( i_addr ) + 1 ],
                 mem_bytes [ convert_address( i_addr ) ] };

endmodule
