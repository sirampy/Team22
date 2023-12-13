module data_memory_cache # (
    parameter ACTUAL_ADDRESS_WIDTH = 16,
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter SET_WIDTH = 8,      // Width in bits of the index
    parameter BYTE_OFFSET_WIDTH = 2,
    parameter TAG_WIDTH = ADDRESS_WIDTH - SET_WIDTH - BYTE_OFFSET_WIDTH // Remaining bits for the tag
) (
    input logic clk_i,
    input logic [ADDRESS_WIDTH-1:0] address_i,
    input logic write_enable_i,
    input logic [DATA_WIDTH-1:0] write_value_i,
    output logic [DATA_WIDTH-1:0] read_value_o,
    output logic cache_hit_valid,
    output logic [TAG_WIDTH-1:0] cache_hit_tag,
    output logic [TAG_WIDTH-1:0] memory_address_tag

);


    // Cache structure
    logic [DATA_WIDTH-1:0] cache_data [2**SET_WIDTH-1:0];
    logic [TAG_WIDTH-1:0] cache_tag [2**SET_WIDTH-1:0];
    logic cache_valid [2**SET_WIDTH-1:0];

    logic [7:0] memory_bytes [2**ACTUAL_ADDRESS_WIDTH-1:0];

    // Function to convert 32-bit addresses to 16-bit addresses
    function logic[ ACTUAL_ADDRESS_WIDTH - 1 : 0 ] convert_address (input logic[ ADDRESS_WIDTH - 1 : 0 ] in);
        convert_address = in [ 31 : 16 ] + in [ 15 : 0 ];
    endfunction
    logic [SET_WIDTH-1:0] index;
    logic [TAG_WIDTH-1:0] tag;
    logic hit;


    assign index = address_i[SET_WIDTH+BYTE_OFFSET_WIDTH-1:BYTE_OFFSET_WIDTH];
    assign tag = address_i[ADDRESS_WIDTH-1:ADDRESS_WIDTH-TAG_WIDTH];

    always_ff @(posedge clk_i) begin
        // Extract the tag part of the memory address for GTKWave observation
        memory_address_tag <= tag;

        // Check for a cache hit
        hit <= cache_valid[index] && (cache_tag[index] == tag);
        // Update the cache hit signals for GTKWave observation
        cache_hit_valid <= cache_valid[index];
        cache_hit_tag <= cache_tag[index];

        if (write_enable_i) begin
            // Write to memory
            memory_bytes [ convert_address( address_i ) + 3 ] <= write_value_i [ 31 : 24 ]; // Little endian
            memory_bytes [ convert_address( address_i ) + 2 ] <= write_value_i [ 23 : 16 ];
            memory_bytes [ convert_address( address_i ) + 1 ] <= write_value_i [ 15 : 8 ];
            memory_bytes [ convert_address( address_i ) ] <= write_value_i [ 7 : 0 ];

            // Update cache on a hit
            if (hit) begin
                cache_data[index] <= write_value_i;
                cache_tag[index] <= tag;
                cache_valid[index] <= 1; // Ensure the valid bit is set
            end
        end else begin
            // Read from cache
            if (hit) begin
                // Cache hit
                read_value_o <= cache_data[index];
            end else begin
                // Cache miss - Load data from memory to cache
                cache_valid[index] <= 1;
                cache_tag[index] <= tag;
                cache_data[index] <= {
                    memory_bytes [ convert_address( address_i ) + 3 ],
                    memory_bytes [ convert_address( address_i ) + 2 ],
                    memory_bytes [ convert_address( address_i ) + 1 ],
                    memory_bytes [ convert_address( address_i ) ]
                };
                read_value_o <= cache_data[index];
            end
        end
    end
endmodule
