module main_decoder (
    input  logic [6:0]    op_i,           // opcode
    
    output logic [1:0]    result_src_o,   // select write input
    output logic          mem_write_o,    // memory write enable
    output logic          alu_src_o,      // select rd2 or imm
    output logic [1:0]    imm_src_o,      // imm select
    output logic          reg_write_o,    // register write enable
    output logic [1:0]    alu_op_o,        // to input into alu decoder
    output logic          branch_o
);

always_comb
    case (op_i)
        7'b0000011: begin // load
            reg_write_o = 1'b1;
            imm_src_o = 2'b00;
            alu_src_o = 1'b1;
            mem_write_o = 1'b0;
            result_src_o = 1'b1;
            branch_o = 1'b0;
            alu_op_o = 2'b00;
        end
        7'b0010011: begin // arithmetic operations
            reg_write_o = 1'b1;
            alu_src_o = 1'b0;
            mem_write_o = 1'b0;
            result_src_o = 1'b0;
            branch_o = 1'b0;
            alu_op_o = 2'b10;
        end
        7'b0100011: begin // store
            reg_write_o = 1'b0;
            imm_src_o = 2'b01;
            alu_src_o = 1'b1;
            mem_write_o = 1'b1;
            branch_o = 1'b0;
            alu_op_o = 2'b00;
        end
        7'b1100011: begin // branch
            reg_write_o = 1'b0;
            imm_src_o = 2'b10;
            alu_src_o = 1'b0;
            mem_write_o = 1'b0;
            branch_o = 1'b0;
            alu_op_o = 2'b01;
        end
        default: begin
            reg_write_o = 1'b0;
            imm_src_o = 2'b00;
            alu_src_o = 1'b0;
            mem_write_o = 1'b0;
            result_src_o = 1'b0;
            branch_o = 1'b0;
            alu_op_o = 2'b00;
        end
    endcase

endmodule
