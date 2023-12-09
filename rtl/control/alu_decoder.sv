module alu_decoder (
    input  logic          op5_i,          // opcode bit 5
    input  logic [2:0]    funct3_i,
    input  logic          funct7_i,       // funct7 bit 5
    input  logic [1:0]    alu_op_i,       // from main decoder
    output logic [2:0]    alu_control_o   // select alu operation
);

logic [1:0] op5_funct7;
assign op5_funct7 = {op5_i, funct7_i};

always_comb begin
    case (alu_op_i)
        2'b00: alu_control_o = 3'b000;       //add for lw, sw
        2'b01: alu_control_o = 3'b001;       //subtract for beq
        2'b10: 
        case (funct3_i)
        3'b000: begin
                if (op5_funct7 != 2'b11) alu_control_o = 3'b000;  //add
                else alu_control_o = 3'b001;                     //subtract
        end
        3'b010: alu_control_o = 3'b101;  //slt
        3'b110: alu_control_o = 3'b011;  //or
        3'b111: alu_control_o = 3'b111;  //and
        default: $error ("unsupported instruction");
        endcase
        default: alu_control_o = 3'b000;
    endcase
end 
endmodule
