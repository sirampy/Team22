module main_decoder (
    input  logic          eq_i,           // equal/zero flag
    input  logic [6:0]    op_i,           // opcode
    output logic          pc_src_o,       // select pc next
    output logic          result_src_o,   // select write input
    output logic          mem_write_o,    // memory write enable
    output logic          alu_src_o,      // select rd2 or imm
    output logic [1:0]    imm_src_o,      // imm select
    output logic          reg_write_o,    // register write enable
    output logic [1:0]    alu_op_o,        // to input into alu decoder
    output logic          jalr_pc_src_o,

    input logic[2:0] funct3_i
);

logic branch; 
logic jal;

always_latch
    case (op_i)
        7'b0000011: begin // load
            reg_write_o = 1'b1;
            imm_src_o = 2'b00;
            alu_src_o = 1'b1;
            mem_write_o = 1'b0;
            result_src_o = 1'b1;
            branch = 1'b0;
            alu_op_o = 2'b00;
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;
        end
        7'b0110011: begin // arithmetic operations
            reg_write_o = 1'b1;
            imm_src_o = 2'b00; 
            alu_src_o = 1'b0;
            mem_write_o = 1'b0;
            result_src_o = 1'b0;
            branch = 1'b0;
            alu_op_o = 2'b10;
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;
        end
        7'b0100011: begin // store
            reg_write_o = 1'b0;
            imm_src_o = 2'b01;
            alu_src_o = 1'b1;
            mem_write_o = 1'b1;
            result_src_o = 1'b0;
            branch = 1'b0;
            alu_op_o = 2'b00;
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;

        end
        7'b0010011: begin // I-type ALU
            reg_write_o = 1'b1;
            imm_src_o = 2'b00;
            alu_src_o = 1'b1;
            mem_write_o = 1'b0;
            result_src_o = 1'b0;
            branch = 1'b0;
            alu_op_o = 2'b10;
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;

        end
        7'b1100011: begin // branch
            reg_write_o = 1'b0;
            imm_src_o = 2'b10;
            alu_src_o = 1'b0;
            mem_write_o = 1'b0;
            result_src_o = 1'b0; 
            branch = 1'b1;
            alu_op_o = 2'b01;
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;

        end

        7'b1101111: begin // JAL
            reg_write_o = 1'b1;
            imm_src_o = 2'b00;
            alu_src_o = 1'b1; 
            mem_write_o = 1'b0;
            result_src_o = 1'b0; 
            branch = 1'b0;
            alu_op_o = 2'b00;
            jal = 1'b1;
            jalr_pc_src_o = 1'b0;

        end
        7'b1100111: begin // JALR
            reg_write_o = 1'b1;
            imm_src_o = 2'b00; 
            alu_src_o = 1'b1; 
            mem_write_o = 1'b0;
            result_src_o = 1'b0; 
            branch = 1'b0;
            alu_op_o = 2'b00; 
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;

        end
        default: begin
            reg_write_o = 1'b0;
            imm_src_o = 2'b00;
            alu_src_o = 1'b0;
            mem_write_o = 1'b0;
            result_src_o = 1'b0;
            branch = 1'b0;
            alu_op_o = 2'b00;
            jal = 1'b0;

        end
    endcase

always_comb
    casez ({jal, funct3_i})
    4'b1???: pc_src_o = 1;
    4'b0001: begin //bne
        if (branch && !eq_i) begin
            pc_src_o = 1;
        end
    end 
    default: pc_src_o = 0;
endcase

endmodule
