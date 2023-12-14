module data_memory # (
    
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter STORE_WIDTH = 8   

) (

    input logic                           clk_i,          // Clock
    input logic [ ADDRESS_WIDTH - 1 : 0 ] address_i,      // Target address
    input logic                           write_enable_i, // Write enable
    input logic [ DATA_WIDTH - 1 : 0 ]    write_data_i,  // Value to write

    input logic [ 1 : 0 ]                 mem_type_i,       // [0] - word, [1] - byte, [2] - half
    input logic                           mem_sign_i,       // [0] - unsigned, [1] - signed

    output logic [ DATA_WIDTH - 1 : 0]    read_value_o    // Value read at address

);

    logic [STORE_WIDTH-1:0] ram_array [32'h0001FFFF : 32'h00000000];
    

    initial begin 
        $display  ("Loading ram.");
        $readmemh("./rom_bin/data.mem", ram_array);
        $display ("ram loaded fully");
    end;

    /* verilator lint_off UNUSED */
    logic [ ADDRESS_WIDTH - 1 : 0 ] address;
    /* verilator lint_on UNUSED */

    always_comb begin
        case (mem_type_i)
            2'b01: // byte
                case (mem_sign_i)
                    1'b0: address = {{24{1'b0}}, ram_array[address_i]}; // zero ext
                    1'b1: address = {{24{ram_array[address_i][7]}}, ram_array[address_i]}; // signed
                endcase   
            2'b10: // half
                case (mem_sign_i)
                    1'b0: address = {{16{1'b0}},  {ram_array[address_i]}, {ram_array[address_i+1]}}; // zero ext
                    1'b1: address = {{16{ram_array[address_i][7]}},  {ram_array[address_i]}, {ram_array[address_i+1]}}; // signed
                endcase
            default: address = address_i; // word
        endcase 
    end

    assign read_value_o = {ram_array[{address[31:2], 2'b00}], 
                            ram_array[{address[31:2], 2'b00}+1], 
                            ram_array[{address[31:2], 2'b00}+2], 
                            ram_array[{address[31:2], 2'b00}+3]};


    always_ff @(posedge clk_i) begin
        if (write_enable_i) begin
            ram_array[{address[31:2], 2'b00}]   <= write_data_i[31:24];      
            ram_array[{address[31:2], 2'b00}+1] <= write_data_i[23:16];
            ram_array[{address[31:2], 2'b00}+2] <= write_data_i[15:8];
            ram_array[{address[31:2], 2'b00}+3] <= write_data_i[7:0];
        end
    end 

endmodule
