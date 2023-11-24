module alu (
    input  logic [7:0]    aluOp1,      // RD1 
    input  logic [7:0]    aluOp2,      // either RD2 or imm
    input  logic [2:0]    aluCtrl,     // alu selection of instruction
    output logic [7:0]    sum,         // output
    output logic          eq           // equal/zero flag
);

always_comb 
    case (aluCtrl)
        3'b000: sum = aluOp1 + aluOp2;                     // add
        3'b001: sum = aluOp1 - aluOp2;                     // subtract
        default: sum = 0;
    endcase    

assign eq = (sum == 0) ? 1'b1 : 1'b0;           //outputs 1 if equal

endmodule
