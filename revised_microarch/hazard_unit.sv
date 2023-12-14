// hazard unit for data hazards
module hazard_unit #(
    parameter ADDR_WIDTH = 5
)(
    input  logic [19:15]          alu_src_1_i,       // register 1 address (execute)
    input  logic [24:20]          alu_src_2_i,       // resister 2 address (execute)
    input  logic [ADDR_WIDTH-1:0] rd_e_i,        // write register address (execute)
    input  logic [ADDR_WIDTH-1:0] rd_m_i,        // write register address (memory)
    input  logic [ADDR_WIDTH-1:0] rd_w_i,        // write register address (writeback)
    input  logic                  reg_write_m_i, // write enable (m)
    input  logic                  reg_write_w_i, // write enable (w)
    input  logic                  result_src_e_i,
    input  logic [19:15]          rs1_d_i,       // to check for lw
    input  logic [24:20]          rs2_d_i,       // to check for lw
    input  logic                  pc_src_e_i,    // to check for branch instructions

    output logic [1:0] forward_aE_o, // forward select for register 1 (execute)
    output logic [1:0] forward_bE_o, // forward select for register 2 (execute)

    output pipeline_control       control_f,    // stall or flush fetch register 
    output pipeline_control       control_d,    // stall or flush decode register 
    output pipeline_control       control_e     // stall or flush execute register 
);

    logic lw_stall;

    always_comb begin
        // for rs1:
        // if destination register (m) = register (e) --> forward from mem
        if (((rs1E_i == rdM_i) & reg_writeM_i) & (rs1E_i != 0)) forward_aE_o = 2'b10;
        // same for w
        else if (((rs1E_i == rdW_i) & reg_writeW_i) & (rs1E_i != 0)) forward_aE_o = 2'b01;
        else forward_aE_o = 2'b00; // do not forward

        // same for rs2:
        if (((rs2E_i == rdM_i) & reg_writeM_i) & (rs2E_i != 0)) forward_bE_o = 2'b10;
        else if (((rs2E_i == rdW_i) & reg_writeW_i) & (rs2E_i != 0)) forward_bE_o = 2'b01;
        else forward_bE_o = 2'b00;

        // dealing with lw stalls
        lw_stall = result_srcE_i & ((rs1D_i == rdE_i) | (rs2D_i == rdE_i)); // identifies when there is an lw stall
        if(lw_stall) begin
            control_f = STALL;
            control_d = STALL;
            control_e = FLUSH;
        end
        else if(pc_srcE_i)  begin
            control_f = CONTINUE;
            control_d = FLUSH;
            control_e = FLUSH;
        end
        else begin
            control_f = CONTINUE;
            control_d = CONTINUE;
            control_e = CONTINUE;
        end
    end

endmodule
