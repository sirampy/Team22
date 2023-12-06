module alu_decoder (
    input  logic          op5,          // opcode bit 5
    input  logic [2:0]    funct3,
    input  logic          funct7,       // funct7 bit 5
    input  logic [1:0]    alu_op,       // from main decoder
    output logic [2:0]    alu_control   // select alu operation
);

logic [1:0] op5_funct7;
assign op5_funct7 = {op5, funct7};

always_comb
    case (alu_op)
        2'b00: alu_control = 3'b000;       //add for lw, sw
        2'b01: alu_control = 3'b001;       //subtract for beq
        2'b10: case (funct3)
            3'b000:
                if (op5_funct7 != 2'b11) alu_control = 3'b000;  //add
                else alu_control = 3'b001;                   //subtract
            3'b010: alu_control = 3'b101;  //slt
            3'b110: alu_control = 3'b011;  //or
            3'b111: alu_control = 3'b010;  //and
            default: alu_control = 3'b0;
        endcase
        default: alu_control = 3'b0;
    endcase

endmodule
