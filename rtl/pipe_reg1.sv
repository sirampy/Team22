// pipelining register 1 -> delays from fetch to decode
module pipe_reg1 #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input  logic                     clk_i,       // clock

    input  logic [DATA_WIDTH-1:0]    rd_i,        // rd from instr mem
    input  logic [ADDRESS_WIDTH-1:0] pcF_i,       // pc (fetch)
    input  logic [ADDRESS_WIDTH-1:0] pc_plus4F_i, // pc+4 (fetch)

    output logic [DATA_WIDTH-1:0]    instrD_o,    // instructions (decode)
    output logic [ADDRESS_WIDTH-1:0] pcD_o,       // pc (decode)
    output logic [ADDRESS_WIDTH-1:0] pc_plus4D_o  // pc+4 (decode)
);

always_ff @(posedge clk_i)
    begin
        instrD_o <= rd_i;
        pcD_o <= pcF_i;
        pc_plus4D_o <= pc_plus4F_i;
    end

endmodule
