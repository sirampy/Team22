/* 
Basic direct mapped cache
This cache is self controlled and is "in charge" of the memory itself
The cache is write back - not write through
*/

module direct_cache #(
    parameter   ADDRESS_WIDTH = 16,
                TAG_WIDTH = 27,
                USED_ADDRESS_WIDTH = 8,
                DATA_WIDTH = 32,
                SET_WIDTH = 3,

)(
    input  logic [ADDRESS_WIDTH-1:0] addr_i,
    input  logic [DATA_WIDTH-1:0]     data_in_i,
    input  logic                     wen_i,
    output logic [DATA_WIDTH-1:0]    data_out_o
);

typedef struct { 
    bit [0] valid;
    bit [0] dirty;
 } cache_flags_t;

 typedef struct packed {
    logic [DATA_WIDTH-1:0] data;
    logic [TAG_WIDTH-1:0]   tag;
    cache_flags_t         flags;
 } cache_entry_t;

assign logic set[SET_WIDTH:0] = addr_i[SET_WIDTH+2:2];
assign logic tag[TAG_WIDTH:0] = addr_i[DATA_WIDTH-1:DATA_WIDTH-1-TAG_WIDTH]; 

cache_entry_t data [(2**SET_WIDTH)-1:0];

data_memory data_mem(
    .a_i(addr_i),
    .wd_i(data_in_i),
    .wen_i(wen_i),
    .rd_o(data_out_o)
);

initial begin
    foreach (data[i]) begin
        assign data[i].flags = [0,0]; // set invalid
    end
end

always_comb begin
    
    case (wen):
    1'b0: begin // read operation

        if (tag == data[set].tag && data[set].flags.valid == 1) rd_o = data[set]; // cache hit
        else if (data[set].flags == 2'b11) begin // cache miss
            // write to memory
            data_mem.a_i = {data[set].tag, set, 2'b00}; // full address - tag, set, byte offset
            data_mem.wd_i = data[set].data;
            data_mem.wen_i = 1'b1; // write enable
        end
        //read to cache
        data_mem.a_i = a_i;
        data_mem.wen_i = 1'b0; // write enable set to 0 
        data[set].data = data_mem.rd_o; // update cache
        data[set].tag = tag;
        data[set].flags = {1'b1, 1'b0}; // set flags as valid and not dirty
    end

    1'b1: begin // write operation
        if (tag == data[set].tag || data[set].flags.valid == 0) begin // cache hit
            data[set].data = wd_i;
            data[set].tag = tag;
            data[set].flags = 'b11;
        else if (data[set].flags == 2'b11) begin // cache miss
                // write to memory
                data_mem.a_i = {data[set].tag, set, 2'b00}; // full address - tag, set, byte offset
                data_mem.wd_i = data[set].data;
                data_mem.wen_i = 1'b1; // write enable
        end
        data[set].data = data_in_i;
        data[set].tag = tag;
        data[set].flags = 'b11;
        end
    end

endcase
    
end

endmodule

