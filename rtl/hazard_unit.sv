// hazard unit for data hazards
module hazard_unit #(
    parameter ADDR_WIDTH = 5;
)(
    input  logic [19:15]          rs1E_i,       // register 1 address (execute)
    input  logic [24:20]          rs2E_i,       // resister 2 address (execute)
    input  logic [ADDR_WIDTH-1:0] rdM_i,        // write register address (memory)
    input  logic [ADDR_WIDTH-1:0] rdW_i,        // write register address (writeback)
    input  logic                  reg_writeM_i, // write enable (m)
    input  logic                  reg_writeW_i, // write enable (w)
    input  logic                  result_srcE_i,
    input  logic [19:15]          rs1D_i,       // to check for lw
    input  logic [24:20]          rs2D_i,       // to check for lw

    output logic [1:0] forward_aE_o, // forward select for register 1 (execute)
    output logic [1:0] forward_bE_o, // forward select for register 2 (execute)
    output logic       stallF_o,     // stall fetch register (ff0)
    output logic       stallD_o,     // stall decode register (ff1)
    output logic       flushE_o,     // clear execute register (ff2)
);

    logic lw_stall;

    always_comb begin
        // for rs1:
        // if destination register (m) = register (e) --> forward from mem
        if (((rs1E_i == rdM_i) & reg_writeM_i) & (rs1E_1 != 0)) forward_aE_o = 2'b10;
        // same for w
        else if (((rs1E_i == rdW_i) & reg_writeW_i) & (rs1E_1 != 0)) forward_aE_o = 2'b01;
        else forward_aE_o = 2'b00; // do not forward

        // same for rs2:
        if (((rs2E_i == rdM_i) & reg_writeM_i) & (rs2E_i != 0)) forward_bE_o = 2'b10;
        else if (((rs2E_i == rdW_i) & reg_writeW_i) & (rs2E_i != 0)) forward_bE_o = 2'b01;
        else forward_bE_o = 2'b00;

        // dealing with lw stalls
        lw_stall = result_srcE_i & ((rs1D_i == rdE_i) | (rs2D_i == rdE_i));
        stallF_o = stallD_o = flushE_o = lw_stall;
    end

endmodule
