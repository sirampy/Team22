// pipelining register 2 -> delays from decode to execute
module pipe_reg2 #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    // main inputs
    input  logic                     clk_i,       // clock
    input  logic                     clr_i,         // flush register 
    input  logic [DATA_WIDTH-1:0]    rd1D_i,      // read register 1 (decode)
    input  logic [DATA_WIDTH-1:0]    rd2D_i,      // read register 2 (d)
    input  logic [19:15]             rs1D_i,      // read reg 1 address
    input  logic [24:20]             rs2D_i,      // read reg 2 address
    input  logic [ADDRESS_WIDTH-1:0] pcD_i,       // pc (d)
    input  logic [11:7]              rdD_i,       // write register address (d)
    input  logic [DATA_WIDTH-1:0]    imm_extD_i,  // imm extend (d)
    input  logic [ADDRESS_WIDTH-1:0] pc_plus4D_i, // pc+4 (d)

    // control unit inputs
    input logic       reg_writeD_i,  // write enable (d) 
    input logic [1:0] result_srcD_i, // select write input (d)
    input logic       mem_writeD_i,  // mem write enable (d)
    input logic       jumpD_i,
    input logic       branchD_i,
    input logic [3:0] alu_ctrlD_i,
    input logic       alu_srcD_i,
    input logic       cache_weD_i,

    // main outputs
    output logic [DATA_WIDTH-1:0]    rd1E_o,    // read register 1 values (execute)
    output logic [DATA_WIDTH-1:0]    rd2E_o,    // read register 2 values (e)
    output logic [ADDRESS_WIDTH-1:0] pcE_o,     // pc (e)
    output logic [19:15]             rs1E_o,      // read reg 1 address
    output logic [24:20]             rs2E_o,      // read reg 2 address
    output logic [11:7]              rdE_o,     // write register address (e)
    output logic [DATA_WIDTH-1:0]    imm_extE_o,
    output logic [ADDRESS_WIDTH-1:0] pc_plus4E_o,  // pc+4 (e)

    // control unit outputs
    output logic       reg_writeE_o,
    output logic [1:0] result_srcE_o,
    output logic       mem_writeE_o,
    output logic       jumpE_o,
    output logic       branchE_o,
    output logic [3:0] alu_ctrlE_o,
    output logic       alu_srcE_o,
    output logic       cache_weE_o
);

always_ff @(posedge clk_i)
    begin
        if (clr_i) begin
            rd1E_o      <= {DATA_WIDTH{1'b0}};
            rd2E_o      <= {DATA_WIDTH{1'b0}};
            pcE_o       <= {ADDRESS_WIDTH{1'b0}};
            rdE_o       <= 5'b0;
            imm_extE_o  <= {DATA_WIDTH{1'b0}};
            pc_plus4E_o <= {ADDRESS_WIDTH{1'b0}};
            reg_writeE_o  <= 1'b0;
            result_srcE_o <= 2'b00;
            mem_writeE_o  <= 1'b0;
            jumpE_o       <= 1'b0;
            branchE_o     <= 1'b0;
            alu_ctrlE_o   <= 4'b0000;
            alu_srcE_o    <= 1'b0;
            cache_weE_o   <= 1'b0;
        end
        else begin
            rd1E_o      <= rd1D_i;
            rd2E_o      <= rd2D_i;
            rs1E_o      <= rs1D_i;
            rs2E_o      <= rs2D_i;
            pcE_o       <= pcD_i;
            rdE_o       <= rdD_i;
            imm_extE_o  <= imm_extD_i;
            pc_plus4E_o <= pc_plus4D_i;
            reg_writeE_o  <= reg_writeD_i;
            result_srcE_o <= result_srcD_i;
            mem_writeE_o  <= mem_writeD_i;
            jumpE_o       <= jumpD_i;
            branchE_o     <= branchD_i;
            alu_ctrlE_o   <= alu_ctrlD_i;
            alu_srcE_o    <= alu_srcD_i;
            cache_weE_o   <= cache_weD_i;
        end
    end

endmodule
