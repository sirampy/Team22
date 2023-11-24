module reg_file #(
    param ADDR_WDTH = 5;
    param DATA_WDTH = 32;
){
    input                     clk;

    input [ADDR_WDTH - 1 : 0] AD1,
    input [ADDR_WDTH - 1 : 0] AD2,
    input [ADDR_WDTH - 1 : 0] AD3,

    input                     WE3,
    input [DATA_WIDTH - 1 : 0]WD3,

    output [DATA_WDTH - 1 : 0]RD1,
    output [DATA_WDTH - 1 : 0]RD2,
};
    logic [ (((2 ** ADDR_WDTH) -1 ) * DATA_WDTH) -1 : 0] Reg_Data;
    // read logic
    
    always_ff @(posedge clk) begin

        if (AD1 == 0)
            RD1 [DATA_WDTH - 1 : 0] <= DATA_WIDTH'b0;
        else 
            RD1 [DATA_WDTH - 1 : 0] <= Reg_Data [(AD1 * DATA_WDTH) -1 : (AD1-1) * DATA_WDTH];

        if (AD2 == 0)
            RD2 [DATA_WDTH - 1 : 0] <= DATA_WIDTH'b0;
        else 
            RD2 [DATA_WDTH - 1 : 0] <= Reg_Data [(AD1 * DATA_WDTH) -1 : (AD2-1) * DATA_WDTH];

        if (WE3 && (AD3 == 'b0))
            Reg_Data [(AD3 * DATA_WDTH ) - 1: (AD3-1) * DATA_WDTH] <= [DATA_WIDTH - 1 : 0] WD3;
    end
endmodule