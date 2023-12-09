// pipelining register 2 -> delays from decode to execute
module pipe_reg2 #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    // main inputs
    input  logic                     clk_i,       // clock
    input  logic [ADDRESS_WIDTH-1:0]               rd1D_i,      // read register 1 (decode)
    input  logic [ADDRESS_WIDTH-1:0]               rd2D_i,      // read register 2 (d)
    input  logic [ADDRESS_WIDTH-1:0] pcD_i,       // pc (d)
    input  logic [11:7]              rdD_i,       // write register address (d)
    input  logic [DATA_WIDTH-1:0]    imm_extD_i,  // imm extend (d)
    input  logic [ADDRESS_WIDTH-1:0] pc_plus4D_i, // pc+4 (d)

    // control unit inputs
    input logic       reg_writeD_i,  // write enable (d) 
    input logic [1:0]      result_srcD_i, // select write input (d)
    input logic       mem_writeD_i,  // mem write enable (d)
    input logic jumpD_i,
    input logic       branchD_i,
    input logic [2:0] alu_ctrlD_i,
    input logic       alu_srcD_i,

    // main outputs
    output logic [ADDRESS_WIDTH-1:0]    rd1E_o,    // read register 1 (execute)
    output logic [ADDRESS_WIDTH-1:0]    rd2E_o,    // read register 2 (e)
    output logic [ADDRESS_WIDTH-1:0] pcE_o,     // pc (e)
    output logic [11:7]              rdE_o,     // write register address (e)
    output logic [DATA_WIDTH-1:0]    imm_extE_o,
    output logic [ADDRESS_WIDTH-1:0] pc_plus4E_o,  // pc+4 (e)

    // control unit outputs
    output logic       reg_writeE_o,
    output logic [1:0] result_srcE_o,
    output logic       mem_writeE_o,
    output logic jumpE_o,
    output logic       branchE_o,
    output logic [2:0] alu_ctrlE_o,
    output logic       alu_srcE_o
);

always_ff @(posedge clk_i)
    begin
        rd1E_o      <= rd1D_i;
        rd2E_o      <= rd2D_i;
        pcE_o       <= pcD_i;
        rdE_o       <= rdD_i;
        pc_plus4E_o <= pc_plus4D_i;
        imm_extE_o <= imm_extD_i;

        reg_writeE_o <= reg_writeD_i;
        result_srcE_o <= result_srcD_i;
        mem_writeE_o <= mem_writeD_i;
        jumpE_o <= jumpD_i;
        branchE_o <= branchD_i;
        alu_ctrlE_o <= alu_ctrlD_i;
        alu_srcE_o <= alu_srcD_i;
    end

endmodule
