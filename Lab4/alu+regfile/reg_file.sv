module reg_file #(
    parameter ADDR_WDTH = 5,
    parameter DATA_WDTH = 32
)(
    input                     clk,

    input [ADDR_WDTH - 1 : 0] ad1,
    input [ADDR_WDTH - 1 : 0] ad2,
    input [ADDR_WDTH - 1 : 0] ad3,

    input                     we3,
    input [DATA_WDTH - 1 : 0] wd3,

    output [DATA_WDTH - 1 : 0]rd1,
    output [DATA_WDTH - 1 : 0]rd2
);
    logic [ ((2**ADDR_WDTH -1) * DATA_WDTH) -1 : 0] reg_data;
    // read logic
    
    always_ff @(posedge clk) begin
        if (ad1 == 0)
            rd1 [DATA_WDTH - 1 : 0] <= {DATA_WDTH{1'b0}};
        else 
            rd1 [DATA_WDTH - 1 : 0] <= reg_data [(ad1 * DATA_WDTH) - 1 : (ad1-1) * DATA_WDTH];

        if (ad2 == 0)
            rd2 [DATA_WDTH - 1 : 0] <= {DATA_WDTH{1'b0}};
        else 
            rd2 [DATA_WDTH - 1 : 0] <= reg_data [(ad2 * DATA_WDTH) -1 : (ad2-1) * DATA_WDTH];

        if (we3 && (ad3 == 'b0))
            reg_data [(ad3 * DATA_WDTH ) - 1: (ad3-1) * DATA_WDTH] <= [DATA_WDTH - 1 : 0] wd3;
    end

endmodule
