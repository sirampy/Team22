module instr_mem #(
    
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
   // parameter ACTUAL_ADDRESS_WIDTH = 16 // Needed to prevent errors involved with making array of size 2 ** 32
                                        // We just take it as 2 ** 16, as that works in the scope of the lab
)(

    input logic [ ADDRESS_WIDTH - 1 : 0 ] addr_i, // Address to read from

    output logic [ DATA_WIDTH - 1 : 0 ]   rd_o    // Value at address

);
    logic [7:0]  rom_array [32'hBFC00FFF : 32'hBFC00000];


    initial begin 
        $display ("Loading rom.");  
        $readmemh("./rom_bin/program.mem", rom_array);
    end;

    always_comb begin 
    rd_o = {rom_array[(addr_i + 3)],rom_array[(addr_i + 2) ],rom_array[(addr_i+ 1) ],rom_array[addr_i ]}; 
    end

endmodule
