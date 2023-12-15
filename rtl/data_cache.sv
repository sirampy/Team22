/*
this is a basic direct mapped cache to get us started. 
this cache is self controlled and is "in charge" of the memory itself
the cache is write back - not write through


module data_cache #(
    parameter   ADDRESS_WIDTH = 16,
                USED_ADDRESS_WIDTH = 8,
                DATA_WIDTH = 32,
                SET_WIDTH = 3,

)(
    input logic [ADDRESS_WIDTH-1:0] a_i,
    input logic [DATA_WDTH-1:0]     wd_i,
    input logic                     wen_i,
    output logic [DATA_WIDTH-1:0]   rd_o
);

typedef struct { 
    bit [0] valid;
    bit [0] dirty;
 } cache_flags_t;

 typedef struct packed {
    logic [DATA_WDTH-1:0] data;
    logic [ADDR_WIDTH-(SET_WIDTH+3):0] tag;
    cache_flags_t         flags;
 } cache_entry_t;

assign logic set[SET_WIDTH:0] = a_i[SET_WIDTH+2:2];
assign logic tag[ADDR_WIDTH-(SET_WIDTH+3):0] = a_i[ADDR_WDTH:SET_WIDTH+3]; 

cache_entry_t data [(2**set_width)-1:0];

data_mem data_mem(
    .a_i(),
    .wd_i(),
    .wen_i(),
    .rd_o()
)

initial begin
    foreach (data[i]) begin
        assign data[i].flags = [0,0]; // set invalid
    end
end

always_comb begin
    
    case (wen):
    'b0: begin // read operation

        if (tag == data[set].tag && data[set].flags.valid == 1){ // cache ht
            rd_o = data[set]
        }else{ // cache miss
            if (data[set].flags == 2'b11){ // needs to write back to memory
                // TODO: write to memory
            }
        // TODO: read to tache
        }
    end

    'b1: begin // write operation
        if (tag == data[set].tag || data[set].flags.valid == 0){ // cache ht
            data[set].data = wd_i;
            data[set].tag = tag;
            data[set].flags = 'b11;
        }else{ // cache miss
            if (data[set].flags == 2'b11){ // needs to write back to memory
                // TODO: write to memory
            }
        data[set].data = wd_i;
        data[set].tag = tag;
        data[set].flags = 'b11;
        }
    end

endcase
    

end

endmodule
*/
