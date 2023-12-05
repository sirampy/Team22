

module branch_tester(
    input signed [31:0] src1_i,
    input signed [31:0] src2_i,

    input branch3_t branch3_i,
    input next_pc_t pc_control_i,

    output jump_o // we could use an enum, but that would be overcomplecating things
);

always_comb
case(pc_control_i)
    NEXT: jump_o = 0;

    BRANCH: begin

        case(branch3_i)
            EQ: jump_o = src1_i == src2_i;
            NE: jump_o = src1_i != src2_i;
            LT: jump_o = src1_i < src2_i;
            GE: jump_o = src1_i >= src2_i;
            LTU: jump_o = {1'b0, src1_i} < {1'b0, src2_i};
            GEU: jump_o = {1'b0, src1_i} >= {1'b0, src2_i};
            
            default: $error("unrecognised branch condition");
        endcase

    end

    JUMP: jump_o = 1; 
endcase

endmodule
