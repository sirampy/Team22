// package control_types;

// all of these should be put into a package
typedef enum logic [6:0] { 
    R     = 7'b0110011,
    I_ALU = 7'b0010011,
    I_LD  = 7'b0000011,
    S     = 7'b0100011,
    B     = 7'b1100011,
    U_AUIPC = 7'b0010111,
    U_LUI   = 7'b0110111,
    J       = 7'b1101111,
    I_JALR  = 7'b1100111,
    I_ENV   = 7'b1110011,
    FENCE   = 7'b0001111,

    // extensions (incomplete and just for fun):
    R_ATOMIC = 7'b0101111
} opc_t;

typedef enum logic [2:0] { 
    ADD = 0,
    L_SHIFT = 1,
    SLT = 2,
    U_SLT = 3,
    XOR = 4,
    R_SHIFT = 5,
    OR = 6,
    AND = 7
} alu3_t; // these are the same values as would be assigned by default - im just showing them for clarity

typedef enum logic [2:0] {
    BYTE = 0,
    HALF = 1,
    WORD = 2,
    U_BYTE = 4,
    U_HALF = 5
} load3_t;

typedef enum logic [2:0] {
    EQ = 0,
    NE = 1,
    LT = 4,
    GE = 5,
    LTU = 6,
    GEU = 7
} branch3_t;

typedef union packed {
    alu3_t alu;
    load3_t load;
    branch3_t branch;
} funct3_t;

typedef enum logic [6:0] { 
    I_STD = 0,      // Intiger -> standard
    I_NEG = 7'h20,  // Intiger -> negative (for SUB and ASL)
    I_MUL = 7'h01   // multiply extension example (unimplemented)
 } alu7_t; 
// we dont need a union for alu7_t as they are only used in R instructions my I and M (as far as i know) 

typedef enum logic [1:0] { 
    RS1 = 0,
    ZERO = 1,
    PC = 2
  } src1_t;

 typedef enum logic[2:0] { 
    RS2 = 0,
    IS_IMM12 = 1, // for I and S type instructions
    B_IMM12 = 2,
    U_IMM = 3,
    J_IMM = 4 // this is the least efficient use of 3 bits possible with an enum :(
  } src2_t;

typedef enum logic { 
    RESULT = 0, // alu / data_mem
    NEXT_PC = 1
 } srcr_t;

typedef enum logic [1:0] {
    NEXT = 0,
    BRANCH = 1,
    JUMP = 2 // unconditional branch
 } next_pc_t;

// endpackage
