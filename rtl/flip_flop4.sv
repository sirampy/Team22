// pipelining flip flop 4 -> delays from memory to writeback
module flip_flop4 #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    // main inputs
    input  logic                     clk_i,         // clock
    input  logic [DATA_WIDTH-1:0]    alu_resultM_i, // alu output (memory)
    input  logic [ADDRESS_WIDTH-1:0] read_dataM_i,  // read from data mem (m)
    input  logic [11:7]              rdM_i, 
    input logic [ADDRESS_WIDTH-1:0]  pc_plus4M_i,

    // control unit inputs
    input logic reg_writeM_i,
    input logic result_srcM_i,

    // main outputs
    output logic [DATA_WIDTH-1:0]    alu_resultW_o, // alu output (memory)
    output logic [ADDRESS_WIDTH-1:0] read_dataW_o,  // read from data mem (m)
    output logic [11:7]              rdW_o, 
    output logic [ADDRESS_WIDTH-1:0] pc_plus4W_o,

    // control unit outputs
    output logic reg_writeW_o,
    output logic result_srcW_o,
);

always_ff @(negedge clk)    // writeback happens on fall edge not rising
    begin
        alu_resultM_i <= alu_resultW_o;
        read_dataM_i  <= pcW_o;
        rdM_i         <= rdW_o;
        pc_plus4M_i   <= pc_plus4W_o;
        reg_writeM_i  <= reg_writeW_o;
        result_srcM_i <= result_srcW_o;
    end

endmodule
