module alu #(
    parameter DATA_WIDTH = 32
)(
    input  logic [DATA_WIDTH-1:0]    alu_op1,     // RD1 
    input  logic [DATA_WIDTH-1:0]    alu_op2,     // either RD2 or imm
    input  logic [2:0]               alu_ctrl,    // alu selection of instruction
    output logic [DATA_WIDTH-1:0]    sum,         // output
    output logic                     eq           // equal/zero flag
);

always_comb 
    case (alu_ctrl)
        3'b000: sum = alu_op1 + alu_op2;          // add
        3'b001: sum = alu_op1 - alu_op2;          // subtract
        3'b010: sum = alu_op1 & alu_op2;          // and
        3'b011: sum = alu_op1 | alu_op2;          // or
        // Note on following line:
        // Previously, the condition was alu_op1-alu_op2 < 0
        // But output is unsigned, so < 0 is always false.
        // Instead checking MSB
        3'b101: sum = ((alu_op1-alu_op2) >= 2**(DATA_WIDTH-1)) ? {{DATA_WIDTH-1{1'b0}}, 1'b1} : {DATA_WIDTH{1'b0}};  // slt
        default: sum = 0;
    endcase    

assign eq = (sum == 0) ? 1'b1 : 1'b0;             //outputs 1 if equal

endmodule
