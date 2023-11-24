module sign_extend (
    input   [31 : 7]    instr;
    input   [1:0]       imm_src;
    output  [11:0]      imm_ext;
)

    case (imm_src)
        'b00 : imm_ext = {{20{instr[31]}}, instr[31:20]};
        'b01 : imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        'b10 : imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
        default : imm_ext = 'b0;
    endcase

endmodule