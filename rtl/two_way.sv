module two_way #(
    parameter ADDRESS_WIDTH = 32,
    parameter TAG_WIDTH = 28, 
    parameter DATA_WIDTH = 32,
    parameter CACHE_LENGTH = 4,
    parameter SET_WIDTH = 2
)(
    input  logic                     clk_i,
    input  logic [ADDRESS_WIDTH-1:0] addr_i,
    input  logic [DATA_WIDTH-1:0]    data_in_i,
    input  logic                     wen_i,
    output logic [DATA_WIDTH-1:0]    data_out_o,
    output logic                     hit_o
);

    logic v [CACHE_LENGTH-1:0][1:0];
    logic [TAG_WIDTH-1:0] tag [CACHE_LENGTH-1:0][1:0];
    logic [DATA_WIDTH-1:0] data [CACHE_LENGTH-1:0][1:0];
    logic round_robin [CACHE_LENGTH-1:0]; // round_robin policy bit for each set

    logic [SET_WIDTH-1:0] current_set;
    logic [TAG_WIDTH-1:0] current_tag;

    assign current_set = addr_i[SET_WIDTH+1:2];
    assign current_tag = addr_i[DATA_WIDTH-1:DATA_WIDTH-TAG_WIDTH]; 

    logic hit0, hit1;
    assign hit0 = (tag[current_set][0] == current_tag) && v[current_set][0];
    assign hit1 = (tag[current_set][1] == current_tag) && v[current_set][1];
    assign hit_o = hit0 || hit1;

    always_latch begin
        if(hit_o) begin
            if(hit0) begin
                data_out_o = data[current_set][0];
                round_robin[current_set] = 1'b1; 
            end else if(hit1) begin
                data_out_o = data[current_set][1];
                round_robin[current_set] = 1'b0; 
            end
        end else begin
            data_out_o = data_in_i;
        end
    end

    always_ff @(negedge clk_i) begin
        if(!hit_o) begin
            if(round_robin[current_set]) begin
                tag[current_set][1] <= current_tag;
                data[current_set][1] <= data_in_i;
                v[current_set][1] <= 1'b1;
                round_robin[current_set] <= 1'b0;
            end else begin
                tag[current_set][0] <= current_tag;
                data[current_set][0] <= data_in_i;
                v[current_set][0] <= 1'b1;
                round_robin[current_set] <= 1'b1;
            end
        end
        if(wen_i) begin
            if(hit0) begin
                tag[current_set][0] <= current_tag;
                data[current_set][0] <= data_in_i;
                round_robin[current_set] <= 1'b1;
            end else if(hit1) begin
                tag[current_set][1] <= current_tag;
                data[current_set][1] <= data_in_i;
                round_robin[current_set] <= 1'b0;
            end
        end
    end
endmodule