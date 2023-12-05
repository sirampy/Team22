module alu_decoder( 
    input  logic [2:0]    funct3_i,
    input  logic          funct7_i,
    input  logic [1:0]    alu_op_i,
    input  logic[6:0]     op_i,
    output logic[3:0]     alu_control_o   //4 bit width to account for other instructions
    );
  
 always_comb
    case (alu_op)   
        2'b00: alu_control_o = 4'b0000;  //add for sw,lw
        2'b01: 
            case(funct3_i)
            3'b000: alu_control_o = 4'b0001; //beq
            //could add more b-type instructions
            endcase
        2'b10:
            case(funct3_i)
              3'b000:
                if (op_i[5]==1 & funct7_i==1) 
                alu_control_o = 4'b0001;  //subtract for sub
                else alu_control_o=4'b0000;  //add
              3'b010: alu_control_o=4'b0101;  //slt
              3'b110: alu_control_o=4'b0011;  //or
              3'b111: alu_control_o=4'b0010;  //and
              3'b001: alu_control_o=4'b0100; //sll
              3'b101: if(funct7_i == 0) alu_control_o = 4'b0110 //srl
              else alu_control_o = 4'b0110; //sra
              3'b100: alu_control_o = 4'b1001; //xor
              default: alu_control_o = 4'b0000; 
            endcase
        default: alu_control_o = 4'b0000; // default case for alu_op_i - jalr
    endcase
endmodule
