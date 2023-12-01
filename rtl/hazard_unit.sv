// hazard unit for data hazards
module hazard_unit #(
    parameter
)(
    input logic [19:15] rs1D_i, // register 1 address (decode)
    input logic [24:20] rs2D_i, // resister 2 address (decode)

    output logic [1:0] forward_aE, // forward select for register 1 (execute)
    output logic [1:0] forward_bE // forward select for register 2
);

endmodule
