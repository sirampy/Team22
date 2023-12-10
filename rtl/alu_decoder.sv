module alu_decoder ( 

    input logic [ 2 : 0 ] funct3_i,     // ALU operation select (from instruction)
    input logic           funct7_i,     // funct7[5]: [1] - SUB/ASR, [0] - ADD/LSL (for same funct3)
    input logic           op5_i,        // operand[5]: [1] - B-type, S-type, R-type, LUI, JALR, JALR  [0] - Otherwise
    input logic [ 1 : 0 ] alu_op_i,     // [00] - LW/SW, [01] - B-type, [10] - Mathematical expression (R-type or I-type)

    output logic[ 3 : 0 ] alu_control_o // ALU operation select (to ALU)
                                        // Changed to 4 bit (from 3) to account for other instructions
);

logic [ 1 : 0 ] op5_funct7; // [0X] - I-type so no SUB, [10] - R-type ADD, [11] - R-type SUB
assign op5_funct7 = { op5_i, funct7_i };

always_comb
    case ( alu_op_i )
        2'b00: alu_control_o = 4'b0000; // LW/SW - Want to ADD
        2'b01:
            case ( funct3_i )
                3'b000: alu_control_o = 4'b0001;  // BEQ - Want to SUB
                3'b001: alu_control_o = 4'b0001;  // BNE - Want to SUB
                default: alu_control_o = 4'b????; // Don't care condition/signal unknown
                // 3'b100: // BLT
                // 3'b101: // BGE
                // 3'b110: // BLTU
                // 3'b111: // BGEU
            endcase
        2'b10:
            case ( funct3_i )
                3'b000: if  ( op5_funct7 != 2'b11 )
                        alu_control_o = 4'b0001;        // SUB
                    else alu_control_o = 4'b0000;       // ADD or I-type
                3'b001: alu_control_o = 4'b0100;        // SLL
                3'b010: alu_control_o = 4'b0101;        // SLT
                // 3'b011: // SLTU
                3'b100: alu_control_o = 4'b1001;        // XOR
                3'b101: if ( funct7_i == 0 )
                    alu_control_o = 4'b0110;            // SRL - Don't care about I-type as it's the same
                else alu_control_o = 4'b0110;           // SRA - Don't care about I-type as it's the same
                3'b110: alu_control_o = 4'b0011;        // OR
                3'b111: alu_control_o = 4'b0010;        // AND
        
                default: alu_control_o = 4'b0000;
            endcase
        
        default: alu_control_o = 4'b0000; 
    endcase

endmodule
