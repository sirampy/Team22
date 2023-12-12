//two way associative cache

module two_way #(
    parameter   TAG_WIDTH = 28, // increased from 27 (direct cache)
                DATA_WIDTH = 32,
                SET_WIDTH = 2 // now reduced to 2 for 4 sets
)(
    input  logic                     clk_i,
    input  logic [DATA_WIDTH-1:0] addr_i,
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
    logic [TAG_WIDTH-1:0]  tag;
    cache_flags_t         flags;
} cache_entry_t; 

cache_entry_t data[2][(2**SET_WIDTH)-1:0]; // 2-d array for 'two ways' per set

logic [SET_WIDTH-1:0] set;
logic [TAG_WIDTH-1:0] tag;

always_comb begin
    set = addr_i[SET_WIDTH+1:2];
    tag = addr_i[DATA_WIDTH-1:DATA_WIDTH-TAG_WIDTH];
end

// Assuming data_memory is defined elsewhere
data_memory data_mem(
    .clk_i(clk_i),
    .address_i(addr_i),
    .write_value_i(data_in_i),
    .write_enable_i(wen_i),
    .read_value_o(data_out_o)
);

logic [(2**SET_WIDTH)-1:0] lru; // LRU bits - one for each set

initial begin
    int i, j;
    for (i = 0; i < 2; i++) begin
        for (j = 0; j < (2**SET_WIDTH); j++) begin
            data[i][j].flags = {1'b0, 1'b0}; // set invalid
        end
    end
    for (i = 0; i < (2**SET_WIDTH); i++) begin
        lru[i] = 0; // initialise LRU bits
    end
end

logic hit;
logic way; // tracking which way is hit
always_comb begin
    // checking both ways for a hit
    hit = 1'b0;
    way = 1'b0;
    for (int i = 0; i < 2; i++) begin
        if (data[i][set].tag == tag && data[i][set].flags.valid) begin
            hit = 1'b1;
            way = i[0];
            lru[set] = ~i[0]; // toggling between 1 and 0 for which way
            break;
        end
    end

    case(wen_i)
        1'b0: begin // read operation
            if (hit) begin
                // read hit
                data_out_o = data[way][set].data;
                lru[set] = ~way; 
            end else begin
                // read miss
                way = lru[set]; 
                lru[set] = ~way; 
            end
        end
        1'b1: begin // write operation
            if (hit) begin
                // write hit
                data[way][set].data = data_in_i;
                data[way][set].flags.dirty = 1'b1;
                lru[set] = ~way; 
            end else begin
                // write miss
                way = lru[set]; // using LRU to choose which way
                lru[set] = ~way; 
            end
        end
    default: $display("Error: Unexpected value of wen_i");
    endcase
end

endmodule
