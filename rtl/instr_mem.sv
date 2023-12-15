module instr_mem #(
    
    parameter ACTUAL_ADDRESS_WIDTH = 16 // IF MODIFYING THIS, MODIFY convert_address FUNCTION BELOW

) (

    input  instr_val i_addr, // Read address

    output instr     o_val   // Value at address

);

byte instr_bytes [ ( 2 ** ACTUAL_ADDRESS_WIDTH ) - 1 : 0 ];

// The following is done to fix bit length errors
function logic [ ACTUAL_ADDRESS_WIDTH - 1 : 0 ] convert_address ( input logic [ 31 : 0 ] in );
    convert_address = in [ 31 : 16 ] + in [ 15 : 0 ]; // Addition performed to remove errors involving unused bits
endfunction

initial begin
        $display( "Loading instructions into ROM." );
        $readmemh( "test.mem", instr_bytes ); // Choose correct .mem location here
end;


assign o_val = { instr_bytes [ convert_address( i_addr ) ], // Big endian, works better with hand-written files
                 instr_bytes [ convert_address( i_addr ) + 1 ],
                 instr_bytes [ convert_address( i_addr ) + 2 ],
                 instr_bytes [ convert_address( i_addr ) + 3 ] };

/*
assign o_val = { instr_bytes [ convert_address( i_addr ) + 3], // Little endian, used by assembler
                 instr_bytes [ convert_address( i_addr ) + 2 ],
                 instr_bytes [ convert_address( i_addr ) + 1 ],
                 instr_bytes [ convert_address( i_addr ) ] };
*/

endmodule
