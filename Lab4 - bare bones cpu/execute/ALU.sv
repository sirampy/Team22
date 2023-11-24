module alu #(
    param DATA_WIDTH = 32;
)(
    input  logic [DATA_WIDTH:0]    aluOp1,      // RD1 
    input  logic [DATA_WIDTH:0]    aluOp2,      // either RD2 or imm
    input  logic [2:0]             aluCtrl,     // alu selection of instruction
    output logic [DATA_WIDTH:0]    sum,         // output
    output logic                   eq           // equal/zero flag
);

always_comb 
    case (aluCtrl)
        3'b000: sum = aluOp1 + aluOp2;                     // add
        3'b001: sum = aluOp1 - aluOp2;                     // subtract
        3'b010: sum = aluOp1 & aluOp2;                     // and
        3'b010: sum = aluOp1 | aluOp2;                     // or
        3'b101: sum = (aluOp1-aluOp2 < 0) ? (DATA_WIDTH+1)'d1 : (DATA_WIDTH+1)'d0;  // slt
        default: sum = 0;
    endcase    

assign eq = (sum == 0) ? 1'b1 : 1'b0;           //outputs 1 if equal

endmodule
