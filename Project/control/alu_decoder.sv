module aludecoder( 
    input  logic [2:0]    funct3,
    input  logic          funct7,
    input  logic [1:0]    alu_op,
    input  logic[6:0]     op,
    output logic[2:0]     alu_control    
    );
 always_comb
    case (alu_op)   
        2'b00: alu_control = 000;  //add for sw,lw
        2'b01: alu_control = 001;  //subtract for beq
        2'b10:
            case(funct3)
              3'b000:
                if ((op[5] & funct7)==1) alu_control = 001;  //subtract for sub
                else alu_control=000;  //add for add
              3'b010: alu_control=101;  //set less than for slt
              3'b110: alu_control=011;  //or for or
              3'b111: alu_control=010;  //and for and
            endcase

    endcase

endmodule
