module reg_file #(
    parameter ADDR_WDTH = 5,
    parameter DATA_WDTH = 32
)(
    input                     clk_i,

    input [ADDR_WDTH - 1 : 0] ad1_i,
    input [ADDR_WDTH - 1 : 0] ad2_i,
    input [ADDR_WDTH - 1 : 0] ad3_i,

    input                     we3_i,
    input [DATA_WDTH - 1 : 0] wd3_i,

    output [DATA_WDTH - 1 : 0]rd1_o,
    output [DATA_WDTH - 1 : 0]rd2_o
);
//    logic [ ((2**ADDR_WDTH -1) * DATA_WDTH) -1 : 0] reg_data;
    logic [DATA_WDTH-1:0] reg_data [32];    //32 regs of 32-bits

    //synchronous write port
    always_ff @ (posedge clk_i) begin
        if (we3_i) reg_data[ad3_i] <= wd3_i;
    end

    // read ports of the register file should be asychronous
    assign rd1_o = reg_data[ad1_i] * (ad1_1 != 0);
    assign rd2_o = reg_data[ad2_i] * (ad2_i != 0);

endmodule
