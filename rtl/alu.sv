module alu #(

    parameter DATA_WIDTH = 32

) (

    input  logic [ DATA_WIDTH - 1 : 0 ]  op1_i,  // ALU input 1: Always rs1
    input  logic [ DATA_WIDTH - 1 : 0 ]  op2_i,  // ALU input 2: Either rs2 or imm
    input  logic [ 3 : 0 ]               ctrl_i, // ALU operation

    output logic [ DATA_WIDTH - 1 : 0 ]  out_o,  // ALU output
    output logic                         eq_o    // Equal/zero flag: (ALU output == 0)

);

always_comb 
    case ( ctrl_i )
        4'b0000: out_o = op1_i + op2_i; // ADD
        4'b0001: out_o = op1_i - op2_i; // SUB
        4'b0010: out_o = op1_i & op2_i; // AND
        4'b0011: out_o = op1_i | op2_i; // OR
        4'b0101: out_o = ( ( op1_i - op2_i ) >= 2 ** ( DATA_WIDTH - 1 ) ) // SLT
                         ? { { DATA_WIDTH - 1 { 1'b0 } }, 1'b1 }
                         : { DATA_WIDTH { 1'b0 } };
        
        4'b0100: out_o= op1_i << op2_i; //SLL
        4'b0110: out_o= op1_i >> op2_i;  // SRL
        4'b0111: out_o = op1_i >>> op2_i; // SRA
        4'b1000: out_o={ { DATA_WIDTH - 1 { 1'b0 } },(op1_i < op2_i)}; // SLTU
        4'b1001: out_o = op1_i ^ op2_i; // XOR
        default: out_o = { DATA_WIDTH { 1'b0 } };
    endcase

assign eq_o = ( out_o == 0 ) ? 1'b1 : 1'b0; // Computes equal flag

endmodule
