module signextend(
    input logic [1:0] imm_src,
    input logic [31:7] intr,
    output logic [31:0] imm_exit

)
always_comb
    case(imm_src)
        default : imm_exit = 32'b0; 
        2'b00 : imm_exit = {{20{instr[31]}}, instr[31:20]};   
        2'b01 : imm_exit = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        2'b10 : imm_exit = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
             
    endcase

endmodule
