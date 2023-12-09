module main_decoder (
    input  logic          eq,           // equal/zero flag
    input  logic [6:0]    op,           // opcode
    output logic          pc_src,       // select pc next
    output logic          result_src,   // select write input
    output logic          mem_write,    // memory write enable
    output logic          alu_src,      // select rd2 or imm
    output logic [2:0]    imm_src,      // imm select
    output logic          reg_write,    // register write enable
    output logic [1:0]    alu_op,        // to input into alu decoder
    output logic          jal,  

    input logic[2:0] funct3
);

logic branch; 

always_comb
    case (op)
        7'b0000011: begin // load
            reg_write = 1'b1;
            imm_src = 3'b000;
            alu_src = 1'b1;
            mem_write = 1'b0;
            result_src = 1'b1;
            branch = 1'b0;
            alu_op = 2'b00;
            jal = 1'b0;
        end
        7'b0110011: begin // arithmetic operations
            reg_write = 1'b1;
            imm_src = 3'bxxx; 
            alu_src = 1'b0;
            mem_write = 1'b0;
            result_src = 1'b0;
            branch = 1'b0;
            alu_op = 2'b10;
            jal = 1'b0;
        end
        7'b0100011: begin // store
            reg_write = 1'b0;
            imm_src = 3'b001;
            alu_src = 1'b1;
            mem_write = 1'b1;
            result_src = 1'b0;
            branch = 1'b0;
            alu_op = 2'b00;
            jal = 1'b0;

        end
        7'b0010011: begin // I-type ALU
            reg_write = 1'b1;
            imm_src = 3'b000;
            alu_src = 1'b1;
            mem_write = 1'b0;
            result_src = 1'b0;
            branch = 1'b0;
            alu_op = 2'b10;
            jal = 1'b0;

        end
        7'b1100011: begin // branch
            reg_write = 1'b0;
            imm_src = 3'b010;
            alu_src = 1'b0;
            mem_write = 1'b0;
            result_src = 1'b0; 
            branch = 1'b1;
            alu_op = 2'b01;
            jal = 1'b0;

        end

        7'b1101111: begin // JAL
            reg_write = 1'b1;
            imm_src = 2'b00;
            alu_src = 1'b1; 
            mem_write = 1'b0;
            result_src = 1'b0; 
            branch = 1'b0;
            alu_op = 2'b00;
            jal = 1'b1;

        end
        7'b1100111: begin // JALR
            reg_write = 1'b1;
            imm_src = 2'b00; 
            alu_src = 1'b1; 
            mem_write = 1'b0;
            result_src = 1'b0; 
            branch = 1'b0;
            alu_op = 2'b00; 
            jal = 1'b0;

        end
        default: begin
            reg_write = 1'b0;
            imm_src = 3'b000;
            alu_src = 1'b0;
            mem_write = 1'b0;
            result_src = 1'b0;
            branch = 1'b0;
            alu_op = 2'b00;
            jal = 1'b0;

        end
    endcase

always_comb
    casez ({jal, funct3})
    4'b1xxx: pc_src = 1;
    4'b0001: begin //bne
        if (branch && !eq) begin
            pc_src = 1;
        end
    end 
    default: pc_src = 0;
endcase

endmodule
