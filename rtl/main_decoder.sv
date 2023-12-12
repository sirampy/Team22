module main_decoder (

    input logic            eq_i,         // Equal/Zero flag
    input logic [ 6 : 0 ]  op_i,         // Instruction ppcode
    input logic [ 2 : 0 ]  funct3_i,     // ALU operation select (from instruction)
    
    output logic           pc_src_o,     // [0] - Increment PC by 4, [1] - Increment PC by immediate value
    output logic           result_src_o, // [0] - Write ALU output to register, [1] - Write memory value to register
    output logic           mem_write_o,  // Memory write enable
    output logic           alu_src_o,    // [0] - Use register as ALU input, [1] - Use immediate value as ALU input
    output logic [ 2 : 0 ] imm_src_o,    // Immediate value type
    output logic           reg_write_o,  // Register write enable
    output logic [ 1 : 0 ] alu_op_o,     // [00] - LW/SW, [01] - B-type, [10] - Mathematical expression (R-type or I-type)
    output logic           jalr_pc_src_o, // [1] Write JALR register to PC, [0] Otherwise
    output logic           Jstore_o       // When high (only for jump), pc+4 written to regfile

);

logic branch; // [1] - Branch, [0] Otherwise
logic jal;    // [1] - JAL, [0] Otherwise

always_comb
    case ( op_i )
        7'b0000011: // I-type load
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b000;
                alu_src_o = 1'b1;
                mem_write_o = 1'b0;
                result_src_o = 1'b1;
                branch = 1'b0;
                alu_op_o = 2'b00;
                jal = 1'b0;
                jalr_pc_src_o = 1'b0;
                Jstore_o = 1'b0;
            end
        7'b0110011: // R-type
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b000; 
                alu_src_o = 1'b0;
                mem_write_o = 1'b0;
                result_src_o = 1'b0;
                branch = 1'b0;
                alu_op_o = 2'b10;
                jal = 1'b0;
                jalr_pc_src_o = 1'b0;
                Jstore_o = 1'b0;
            end
        7'b0100011: // S-type
            begin
                reg_write_o = 1'b0;
                imm_src_o = 3'b001;
                alu_src_o = 1'b1;
                mem_write_o = 1'b1;
                result_src_o = 1'b0;
                branch = 1'b0;
                alu_op_o = 2'b00;
                jal = 1'b0;
                jalr_pc_src_o = 1'b0;
                Jstore_o = 1'b0;
            end
        7'b0010011: // I-type arithmetic
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b000;
                alu_src_o = 1'b1;
                mem_write_o = 1'b0;
                result_src_o = 1'b0;
                branch = 1'b0;
                alu_op_o = 2'b10;
                jal = 1'b0;
                jalr_pc_src_o = 1'b0;
                Jstore_o = 1'b0;
            end
        7'b1100011: // B-type
            begin
                reg_write_o = 1'b0;
                imm_src_o = 3'b010;
                alu_src_o = 1'b0;
                mem_write_o = 1'b0;
                result_src_o = 1'b0; 
                branch = 1'b1;
                alu_op_o = 2'b01;
                jal = 1'b0;
                jalr_pc_src_o = 1'b0;
                Jstore_o = 1'b0;
            end
        7'b1101111: // JAL
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b000;
                alu_src_o = 1'b1; 
                mem_write_o = 1'b0;
                result_src_o = 1'b0; 
                branch = 1'b0;
                alu_op_o = 2'b00;
                jal = 1'b1;
                jalr_pc_src_o = 1'b0;
                Jstore_o = 1'b1;
            end
        7'b1100111: // JALR
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b000; 
                alu_src_o = 1'b1; 
                mem_write_o = 1'b0;
                result_src_o = 1'b0; 
                branch = 1'b0;
                alu_op_o = 2'b00; 
                jal = 1'b0;
                jalr_pc_src_o = 1'b1;
                Jstore_o = 1'b1;
            end
        7'b0010111: // AUIPC
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b100; 
                alu_src_o = 1'b0; 
                mem_write_o = 1'b0;
                result_src_o = 1'b1; 
                branch = 1'b1;
                alu_op_o = 2'b00; 
                jal = 1'b0;
                jalr_pc_src_o = 1'b0;
                Jstore_o = 1'b0;
            end
        7'b0110111: // LUI
            begin
                reg_write_o = 1'b1;
                imm_src_o = 3'b100; 
                alu_src_o = 1'b0; 
                mem_write_o = 1'b0;
                result_src_o = 1'b0; 
                branch = 1'b0;
                alu_op_o = 2'b10; 
                jal = 1'b0;
                jalr_pc_src_o = 1'b0;
                Jstore_o = 1'b0;
            end
        default: // Should never occur
            begin
                reg_write_o = 1'b0;
                imm_src_o = 3'b000;
                alu_src_o = 1'b0;
                mem_write_o = 1'b0;
                result_src_o = 1'b0;
                branch = 1'b0;
                alu_op_o = 2'b00;
                jal = 1'b0;
                jalr_pc_src_o = 1'b0;
                Jstore_o = 1'b0;
            end
    endcase

always_comb
    if ( jal == 1'b1 )
        pc_src_o = 1'b1;
    else
        casez ( funct3_i )
            3'b000: // BEQ
                pc_src_o = ( branch && eq_i ) ? 1'b1 : 1'b0;
            3'b001: // BNE
                pc_src_o = ( branch && eq_i ) ? 1'b0 : 1'b1;
            default: pc_src_o = 1'b0; // By default, do not jump
        endcase

endmodule
