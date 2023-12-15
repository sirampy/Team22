module data_memory # (
    
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter STORE_WIDTH = 8   

) (

    input logic                           clk_i,          // Clock
    /* verilator lint_off UNUSED */
    input logic [ ADDRESS_WIDTH - 1 : 0 ] address_i,      // Target address
    /* verilator lint_on UNUSED */
    input logic                           write_enable_i, // Write enable
    input logic [ DATA_WIDTH - 1 : 0 ]    write_data_i,  // Value to write

    input logic                           mem_type_i,       // [0] - word, [1] - byte
    input logic                           mem_sign_i,       // [0] - unsigned, [1] - signed

    output logic [ DATA_WIDTH - 1 : 0]    read_value_o    // Value read at address

);

    logic [STORE_WIDTH-1:0] ram_array [32'h0001FFFF : 32'h00000000];
    

    initial begin 
        $display  ("Loading ram.");
        $readmemh("./rom_bin/data.mem", ram_array);
        $display ("ram loaded fully");
    end;

    logic [ DATA_WIDTH - 1 : 0]    read_value;

    assign read_value = {ram_array[{address_i[31:2], 2'b00}], 
                            ram_array[{address_i[31:2], 2'b00}+1], 
                            ram_array[{address_i[31:2], 2'b00}+2], 
                            ram_array[{address_i[31:2], 2'b00}+3]};

    always_comb begin
        case (mem_type_i)
            1'b1: // byte
                case (mem_sign_i)
                    1'b0: read_value_o = {24'b0, read_value[7:0]}; // zero ext
                    1'b1: read_value_o = {{24{read_value[7]}}, read_value[7:0]}; // sign ext
                endcase   
            1'b0: read_value_o = read_value; // word
            default: read_value_o = read_value;
        endcase 
    end

    always_ff @(posedge clk_i) begin
        if (write_enable_i) begin
            ram_array[address[31:0]]   <= write_data_i[31:24];      
            ram_array[address[31:0]+1] <= write_data_i[23:16];
            ram_array[address[31:0]+2] <= write_data_i[15:8]; 
            ram_array[address[31:0]+3] <= write_data_i[7:0];
        end
    end 

endmodule
