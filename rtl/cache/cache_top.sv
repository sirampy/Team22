module cache_top #(
    parameter DATA_WIDTH = 32
)(
    input logic                                 clk,
    input logic [DATA_WIDTH-1:0]                dataWord_i,
    input logic [DATA_WIDTH-1:0]                addressWord_i,
    input logic                                 overwrite_i,

    output logic [DATA_WIDTH-1:0]               dataWord_o
);

direct_cache cache(
    .clk_i (clk),
    .addr_i (addressWord_i),
    .data_in_i(dataWord_i),
    .wen_i(overwrite_i),

    .data_out_o(dataWord_o)
);

endmodule
