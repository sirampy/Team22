module maindecoder(
    input logic [6:0]   op,
    input logic     zero,
    output logic    result_src,
    output logic    mem_write,
    output logic    alu_src,
    output logic[2:0]   imm_src,
    output logic    reg_write,
    output logic [1:0]  alu_op,
    output logic    pc_src,
    output logic    branch,
    output logic    jump
);
always_comb
case(op)
    default: begin
                reg_write = 1'b0; //default case
                imm_src = 3'b000;
                alu_src = 1'b0;
                mem_write = 1'b0;
                result_src = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
                jump = 2'b00;
            end
    7'b0000011: //lw intruction
                reg_write = 1'b1;
                imm_src = 3'b000;
                alu_src = 1'b1;
                mem_write = 1'b0;
                result_src = 1'b1;
                branch = 1'b0;
                alu_op = 2'b00;
                jump = 2'b00;

    7'b0100011: //sw instruction
                reg_write = 1'b0;
                imm_src = 3'b001;
                alu_src = 1'b1;
                mem_write = 1'b1;
                result_src = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
                jump = 2'b00;

    7'b0110011: //r-type instruction
                reg_write = 1'b1;
                imm_src = 2'b000;
                alu_src = 1'b0;
                mem_write = 1'b0;
                result_src = 1'b0;
                branch = 1'b0;
                alu_op = 2'b10;
                jump = 2'b00;

    7'b1100011: //beq instruction
                reg_write = 1'b0;
                imm_src = 3'b010;
                alu_src = 1'b0;
                mem_write = 1'b0;
                result_src = 1'b0;
                branch = 1'b1;
                alu_op = 2'b01;
                jump = 2'b00;

    7'b0110111: //u-type
                reg_write = 1'b1;
                imm_src = 3'b100;
                alu_src = 1'b1; 
                mem_write = 1'b0; 
                result_src = 2'b00; 
                branch = 1'b0; 
                alu_op = 2'b11;
                jump = 2'b00;

    7'b1101111: //jump and link instruction
                reg_write = 1'b1;
                imm_src = 3'b011;
                alu_src = 1'bx; //dont care as alu isnt used
                mem_write = 1'b0; //instruction isnt a store
                result_src = 2'b10; //to write pc+4 into rd
                branch = 1'b0; //not a branch
                alu_op = 2'bxx;// dont care as alu isnt used
                jump = 2'b01;
    7'b1101111: //jalr
                reg_write = 1'b1;
                imm_src = 3'b111;
                alu_src = 1'b1;
                mem_write = 1'b0;
                result_src = 2'b00; 
                branch = 1'b0; //not a branch
                alu_op = 2'b10;
                jump = 2'b10;

    

endcase
assign pc_src= branch&zero;

endmodule
