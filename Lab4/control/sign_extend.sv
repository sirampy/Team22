module sign_extend (
    input   [31 : 7]    instr,
    input   [1:0]       imm_src,
    output reg [11:0]   imm_ext  // Declare imm_ext as reg since it's driven by procedural code
);

    always_comb begin  // Enclose the case statement inside an always_comb block
        case (imm_src)
            2'b00 : imm_ext = {{20{instr[31]}}, instr[31:20]};
            2'b01 : imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            2'b10 : imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            default : imm_ext = 12'b0;  // Use 12'b0 to match the bit width of imm_ext
        endcase
    end

endmodule
