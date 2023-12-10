module main_decoder (
    input  logic                 eq_i,           // the Zero Flag
    input  logic   [ 6 : 0 ]     op_i,           // Opcode
    input logic    [ 2 : 0 ]     funct3_i        // selects what type of arithmetic for ALU
    output logic                 pc_src_o,       // selects next value for pc: [0] next instruction from mem, [1] jump & branch instructions 
    output logic                 result_src_o,   // selects data write into register : [0] from ALU ouput, [1] from datamem
    output logic                 mem_write_o,    // [1] to enable write to memory
    output logic                 alu_src_o,      // selects input into alu: [1] to select an immediate, [0] from register
    output logic   [ 2 : 0 ]     imm_src_o,      // used to select what type of instruction and its needed extension
    output logic                 reg_write_o,    // [1] to enable write to registers
    output logic   [ 1 : 0 ]    alu_op_o,        // to select what type of opertion ALU completes
    output logic                jalr_pc_src_o,   //selcts if jalr instructionj: [1] jalr, [0] if not

    
);

logic branch; 
logic jal;

always_latch
    case (op_i)
        7'b0000011: begin // I type instruction -- load
            reg_write_o = 1'b1;  //write data to reg
            imm_src_o = 3'b000;
            alu_src_o = 1'b1;   //immediate
            mem_write_o = 1'b0;
            result_src_o = 1'b1; //from data mem
            branch = 1'b0;
            alu_op_o = 2'b00;
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;
        end
        7'b0110011: begin // R type instruction -- arthametic
            reg_write_o = 1'b1;
            imm_src_o = 3'b000; 
            alu_src_o = 1'b0;
            mem_write_o = 1'b0;
            result_src_o = 1'b0;
            branch = 1'b0;
            alu_op_o = 2'b10;
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;
        end
        7'b0100011: begin // S type instruction -- Store
            reg_write_o = 1'b0;
            imm_src_o = 3'b001;
            alu_src_o = 1'b1;
            mem_write_o = 1'b1;
            result_src_o = 1'b0;
            branch = 1'b0;
            alu_op_o = 2'b00;
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;

        end
        7'b0010011: begin // I type instruction -- Logical
            reg_write_o = 1'b1;
            imm_src_o = 3'b000;
            alu_src_o = 1'b1;
            mem_write_o = 1'b0;
            result_src_o = 1'b0;
            branch = 1'b0;
            alu_op_o = 2'b10;
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;

        end
        7'b1100011: begin // B type instruction -- Branch
            reg_write_o = 1'b0;
            imm_src_o = 3'b010;
            alu_src_o = 1'b0;
            mem_write_o = 1'b0;
            result_src_o = 1'b0; 
            branch = 1'b1;
            alu_op_o = 2'b01;
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;

        end

        7'b1101111: begin // J type instruction -- JAL
            reg_write_o = 1'b1;
            imm_src_o = 3'b000;
            alu_src_o = 1'b1; 
            mem_write_o = 1'b0;
            result_src_o = 1'b0; 
            branch = 1'b0;
            alu_op_o = 2'b00;
            jal = 1'b1;
            jalr_pc_src_o = 1'b0;

        end
        7'b1100111: begin // I type instruction -- JALR
            reg_write_o = 1'b1;
            imm_src_o = 3'b000; 
            alu_src_o = 1'b1; 
            mem_write_o = 1'b0;
            result_src_o = 1'b0; 
            branch = 1'b0;
            alu_op_o = 2'b00; 
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;

        end

        7'b0010111: begin // U-instruction -- auipc
            reg_write_o = 1'b1;
            imm_src_o = 3'b100; 
            alu_src_o = 1'b0; 
            mem_write_o = 1'b0;
            result_src_o = 1'b1; 
            branch = 1'b1;
            alu_op_o = 2'b00; 
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;

        end
          7'b0110111: begin // U type instruction -- lui
            reg_write_o = 1'b1;
            imm_src_o = 3'b100; 
            alu_src_o = 1'b0; 
            mem_write_o = 1'b0;
            result_src_o = 1'b0; 
            branch = 1'b0;
            alu_op_o = 2'b10; 
            jal = 1'b0;
            jalr_pc_src_o = 1'b0;

        end

        default: begin
            reg_write_o = 1'b0;
            imm_src_o = 3'b000;
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
