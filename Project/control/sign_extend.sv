module sign_extend #(
    parameter DATA_WIDTH = 32,
              IMM_WIDTH = 12
)(
    input                   clk,
    input   [DATA_WIDTH-1:0] instr,
    input   [1:0]       imm_src,
    output reg [IMM_WIDTH-1:0] imm_ext 
);

    always_comb begin  
        case (imm_src)
            2'b00 : imm_ext = {{20{instr[31]}}, instr[31:20]}; //i-type
            2'b01 : imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]}; //store
            2'b10 : imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; //branch
            2'b11 : imm_ext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21, 1'b0]}; //added for JAL instruction

            default : imm_ext = {{20{instr[31]}}, instr[31:20]}; 
        endcase
    end

endmodule 
