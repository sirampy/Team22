/* 
Basic direct mapped cache
This cache is self controlled and is "in charge" of the memory itself
The cache is write back - not write through
*/

module direct_cache #(
    parameter ADDRESS_WIDTH = 16,
    parameter TAG_WIDTH = 27,
    parameter USED_ADDRESS_WIDTH = 8,
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

    logic [SET_WIDTH:0] set;
    logic [TAG_WIDTH:0] tag;

    assign set = addr_i[SET_WIDTH+2:2];
    assign tag = addr_i[ADDRESS_WIDTH-1:ADDRESS_WIDTH-TAG_WIDTH]; 

    cache_entry_t data [(2**SET_WIDTH)-1:0];

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
        foreach (data[i]) assign data[i].flags = {0, 0}; // set invalid
    end

    always_comb begin
        
        case (wen_i)
        1'b0: begin // read operation

            if (tag == data[set].tag && data[set].flags.valid == 1) data_out_o = data[set]; // cache hit
            else if (data[set].flags == 2'b11) begin // cache miss
                // write to memory
                address = {data[set].tag, set, 2'b00}; // full address - tag, set, byte offset
                write_data = data[set].data;
                wen = 1'b1; // write enable
            end
            //read to cache
            address = addr_i;
            wen = 1'b0; // set datamem write enable to 0 
            data[set].data = read_data; // update cache
            data[set].tag = tag;
            data[set].flags = {1, 0}; // set flags as valid and not dirty
        end

        1'b1: begin // write operation
            if (tag == data[set].tag || data[set].flags.valid == 0) begin // cache hit
                data[set].data = wen_i;
                data[set].tag = tag;
                data[set].flags = 2'b11;
            end
            else if (data[set].flags == 2'b11) begin // cache miss
                // write to memory
                address = {data[set].tag, set, 2'b00}; // full address - tag, set, byte offset
                write_data = data[set].data;
                wen = 1'b1; // write enable
            end
            data[set].data = write_data;
            data[set].tag = tag;
            data[set].flags = 'b11;
        end

        default: $display("Error: Unexpected value of wen_i");
        endcase

    end

endmodule

