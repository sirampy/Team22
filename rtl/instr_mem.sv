module instr_mem #(
    
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter ACTUAL_ADDRESS_WIDTH = 16 // Needed to prevent errors involved with making array of size 2 ** 32
                                        // We just take it as 2 ** 16, as that works in the scope of the lab
) (

    input logic [ ADDRESS_WIDTH - 1 : 0 ] addr_i, // Address to read from

    output logic [ DATA_WIDTH - 1 : 0 ]   rd_o    // Value at address

);

function logic [ ACTUAL_ADDRESS_WIDTH - 1 : 0 ] convert_address ( input logic [ ADDRESS_WIDTH - 1 : 0 ] in );
    convert_address = in [ 31 : 16 ] + in [ 15 : 0 ]; // Addition is performed to prevent errors involving unused bits
endfunction

logic [ 7 : 0 ] byte_array [ ( 2 ** ACTUAL_ADDRESS_WIDTH ) - 1 : 0 ];


initial begin
        $display("Loading instructions into ROM.");
        $readmemh("rom_bin/program.mem", byte_array); // Choose correct .mem location
end;


assign rd_o = { byte_array[ convert_address( addr_i ) ], // Big endian, works better with file
                byte_array[ convert_address( addr_i ) + 1 ],
                byte_array[ convert_address( addr_i ) + 2 ],
                byte_array[ convert_address( addr_i ) + 3 ] };

endmodule
