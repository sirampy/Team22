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
        2'b00: alu_control = 000;       //add for lw, sw
        2'b01: alu_control = 001;       //subtract for beq
        2'b10: case (funct3)
            3'b000: begin
                if (op5_funct7 != 11) alu_control = 000;  //add
                else alu_control = 001;                   //subtract
            end
            3'b010: alu_control = 101;  //slt
            3'b110: alu_control = 011;  //or
            3'b010: alu_control = 111;  //and
        endcase
    endcase

endmodule
