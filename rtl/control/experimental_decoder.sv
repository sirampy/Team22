module decoder (
    input [31:0]    instr_i,

)

typedef enuum logic [6:0] { 
    R     = 7'b0110011,
    I_LD  = 7'b0000011,
    I_ALU = 7'b0010011,
    S     = 7'b0100011,
    B     = 7'b1100011,
    U_AUIPC = 7'b0010111,
    U_LUI   = 7'b0110111,
    J       = 7'b1101111,
    I_JALR  = 7'b1100111,
    I_ENV   = 7'b1110011,

    // others / extensions (just for fun):
    R_ATOMIC = 7'b0101111,
    FENCE    = 7'b0001111

 } opc_t;

endmodule