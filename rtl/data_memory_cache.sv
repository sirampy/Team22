module data_memory_cache # (
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input logic                           clk_i,          // Clock
    input logic [ ADDRESS_WIDTH - 1 : 0 ] address_i,      // Target address
    input logic                           write_enable_i, // Write enable
    input logic [ DATA_WIDTH - 1 : 0 ]    write_value_i,   // Value to write
    output logic [ DATA_WIDTH - 1 : 0]    read_value_o    // Value read at address
);

    logic [7:0] ram_array [32'h0001FFFF : 32'h00000000];
    // Cache structure
    typedef struct packed {
        logic valid;
        logic [26:0] tag;
        logic [31:0] data;
    } cache_entry_t;

    cache_entry_t cache [7:0];

    // Initialize RAM and Cache
    initial begin 
        //$display("Loading ram.");
        //$readmemh("", ram_array);
        //$display("ram loaded fully");

        // Initialize cache
        for (int i = 0; i < 8; i++) begin
            cache[i].valid = 0;
            cache[i].tag = 0;
            cache[i].data = 0;
        end
    end

    logic [2:0] cache_index; // Cache index
    logic [26:0] tag;        // Tag

    always_ff @(posedge clk_i) begin
        cache_index <= address_i[4:2]; // Cache index derived from address
        tag <= address_i[31:5];        // Tag derived from address

        if (write_enable_i) begin
            // Write logic
            ram_array[{address_i[31:2], 2'b0}]   <= write_value_i[31:24];      
            ram_array[{address_i[31:2], 2'b0}+1] <= write_value_i[23:16];
            ram_array[{address_i[31:2], 2'b0}+2] <= write_value_i[15:8];
            ram_array[{address_i[31:2], 2'b0}+3] <= write_value_i[7:0];
        end else begin
            if (cache[cache_index].valid && cache[cache_index].tag == tag) begin
                // Cache hit
                read_value_o <= cache[cache_index].data;
            end else begin
                // Cache miss
                logic [31:0] data;
                data <= {ram_array[{address_i[31:2], 2'b0}], 
                        ram_array[{address_i[31:2], 2'b0}+1], 
                        ram_array[{address_i[31:2], 2'b0}+2], 
                        ram_array[{address_i[31:2], 2'b0}+3]};
                read_value_o <= data;

                // Update cache
                cache[cache_index].valid <= 1;
                cache[cache_index].tag <= tag;
                cache[cache_index].data <= data;
            end
        end
    end 

endmodule
