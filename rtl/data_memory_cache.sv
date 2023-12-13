
module data_memory_cache # (
    parameter ACTUAL_ADDRESS_WIDTH = 16,
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter CACHE_SIZE = 1024,
    parameter TAG_WIDTH = ADDRESS_WIDTH - $clog2(CACHE_SIZE) - $clog2(DATA_WIDTH/8)
) (
    input logic clk_i,
    input logic [ADDRESS_WIDTH-1:0] address_i,
    input logic write_enable_i,
    input logic [DATA_WIDTH-1:0] write_value_i,
    output logic [DATA_WIDTH-1:0] read_value_o
);

    typedef struct packed {
        logic valid;
        logic [TAG_WIDTH-1:0] tag;
        logic [DATA_WIDTH-1:0] data;
    } cache_line_t;

    logic [7:0] memory_bytes [2**ACTUAL_ADDRESS_WIDTH-1:0];
    cache_line_t cache [CACHE_SIZE-1:0];

    function logic [ACTUAL_ADDRESS_WIDTH-1:0] convert_address(input logic [ADDRESS_WIDTH-1:0] in);
        convert_address = in[31:16] + in[15:0];
    endfunction
    logic [$clog2(CACHE_SIZE)-1:0] index = address_i[$clog2(CACHE_SIZE) + $clog2(DATA_WIDTH/8) - 1:$clog2(DATA_WIDTH/8)];
    logic [TAG_WIDTH-1:0] tag = address_i[ADDRESS_WIDTH-1:$clog2(CACHE_SIZE) + $clog2(DATA_WIDTH/8)];
    logic hit;

    always_ff @(negedge clk_i) begin
        hit <= cache[index].valid && (cache[index].tag == tag);
        if (write_enable_i) begin
            // Write to memory
            memory_bytes[convert_address(address_i) + 3] <= write_value_i[31:24];
            memory_bytes[convert_address(address_i) + 2] <= write_value_i[23:16];
            memory_bytes[convert_address(address_i) + 1] <= write_value_i[15:8];
            memory_bytes[convert_address(address_i)] <= write_value_i[7:0];

            // Update cache
            if (hit) begin
                cache[index].data <= write_value_i;
            end
    end else begin
            // Read from cache
            if (hit) begin
                // Cache hit
                read_value_o <= cache[index].data;
            end else begin
                // Cache miss - Load data from memory to cache
                cache[index].valid <= 1;
                cache[index].tag <= tag;
                cache[index].data <= { memory_bytes[convert_address(address_i) + 3],
                                      memory_bytes[convert_address(address_i) + 2],
                                      memory_bytes[convert_address(address_i) + 1],
                                      memory_bytes[convert_address(address_i)] };
                read_value_o <= cache[index].data;
            end
        end
    end

endmodule
