module alu (   
    
    input  data_val i_opnd1, // Operand 1 ( reg1 )
    input  data_val i_opnd2, // Operand 2 ( reg2 or imm )
    input  alu_optr i_optr,  // Operator ( funct7 [ 5 ], funct3 ) / Operation select

    output data_val o_out    // Output

);

always_comb 
    case ( i_optr.funct3 )
        ALU_ADD:
            if ( i_optr.funct7_5 == 0 )
                o_out = i_opnd1 + i_opnd2; // ADD, ADDI
            else
                o_out = i_opnd1 - i_opnd2; // SUB
        ALU_SLL:
            o_out = i_opnd1 << i_opnd2;
        ALU_SLT:
            /*if ( i_opnd1 [ DATA_WIDTH - 1 ] == i_opnd2 [ DATA_WIDTH - 1 ] )
                o_out = ( i_opnd1 - i_opnd2 ) >> ( 2 ** ( DATA_WIDTH - 1 ) ) == 1 ? 1 : 0; // ( Checking ( i_opnd1 - i_opnd2 ) < 0 )
            else
                o_out = i_opnd1 [ DATA_WIDTH - 1 ] ? 1 : 0;*/
            o_out = $signed(i_opnd1) < $signed(i_opnd2) ? 1 : 0;
        ALU_SLTU:
            /*if ( i_opnd1 [ DATA_WIDTH - 1 ] == i_opnd2 [ DATA_WIDTH - 1 ] )
                o_out = ( i_opnd1 - i_opnd2 ) >> ( 2 ** ( DATA_WIDTH - 1 ) ) == 1 ? 1 : 0; // ( Checking ( i_opnd1 - i_opnd2 ) < 0 )
            else
                o_out = i_opnd2 [ DATA_WIDTH - 1 ] ? 1 : 0;*/
            o_out = i_opnd1 < i_opnd2 ? 1 : 0;
        ALU_XOR:
            o_out = i_opnd1 ^ i_opnd2;
        ALU_SRL:
            if ( i_optr.funct7_5 == 0 )
                o_out = i_opnd1 >> i_opnd2; // SRL
            else
                o_out = $signed(i_opnd1) >>> i_opnd2; // SRA
        ALU_OR:
            o_out = i_opnd1 | i_opnd2;
        ALU_AND:
            o_out = i_opnd1 & i_opnd2;
    endcase

endmodule
