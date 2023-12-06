module alu #(
    parameter DATA_WIDTH = 32
)(
    input  logic [DATA_WIDTH-1:0]    aluOp1_i,      // RD1 
    input  logic [DATA_WIDTH-1:0]    aluOp2_i,      // either RD2 or imm
    input  logic [2:0]               aluCtrl_i,     // alu selection of instruction
    output logic [DATA_WIDTH-1:0]    sum_o,         // output
    output logic                     eq_o           // equal/zero flag
);

always_comb 
    case (aluCtrl_i)
        3'b000: sum_o = aluOp1_i + aluOp2_i;              // add
        3'b001: sum_o = aluOp1_i - aluOp2_i;              // subtract
        3'b010: sum_o = aluOp1_i & aluOp2_i;              // and
        3'b100: sum_o = aluOp1_i | aluOp2_i;              // or
        3'b101: sum_o = (aluOp1_i < aluOp2_i) ? {{DATA_WIDTH-1{1'b0}}, 1'b1} : {DATA_WIDTH{1'b0}};  // slt
        default: sum_o = 0;
    endcase    

assign eq_o = (sum_o == 0) ? 1'b1 : 1'b0;           //outputs 1 if equal

endmodule
