module data_memory_cache #(
    parameter   DATA_WIDTH = 60
)(
    input logic     [31:0]        mem_address_i,
    input logic     [31:0]        data_in_i,
    input logic                   write_en_cache_i,
    input logic                   clk_i,
    output logic    [31:0]        data_out_o
);

logic hit = 1'b0;
logic tag;
logic valid = 1'b0;

logic [DATA_WIDTH-1:0] ram_array [7:0]; 

always_comb begin
    if (write_en_cache_i)
    begin
        tag = (mem_address_i[31:5] == ram_array[mem_address_i[4:2]][58:32]);
        valid = ram_array[mem_address_i[4:2]][59];
        hit = (tag & valid);
        if(hit)
            data_out_o = ram_array[mem_address_i[4:2]][31:0];
        else
            data_out_o = data_in_i;
    end 
end

always_ff @(posedge clk_i) begin
    if (hit == 1'b0 & write_en_cache_i == 1'b1)
    begin
        ram_array[mem_address_i[4:2]][59] <= 1'b1;
        ram_array[mem_address_i[4:2]][31:0] <= data_in_i;
        ram_array[mem_address_i[4:2]][58:32] <= mem_address_i[31:5];
    end
end

endmodule
