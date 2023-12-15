module main_mem # (
    
    parameter ACTUAL_ADDRESS_WIDTH = 16 // IF MODIFYING THIS, MODIFY convert_address FUNCTION BELOW

) (

    input  clock    i_clk,    // Clock
    input  data_val i_addr,   // Target address
    input  logic    i_wr_en,  // Write enable
    input  data_val i_wr_val, // Value to write
    input  l_s_sel  i_wr_type,          // type of write (read conversion is done outside the memory itself)

    output data_val o_val     // Value at address

);

byte mem_bytes [ 2 ** ACTUAL_ADDRESS_WIDTH - 1 : 0 ];

// The following is done to fix bit length errors
function logic [ ACTUAL_ADDRESS_WIDTH - 1 : 0 ] convert_address ( input data_val in );
    convert_address = in [ 31 : 16 ] + in [ 15 : 0 ]; // Addition performed to remove errors involving unused bits
endfunction


initial begin
        $display( "Loading main memory" );
        $readmemh( "rom_bin/data.mem", mem_bytes ); // Choose correct .mem location here
end

// write logic
always_ff @( posedge i_clk )
    if ( i_wr_en )
    begin
        case ( i_wr_type )
            L_S_BYTE:
            begin
                mem_bytes [ convert_address( i_addr ) ] <= i_wr_val [ 7 : 0 ];
            end
            L_S_HALF:
            begin
                mem_bytes [ convert_address( i_addr ) + 1 ] <= i_wr_val [ 15 : 8 ];
                mem_bytes [ convert_address( i_addr ) ] <= i_wr_val [ 7 : 0 ];
            end
            default: // covers L_S_WORD
            begin
                mem_bytes [ convert_address( i_addr ) + 3 ] <= i_wr_val [ 31 : 24 ]; // Little endian
                mem_bytes [ convert_address( i_addr ) + 2 ] <= i_wr_val [ 23 : 16 ];
                mem_bytes [ convert_address( i_addr ) + 1 ] <= i_wr_val [ 15 : 8 ];
                mem_bytes [ convert_address( i_addr ) ] <= i_wr_val [ 7 : 0 ];
            end
        endcase
    end

// read logic
assign o_val = { mem_bytes [ convert_address( i_addr ) + 3 ], // Little endian
                 mem_bytes [ convert_address( i_addr ) + 2 ],
                 mem_bytes [ convert_address( i_addr ) + 1 ],
                 mem_bytes [ convert_address( i_addr ) ] };

endmodule
