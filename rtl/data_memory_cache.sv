module data_memory_cache # (
 //   parameter ACTUAL_ADDRESS_WIDTH = 16,
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
    output logic [DATA_WIDTH-1:0] read_value_o
);

    // Declare cache signals separately
    logic [DATA_WIDTH-1:0] cache_data [2**SET_WIDTH-1:0];
    logic [TAG_WIDTH-1:0] cache_tag [2**SET_WIDTH-1:0];
    logic cache_valid [2**SET_WIDTH-1:0];

    logic [7:0] memory_bytes [32'h1FFFF:32'h0];

    logic [SET_WIDTH-1:0] index;
    logic [TAG_WIDTH-1:0] tag;
    logic hit;

    assign index = address_i[SET_WIDTH+BYTE_OFFSET_WIDTH-1:BYTE_OFFSET_WIDTH];
    assign tag = address_i[ADDRESS_WIDTH-1:ADDRESS_WIDTH-TAG_WIDTH];

    always_ff @(posedge clk_i) begin
        // Check for a cache hit
        hit <= cache_valid[index] && (cache_tag[index] == tag);
        if (write_enable_i) begin
            memory_bytes[address_i + 3] <= write_value_i[31:24];
            memory_bytes[address_i + 2] <= write_value_i[23:16];
            memory_bytes[address_i + 1] <= write_value_i[15:8];
            memory_bytes[address_i] <= write_value_i[7:0];

            // Update cache on a hit
            if (hit) begin
                cache_data[index] <= write_value_i;
                cache_tag[index] <= tag; // Update the tag in case it's a new word
                // cache_valid bit does not need to change since it's already 1 for a hit
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
                    memory_bytes[address_i + 3],
                    memory_bytes[address_i+ 2],
                    memory_bytes[address_i + 1],
                    memory_bytes[address_i]
                };
                read_value_o <= cache_data[index];
            end
        end
    end

endmodule
