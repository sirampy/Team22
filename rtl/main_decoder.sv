module main_decoder (

    input logic [ 6 : 0 ]  op_i,         // Instruction ppcode
    
    output logic [ 1 : 0 ] result_src_o, // [0] - Write ALU output, [1] - Write memory value, [2] - Write PC+4 value
    output logic           mem_write_o,  // Memory write enable
    output logic           alu_src_o,    // [0] - Use register as ALU input, [1] - Use immediate value as ALU input
    output logic [ 2 : 0 ] imm_src_o,    // Immediate value type
    output logic           reg_write_o,  // Register write enable
    output logic [ 1 : 0 ] alu_op_o,     // [00] - LW/SW, [01] - B-type, [10] - Mathematical expression (R-type or I-type)
    output logic           jalr_pc_src_o,// [1] Write JALR register to PC, [0] Otherwise
    output logic           branch_o,      // [1] - Branch, [0] Otherwise
    output logic           write_en_cache

);

always_comb
    casez ( op_i )
        7'b0000011: // I-type load
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b000;
                alu_src_o = 1'b1;
                mem_write_o = 1'b0;
                result_src_o = 2'b01;
                branch_o = 1'b0;
                alu_op_o = 2'b00;
                jalr_pc_src_o = 1'b0;
                write_en_cache = 1'b1
            end
        7'b0110011: // R-type
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b???; 
                alu_src_o = 1'b0;
                mem_write_o = 1'b0;
                result_src_o = 2'b00;
                branch_o = 1'b0;
                alu_op_o = 2'b10;
                jalr_pc_src_o = 1'b0;
            end
        7'b0100011: // S-type
            begin
                reg_write_o = 1'b0;
                imm_src_o = 3'b001;
                alu_src_o = 1'b1;
                mem_write_o = 1'b1;
                result_src_o = 2'b00;
                branch_o = 1'b0;
                alu_op_o = 2'b00;
                jalr_pc_src_o = 1'b0;
            end
        7'b0010011: // I-type arithmetic
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b000;
                alu_src_o = 1'b1;
                mem_write_o = 1'b0;
                result_src_o = 2'b00;
                branch_o = 1'b0;
                alu_op_o = 2'b10;
                jalr_pc_src_o = 1'b0;
            end
        7'b1100011: // B-type
            begin
                reg_write_o = 1'b0;
                imm_src_o = 3'b010;
                alu_src_o = 1'b0;
                mem_write_o = 1'b0;
                result_src_o = 2'b00; 
                branch_o = 1'b1;
                alu_op_o = 2'b01;
                jalr_pc_src_o = 1'b0;
            end
        7'b1101111: // JAL
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b000;
                alu_src_o = 1'b1; 
                mem_write_o = 1'b0;
                result_src_o = 2'b10; 
                branch_o = 1'b0;
                alu_op_o = 2'b00;
                jalr_pc_src_o = 1'b1;
            end
        7'b1100111: // JALR
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b000; 
                alu_src_o = 1'b1; 
                mem_write_o = 1'b0;
                result_src_o = 2'b10; 
                branch_o = 1'b0;
                alu_op_o = 2'b00;
                jalr_pc_src_o = 1'b1;
            end
        7'b0010111: // AUIPC
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b100; 
                alu_src_o = 1'b0; 
                mem_write_o = 1'b0;
                result_src_o = 2'b01; 
                branch_o = 1'b1;
                alu_op_o = 2'b00;
                jalr_pc_src_o = 1'b0;
            end
        7'b0110111: // LUI
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b100; 
                alu_src_o = 1'b0; 
                mem_write_o = 1'b0;
                result_src_o = 2'b00; 
                branch_o = 1'b0;
                alu_op_o = 2'b10; 
                jalr_pc_src_o = 1'b0;
            end
        default: // Should never occur
            begin
                reg_write_o = 1'b?;
                imm_src_o = 3'b???;
                alu_src_o = 1'b?;
                mem_write_o = 1'b?;
                result_src_o = 2'b??;
                branch_o = 1'b?;
                alu_op_o = 2'b??;
                jalr_pc_src_o = 1'b?;
            end
    endcase

endmodule
