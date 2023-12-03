/*
this is a basic direct mapped cache to get us started. 
this cache is self controlled and is "in charge" of the memory itself
*/

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
    logic [SET_WIDTH-1:0] set;
    cache_flags_t         flags;
 } cache_entry_t;

assign logic set[SET_WIDTH:0] = a_i[SET_WIDTH+2:2];

cache_entry_t data [(2**set_width)-1:0];

initial begin
    foreach (data[i]) begin
        assign data[i].flags = [0,0]; // set invalid
    end
end



endmodule
