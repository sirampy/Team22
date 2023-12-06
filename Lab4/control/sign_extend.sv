module sign_extend #(
    //parameter DATA_WIDTH = 32,        Note: Why is this here?
    parameter IMM_WIDTH = 32
)(
    input logic [31:20] instr31_20,
    input logic [11:7] instr11_7,
    input logic [1:0]       imm_src,
    output reg [IMM_WIDTH-1:0] imm_ext
);

    always_comb 
        case (imm_src)
            2'b00 : imm_ext = {{20{instr31_20[31]}}, instr31_20[31:20]};
            2'b01 : imm_ext = {{20{instr31_20[31]}}, instr31_20[31:25], instr11_7[11:7]};
            2'b10 : imm_ext = {{20{instr31_20[31]}}, instr11_7[7], instr31_20[30:25], instr11_7[11:8], 1'b0};
            default : imm_ext = {IMM_WIDTH{1'b0}};
        endcase

endmodule 
