module maindecoder(
    input logic [6:0]   op_i,
    input logic     zero_i,
    output logic    result_src_o,
    output logic    mem_write_o,
    output logic    alu_src_o,
    output logic[2:0]   imm_src_o,
    output logic    reg_write_o,
    output logic [1:0]  alu_op_o,
    output logic    pc_src_o,
    output logic    branch_o
);
always_comb
case(op)
    default: begin
                reg_write = 1'b0; //default case
                imm_src = 2'b00;
                alu_src = 1'b0;
                mem_write = 1'b0;
                result_src = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
            end
    7'b0000011: //lw intruction
                reg_write = 1'b1;
                imm_src = 2'b00;
                alu_src = 1'b1;
                mem_write = 1'b0;
                result_src = 1'b1;
                branch = 1'b0;
                alu_op = 2'b00;

    7'b0100011: //sw instruction
                reg_write = 1'b0;
                imm_src = 2'b01;
                alu_src = 1'b1;
                mem_write = 1'b1;
                result_src = 1'b0;
                branch = 1'b0;
                alu_op = 2'b00;
    7'b0110011: //r-type instruction
                reg_write = 1'b1;
                imm_src = 2'b00;
                alu_src = 1'b0;
                mem_write = 1'b0;
                result_src = 1'b0;
                branch = 1'b0;
                alu_op = 2'b10;
    7'b1100011: //beq instruction
                reg_write = 1'b0;
                imm_src = 2'b10;
                alu_src = 1'b0;
                mem_write = 1'b0;
                result_src = 1'b0;
                branch = 1'b1;
                alu_op = 2'b01;
    7'b1101111: //jump and link instruction
                reg_write = 1'b1;
                imm_src = 2'b11;
                alu_src = 1'b0;
                mem_write = 1'b0;
                result_src = 1'b0;
                branch = 1'b1;
                alu_op = 2'b00;
    7'b0110111: //load upper immediate
                reg_write = 1'b1;
                imm_src = ;
                alu_src = 1'b1;
                mem_write = 1'b0;
                result_src = 1'b0;
                branch = 1'b1;
                alu_op = 2'b11;

end case
assign pc_src= branch&zero;

endmodule
