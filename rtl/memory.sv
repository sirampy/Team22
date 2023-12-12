module data_memory # (
    
    parameter ACTUAL_ADDRESS_WIDTH = 16, // IF MODIFYING THIS, MODIFY convert_address BELOW (LINE 23)
    
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32

) (

    input logic                           clk_i,          // Clock
    input logic [ ADDRESS_WIDTH - 1 : 0 ] address_i,      // Target address
    input logic                           write_enable_i, // Write enable
    input logic [ DATA_WIDTH - 1 : 0 ]    write_value_i,  // Value to write

    input logic [ 1 : 0 ]                 mem_type_i,       // [0] - word, [1] - byte, [2] - half
    input logic                           mem_sign_i,       // [0] - unsigned, [1] - signed

    output logic [ DATA_WIDTH - 1 : 0]    read_value_o    // Value read at address
    

);

logic [ 7 : 0 ] memory_bytes [ 2 ** ACTUAL_ADDRESS_WIDTH - 1 : 0 ];

// The following is done to fix bit length errors
function logic[ ACTUAL_ADDRESS_WIDTH - 1 : 0 ] convert_address (input logic[ ADDRESS_WIDTH - 1 : 0 ] in);
    convert_address = in [ 31 : 16 ] + in [ 15 : 0 ];
endfunction


initial begin
        $display("Loading main memory");
        $readmemh("./rom_bin/data.mem", memory_bytes); // Update to new file, if needed
end

logic [ ADDRESS_WIDTH - 1 : 0 ] address;

always_comb begin
    case (mem_type_i)
        2'b01: // byte
            case (mem_sign_i)
                1'b0: address = {{24{1'b0}},  {address_i[7:0]}};
                1'b1: address = {{24{address_i[7]}},  {address_i[7:0]}};
            endcase   
        2'b10: // half
            case (mem_sign_i)
                1'b0: address = {{16{1'b0}},  {address_i[15:0]}};
                1'b1: address = {{16{address_i[15]}},  {address_i[15:0]}};
            endcase
        default: address = address_i; // word
        endcase 
end




endmodule
