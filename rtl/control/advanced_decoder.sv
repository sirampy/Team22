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

typedef enum logic [2:0] {
    ZERO = 0
} zero3_t; // used to verify instructions like JALR, ECALL, EBREAK

typedef union packed {
    alu3_t alu;
    load3_t load;
    branch3_t branch;
    zero3_t zero;
} funct3_t;

typedef enum logic [6:0] { 
    I_STD = 0,      // Intiger -> standard
    I_NEG = 7'h20,  // Intiger -> negative (for SUB and ASL)
    I_MUL = 7'h01   // multiply extension example (unimplemented)

 } alu7_t; 

 // we dont need a union for alu7_t as they are only used in R instructions my I and M (as far as i know) 

module decoder (
    input [31:0]    instr_i,

    // operation
    output alu3_t   alu3_o,
    output alu7_t   alu7_o, // we keep this as all 7 bits. whilst it might seem wasteful, other extensions (EG: RV32M) use funct7, and this keeps things nice and modular.
    output load3_t  load3_o,
    output branch3_t

    // opperands
    output imm_o,
    output use_imm_o,
    output [4:0]    rs1_o,
    output [4:0]    rs2_o,

    // result
    output [4:0] rd_o,    // dest. register
    output reg_write_o,
    output data_read_o,   // load from data_mem
    output data_write_o,  // store to data_mem
    output branch_o,
 
)

assign opc_t opc = instr_i [6:0];
assign alu7_t funct7 = instr_i [31:25];
assign funct3_t funct3 = instr_i [14:12];

assign logic [4:0] rd = instr_i[11:7];
assign logic [4:0] rs1 = instr_i[19:15];
assign logic [4:0] rs2 = instr_i[24:20];

assign logic [11:0] i_imm = instr_i[31:20];
assign logic [11:0] s_imm = {instr_i[31:25], instr_i[11:7]};
assign logic [11:0] b_imm = {instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8]};

// this is where the magic happens
always_comb begin
    case(opc)
        R: begin

            alu3_o = funct3;
            alu7_o = funct7;

            use_imm_o = 0;
            rs1_o = rs1;
            rs2_o = rs2;

            rd_o = rd;
            reg_write_o = 1;
            data_read_o = 0;
            data_write_o = 0;
            branch_o = 0;

        end

        I_ALU: begin

            alu3_o = funct3;
            alu7_o = (funct3.alu == R_SHIFT) ? i_imm[5:11] : I_STD; // not certain this is entirely correct
           
            imm_o = i_imm;
            use_imm_o = 1;
            rs1_o = rs1;
            rs2_o = 0; 

            rd_o = rd;
            reg_write_o = 1;
            data_read_o = 0;
            data_write_o = 0;
            branch_o = 0;

        end

        I_LD: begin // adds IMM to rs1 and looks it up in the memory
            
            alu3_o = ADD;
            alu7_o = I_STD;
            load3_o = funct3;

            imm_o = i_imm;
            use_imm_o = 1;
            rs1_o = rs1;
            rs2_o = 0; 

            rd_o = rd;
            reg_write_o = 1;
            data_read_o = 1;
            data_write_o = 0;
            branch_o = 0;

        end

        S: begin

            alu3_o = ADD;
            alu7_o = I_STD;
            load3_o = funct3;

            imm_o = i_imm;
            use_imm_o = 1;
            rs1_o = rs1;
            rs2_o = 0; 

            reg_write_o = 0;
            rd_o = rd;
            data_read_o = 0;
            data_write_o = 1;

        end

        B: begin

            alu3_o = ADD;
            alu7_o = I_STD;
            load3_o = funct3;

            imm_o = i_imm;
            use_imm_o = 1;
            rs1_o = rs1;
            rs2_o = 0; 

            reg_write_o = 0;
            data_read_o = 0;
            data_write_o = 0;
            branch_o = 1;
            
        end

        U_AUIPC: begin

        end
        
        U_LUI   :
        J       :
        I_JALR  :
        I_ENV   :
        FENCE   :
        default: $error("unrecognised opcode");
    endcase
end

endmodule