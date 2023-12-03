module alu_decoder( 
    input  logic [2:0]    funct3_i,
    input  logic          funct7_i,
    input  logic [1:0]    alu_op,
    input  logic[6:0]     op_i,
    output logic[3:0]     alu_control_o   //4 bit width to account for other instructions
    );
  
 always_comb
    case (alu_op)   
        2'b00: alu_control_o = 000;  //add for sw,lw
        2'b01: alu_control_o = 001;  //subtract for beq
        2'b10:
            case(funct3)
              3'b000:
                if (op[5]==1 & funct7==1) 
                alu_control_o = 4'b0001;  //subtract for sub
                else alu_control_o=4'b0000;  //add
              3'b010: alu_control_o=4'b0101;  //slt
              3'b110: alu_control_o=4'b0011;  //or
              3'b111: alu_control_o=4'b0010;  //and
              3'b001: alu_control_o=4'b0100; //sll
              3'b101: if(funct7_i == 0) alu_control_o = 4'b0110 //srl
              else alu_control_o = 4'b0110; //sra
              3'b100: alu_control_o = 4'b1001;

            endcase

    endcase

endmodule
