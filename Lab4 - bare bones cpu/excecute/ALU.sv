module alu (
    input  logic [7:0]    aluOp1,      // RD1 
    input  logic [7:0]    aluOp2,      // either RD2 or imm
    input  logic [3:0]    aluCtrl,     // alu selection of instruction
    output logic [7:0]    sum,         // output
    output logic          eq           // equal flag
);

always_comb 
    case (aluCtrl)
        4'b0000: sum = aluOp1 + aluOp2;                     // add
        4'b1111: eq = (aluOp1 == aluOp2) ? 1'b0 : 1'b1;     // bne
        default: begin
            sum = 0;
            eq = 0;
        end
    endcase    

endmodule
