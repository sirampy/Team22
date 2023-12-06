
module sign_extend (
    input [11:0] imm12_i,
    input [19:0] imm20_i,
    input src2_t src2_i,

    output [31:0] imm_o
);

always_comb begin
    case (src2_i)
        IS_IMM12: imm_o = {{20 {imm12_i[11]}}, imm12_i[11:0]};
        B_IMM12: imm_o = {{19{imm12_i[11]}}, imm12_i[11:0], 1'b0}; // shift the branch
        J_IMM: imm_o = {{12{imm20_i[19]}}, imm20_i[19:0]};
        U_IMM: imm_o = {imm20_i[19:0], 12'b0};
        default: imm_o = 0;
    endcase
end

endmodule
