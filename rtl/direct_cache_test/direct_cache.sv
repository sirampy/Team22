/* 
Basic direct mapped cache
This cache is self controlled and is "in charge" of the memory itself
The cache is write back - not write through
*/

module direct_cache #(
    parameter ADDRESS_WIDTH = 32,
    parameter TAG_WIDTH = 27,
    parameter DATA_WIDTH = 32,
    parameter CACHE_LENGTH = 8,
    parameter SET_WIDTH = 3
)(
    input  logic                     clk_i,
    input  logic [ADDRESS_WIDTH-1:0] addr_i,
    input  logic [DATA_WIDTH-1:0]    data_in_i,
    input  logic                     wen_i,
    output logic [DATA_WIDTH-1:0]    data_out_o,
    output logic                     hit_o
);


    logic v [CACHE_LENGTH-1:0];
   // logic d [CACHE_LENGTH-1:0];
    logic [TAG_WIDTH-1:0] tag [CACHE_LENGTH-1:0];
    logic [DATA_WIDTH-1:0] data [CACHE_LENGTH-1:0];

    logic [SET_WIDTH-1:0] current_set;
    logic [TAG_WIDTH-1:0] current_tag;

    assign current_set = addr_i[SET_WIDTH+1:2];
    assign current_tag = addr_i[DATA_WIDTH-1:DATA_WIDTH-TAG_WIDTH]; 
    assign hit_o = (tag[current_set] == current_tag) && v[current_set];

    always_latch begin
        if(hit_o) data_out_o = data[current_set];
    end

    always_ff @(negedge clk_i) begin
        if(current_tag != tag[current_set]) begin
            tag [current_set] <= current_tag;
            data [current_set] <= data_in_i;
            v [current_set] <= 1'b1;
        end
        if(wen_i) begin
            if(current_tag == tag [current_set]) begin
                tag [current_set] <= current_tag;
                data [current_set] <= data_in_i;
            end
        end
    end

endmodule
