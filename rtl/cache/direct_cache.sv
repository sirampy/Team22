/* 
Basic direct mapped cache
This cache is self controlled and is "in charge" of the memory itself
The cache is write back - not write through
*/

module direct_cache #(
    parameter ADDRESS_WIDTH = 32,
    parameter TAG_WIDTH = 27,
    parameter DATA_WIDTH = 32,
    parameter SET_WIDTH = 3
)(
    input  logic                     clk_i,
    input  logic [ADDRESS_WIDTH-1:0] addr_i,
    input  logic [DATA_WIDTH-1:0]    data_in_i,
    input  logic                     wen_i,
    output logic [DATA_WIDTH-1:0]    data_out_o
);

    typedef struct packed { 
        bit valid;
        bit dirty;
    } cache_flags_t;

    typedef struct packed {
        logic [DATA_WIDTH-1:0] data;
        logic [TAG_WIDTH-1:0]   tag;
        cache_flags_t         flags;
    } cache_entry_t;

    logic [SET_WIDTH-1:0] set;
    logic [TAG_WIDTH-1:0] tag;

    assign set = addr_i[SET_WIDTH+1:2];
    assign tag = addr_i[DATA_WIDTH-1:DATA_WIDTH-TAG_WIDTH]; 

    cache_entry_t cache [(2**SET_WIDTH)-1:0];

    logic [ADDRESS_WIDTH-1:0] address;
    logic wen;
    logic [DATA_WIDTH-1:0] write_data;
    logic [DATA_WIDTH-1:0] read_data;

    data_memory data_mem(
        .clk_i (clk_i),
        .address_i(address),
        .write_value_i(write_data),
        .wen_i(wen),
        .read_value_o(read_data)
    );

    initial begin
        foreach (cache[i]) assign cache[i].flags = {1'b0, 1'b0}; // set invalid
    end

    always_ff @(posedge clk_i) begin
        // Move cache assignments to always_ff
        case (wen_i)
            1'b0: begin // read operation
                if (tag == cache[set].tag && cache[set].flags.valid == 1) begin
                    // cache hit
                    data_out_o <= cache[set].data;
                end else begin
                    // cache miss
                    if (cache[set].flags.dirty == 1) begin
                        // write back to memory
                        address <= {cache[set].tag, set, 2'b00}; // tag, set, byte offset
                        write_data <= cache[set].data;
                        wen <= 1'b1; // write enable
                    end
                    // read from memory
                    address <= addr_i;
                    wen <= 1'b0; // set datamem write enable to 0 
                    // update cache with read data
                    cache[set].data <= read_data;
                    cache[set].tag <= tag;
                    cache[set].flags <= {1'b1, 1'b0}; // set flags as valid and not dirty
                end
            end

            1'b1: begin // write operation
                if (tag == cache[set].tag || cache[set].flags.valid == 0) begin // cache hit
                    cache[set].data <= data_in_i;
                    cache[set].tag <= tag;
                    cache[set].flags <= 2'b11;
                end
                else if (cache[set].flags.dirty == 1) begin // cache miss
                    // write back to memory
                    address <= {cache[set].tag, set, 2'b00}; // tag, set, byte offset
                    write_data <= cache[set].data;
                    wen <= 1'b1; // write enable
                end
                cache[set].data <= write_data;
                cache[set].tag <= tag;
                cache[set].flags <= 2'b11;
            end

            default: $display("Error: Unexpected value of wen_i");
        endcase
    end



endmodule

