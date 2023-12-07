module main_decoder(
    input logic [6:0]   op_i,
    inout logic         zero_i,
    output logic[1:0]    result_src_o,
    output logic    mem_write_o,
    output logic    alu_src_o,
    output logic[2:0] imm_src_o,
    output logic   reg_write_o,
    output logic[1:0] alu_op_o,
    output logic       pc_src_o,
    output logic    branch_o,
    output logic[1:0]   jump_o
);
always_comb
case(op_i)
    default: begin
                reg_write_o = 1'b0; //default case
                imm_src_o = 3'b000;
                alu_src_o = 1'b0;
                mem_write_o = 1'b0;
                result_src_o = 2'b00;
                branch_o = 1'b0;
                alu_op_o = 2'b00;
                jump_o = 2'b00;
            end
    7'b0000011: begin//lw intruction
                reg_write_o = 1'b1;
                imm_src_o = 3'b000;
                alu_src_o = 1'b1;
                mem_write_o = 1'b0;
                result_src_o = 2'b01;
                branch_o = 1'b0;
                alu_op_o = 2'b00;
                jump_o = 2'b00;
    end
    7'b0100011: begin //sw instruction
                reg_write_o = 1'b0;
                imm_src_o = 3'b001;
                alu_src_o = 1'b1;
                mem_write_o = 1'b1;
                result_src_o = 2'b00;
                branch_o = 1'b0;
                alu_op_o = 2'b00;
                jump_o = 2'b00;
    end 
    7'b0110011: begin //r-type instruction
                reg_write_o = 1'b1;
                imm_src_o = 3'b000;
                alu_src_o = 1'b0;
                mem_write_o = 1'b0;
                result_src_o = 2'b00;
                branch_o = 1'b0;
                alu_op_o = 2'b10;
                jump_o = 2'b00;
    end 
    7'b1100011: begin //beq instruction
                reg_write_o = 1'b0;
                imm_src_o = 3'b010;
                alu_src_o = 1'b0;
                mem_write_o = 1'b0;
                result_src_o = 2'b00;
                branch_o = 1'b1;
                alu_op_o = 2'b01;
                jump_o = 2'b00;
    end 
    7'b0110111: begin//u-type
                reg_write_o = 1'b1;
                imm_src_o = 3'b100;
                alu_src_o = 1'b1; 
                mem_write_o = 1'b0; 
                result_src_o = 2'b00; 
                branch_o = 1'b0; 
                alu_op_o = 2'b11;
                jump_o = 2'b00;
    end 
    7'b1101111: begin //jump_o and link instruction
                reg_write_o = 1'b1;
                imm_src_o = 3'b011;
                alu_src_o = 1'bx; //dont care as alu isnt used
                mem_write_o = 1'b0; //instruction isnt a store
                result_src_o = 2'b10; //to write pc+4 into rd
                branch_o = 1'b0; //not a branch_o
                alu_op_o = 2'bxx;// dont care as alu isnt used
                jump_o = 2'b01;
    end
    7'b1101111: begin //jalr
                reg_write_o = 1'b1;
                imm_src_o = 3'b111;
                alu_src_o = 1'b1;
                mem_write_o = 1'b0;
                result_src_o = 2'b00; 
                branch_o = 1'b0; //not a branch_o
                alu_op_o = 2'b10;
                jump_o = 2'b10;
    end 
    

endcase
assign pc_src_o= branch_o&zero_i;

endmodule