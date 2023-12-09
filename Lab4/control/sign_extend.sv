module sign_extend #(
    parameter IMM_WIDTH = 32
)(
    input logic [31:20] instr31_20,
    input logic [11:7] instr11_7,
    input logic [19:12] instr19_12,
    input logic [1:0]       imm_src,
    output reg [IMM_WIDTH-1:0] imm_ext
);

    always_comb 
        case (imm_src)
            2'b00 : imm_ext = {{20{instr31_20[31]}}, instr31_20[31:20]}; //I-type
            2'b01 : imm_ext = {{20{instr31_20[31]}}, instr31_20[31:25], instr11_7[11:7]}; //S-type
            2'b10 : imm_ext = {{20{instr31_20[31]}}, instr11_7[7], instr31_20[30:25], instr11_7[11:8], 1'b0};//B-type
            2'b11 : imm_ext = {{12{instr31_20[31]}}, instr19_12[19:12], instr31_20[30:21], 1'b0};//J-type - 21 bit signed imm
            default : imm_ext = {IMM_WIDTH{1'b0}};
        endcase

endmodule 
