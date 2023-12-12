//two way associative cache

module two_way #(
    parameter   ADDRESS_WIDTH = 16,
                TAG_WIDTH = 28, // increased from 27(direct cache)
                USED_ADDRESS_WIDTH = 8,
                DATA_WIDTH = 32,
                SET_WIDTH = 2 //now reduced to 2 for 4 sets

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

 cache_entry_t data[2][(2**SET_WIDTH)-1:0]; //2-d array for 'two ways' per set

logic set[SET_WIDTH-1:0]  = addr_i[SET_WIDTH+1:0];
logic tag[TAG_WIDTH-1:0]  = addr_i[ADDRESS_WIDTH-1:ADDRESS_WIDTH-TAG_WIDTH];

data_memory data_mem(
    .a_i(addr_i),
    .wd_i(data_in_i),
    .wen_i(wen_i),
    .rd_o(data_out_o)
);

logic lru[(2**SET_WIDTH)-1:0]; //LRU bits - one for each set

initial begin
    foreach (data[i][j]) begin
        data[i][j].flags = {1'b0, 1'b0}; // set invalid
    end
    foreach (lru[i]) begin
        lru[i] = 0; // initialise LRU bits
    end
end

always_comb begin
    logic hit;
    logic [1:0] way; //tracking which way is hit

    //checking both ways for a hit
    hit = 0;
    for (int i = 0; i < 2; i++) begin
        if (data[i][set].tag == tag && data[i][set].flags.valid) begin
            hit = 1;
            way = i;
            lru[set] = ~i; //toggling between 1 and 0 for which way
            //reasoning: updates the LRU bit for the current set to indicate which way was least recently used
            break;
        end
    end
    case(wen_i)
            1'b0: begin // read operation
                if (hit) {
                    // read hit
                    data_out_o = data[way][set].data;
                    lru[set] = ~way; 
                } else {
                    // read miss
                    way = lru[set]; 
                    lru[set] = ~way; 
                }
            end 
            1'b1: begin // write operation
                if (hit) {
                    // write hit
                    data[way][set].data = data_in_i;
                    data[way][set].flags.dirty = 1'b1;
                    lru[set] = ~way; 
                } else {
                    // write miss
                    way = lru_bits[set]; // using LRU to choose which way
                    lru[set] = ~way; 
                }
            end
    endcase 
end
endmodule

