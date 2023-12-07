// pipelining flip flop 3 -> delays from execute to memory
module flip_flop3 #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    // main inputs
    input logic                     clk_i,         // clock
    input logic [DATA_WIDTH-1:0]     alu_resultE_i, // alu output (execute)
    input logic [DATA_WIDTH-1:0]                     write_dataE_i, // data mem write enable (e)
    input logic [11:7]               rdE_i,         // write register address (e)
    input logic [ADDRESS_WIDTH-1:0]  pc_plus4E_i,

    // control unit inputs
    input logic reg_writeE_i,
    input logic [1:0] result_srcE_i,
    input logic mem_writeE_i,

    // main outputs
    output logic [DATA_WIDTH-1:0]    alu_resultM_o, // alu output (memory)
    output logic [DATA_WIDTH-1:0]                    write_dataM_o, // data mem write enable (m)
    output logic [11:7]              rdM_o,         // write register address (m)
    output logic [ADDRESS_WIDTH-1:0] pc_plus4M_o,    // pc+4 (m)

    // control unit outputs
    output logic reg_writeM_o,
    output logic[1:0] result_srcM_o,
    output logic mem_writeM_o
);

always_ff @(posedge clk_i)
    begin
        alu_resultM_o <= alu_resultE_i;
        write_dataM_o <= write_dataE_i;
        rdM_o         <= rdE_i;
        pc_plus4M_o   <= pc_plus4E_i;
        reg_writeM_o  <= reg_writeE_i;
        result_srcM_o <= result_srcE_i;
        mem_writeM_o  <= mem_writeE_i;
    end

endmodule
