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
    output [DATA_WDTH - 1 : 0]rd2,
    
    output logic [DATA_WDTH-1:0] a0 // Output for top sheet

);
//    logic [ ((2**ADDR_WDTH -1) * DATA_WDTH) -1 : 0] reg_data;
    logic [DATA_WDTH-1:0] reg_data [2 ** ADDR_WDTH - 1 : 0];    //32 regs of 32-bits

    assign reg_data[0] = {DATA_WDTH{1'b0}};    //zero register

    //synchronous write port
    always_ff @ (posedge clk)
        if (we3) reg_data[ad3] <= wd3;

    // read ports of the register file should be asychronous
    assign rd1 = reg_data[ad1];
    assign rd2 = reg_data[ad2];
    
    assign a0 = reg_data[10];

endmodule
