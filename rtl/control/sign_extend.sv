module sign_extend #(
    parameter DATA_WIDTH = 32
)(
    input   [DATA_WIDTH-1:7]    instr_i,
    input   [1:0]               imm_src_i,
    output  [DATA_WIDTH-1:0]    imm_ext_o
);

    always_comb begin  
        case (imm_src_i)
            2'b00 : imm_ext_o = {{20{instr_i[31]}}, instr_i[31:20]};
            2'b01 : imm_ext_o = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
            2'b10 : imm_ext_o = {{20{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
            2'b11 : imm_ext_o = {{12{instr_i[31]}}, instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
            default : $error ("sign_extend error");  
        endcase
    end

endmodule 
