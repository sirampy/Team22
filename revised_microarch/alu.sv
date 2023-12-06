
module alu (
    input signed [31:0] src1_i,
    input signed [31:0] src2_i,

    input alu3_t alu3_i,
    input alu7_t alu7_i,

    output [31:0] result_o
);

always_comb begin
    
    case(alu7_i)
        I_STD:begin 
            case(alu3_i)
                ADD: result_o = src1_i + src2_i;
                L_SHIFT: result_o = src1_i << src2_i [4:0]; // i dont think it is stated in the lectures, but this is correct acc. the riscV manual
                SLT: result_o = (src1_i < src2_i) ? 'b1 : 'b0;
                U_SLT: result_o = ({1'b0, src1_i} < {1'b0, src2_i}) ? 'b1 : 'b0; // this is scuffed. someone pls let me know a better way of doing this.
                XOR: result_o = src1_i ^ src2_i;
                R_SHIFT: result_o = src1_i >> src2_i [4:0]; // logical
                OR: result_o = src1_i | src2_i;
                AND: result_o = src1_i & src2_i;

                default: $error("alu3 not recognised"); // this case should never trigger: above cases are exhaustive
            endcase
        end

        I_NEG:begin 
            case(alu3_i)
                ADD: result_o = src1_i - src2_i;
                R_SHIFT: result_o = src1_i >>> src2_i [4:0];

                default: $error("ALU didn't recognise alu3 - you may be using an unsupported extension");
            endcase
        end

        default: $error("ALU didn't recognise alu7 - you may be using an unsupported extension");
    endcase

end

endmodule
