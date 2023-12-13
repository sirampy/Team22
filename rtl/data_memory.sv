module data_memory # (
    
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32

) (

    input logic                           clk_i,          // Clock
    input logic [ ADDRESS_WIDTH - 1 : 0 ] address_i,      // Target address
    input logic                           write_enable_i, // Write enable
    input logic [ DATA_WIDTH - 1 : 0 ]    write_data_i,  // Value to write
    output logic [ DATA_WIDTH - 1 : 0]    read_value_o    // Value read at address

);

logic [7:0] ram_array [32'h0001FFFF : 32'h00000000]
initial begin 
        $display  ("Loading ram.");
        $readmemh("", ram_array);
        $display ("ram loaded fully");
    end;
assign read_value_o = { ram_array[address_i[16:0] + 3],
                        ram_array[address_i[16:0] + 2],
                        ram_array[address_i[16:0] + 1],
                        ram_array[address_i[16:0]]};

 always_ff @(posedge clk_i) begin
        if (write_en_i) begin
            ram_array[address_i[16:0]] <= write_dataddress_i[7:0];
            ram_array[address_i[16:0] + 1] <= write_dataddress_i[15:8];
            ram_array[address_i[16:0] + 2] <= write_dataddress_i[23:16];
            ram_array[address_i[16:0] + 3] <= write_dataddress_i[31:24];

        end
    end 

endmodule