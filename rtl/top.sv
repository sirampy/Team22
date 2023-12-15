typedef logic clock;
typedef logic [ 31 : 0 ] data_val;
typedef logic [ 31 : 0 ] instr_val;
typedef logic [ 4 : 0 ] reg_addr;
typedef logic [ 6 : 0 ] opcode;
// Make mem_addr type?

// Modify the following if instruction val and data val are different widths
function instr_val data_val_to_instr_val ( data_val in );
    data_val_to_instr_val = in;
endfunction

typedef union packed {
    struct packed {
        logic [ 6 : 0 ] funct7;
        reg_addr        rs2;
        reg_addr        rs1;
        logic [ 2 : 0 ] funct3;
        reg_addr        rd;
    } R;
    struct packed {
        logic [ 11 : 0 ] imm_11_0;
        reg_addr         rs1;
        logic [ 2 : 0 ]  funct3;
        reg_addr         rd;
    } I;
    struct packed {
        logic [ 11 : 5 ] imm_11_5;
        reg_addr         rs2;
        reg_addr         rs1;
        logic [ 2 : 0 ]  funct3;
        logic [ 4 : 0 ]  imm_4_0;
    } S;
    struct packed {
        logic            imm_12;
        logic [ 10 : 5 ] imm_10_5;
        reg_addr         rs2;
        reg_addr         rs1;
        logic [ 2 : 0 ]  funct3;
        logic [ 4 : 1 ]  imm_4_1;
        logic            imm_11;
    } B;
    struct packed {    
        logic [ 31 : 12 ] imm_31_12;
        reg_addr          rd;
    } U;
    struct packed {    
        logic             imm_20;
        logic [ 10 : 1 ]  imm_10_1;
        logic             imm_11;
        logic [ 19 : 12 ] imm_19_12;
        reg_addr          rd;
    } JAL;
} instr_no_opc;

typedef struct packed {
    instr_no_opc body;
    opcode opc;
} instr;

typedef enum logic [ 1 : 0 ] {
    PC_FREEZE,
    PC_INCR,
    PC_IMM_OFF,
    PC_ALU_OUT
} pc_sel;

typedef enum logic {
    ALU_OPND_1_REG,
    ALU_OPND_1_PC
} alu_opnd_1_sel;

typedef enum logic {
    ALU_OPND_2_REG,
    ALU_OPND_2_IMM
} alu_opnd_2_sel;

typedef enum logic [ 2 : 0 ] {
    ALU_ADD  = 3'b000,
    ALU_SLL  = 3'b001,
    ALU_SLT  = 3'b010,
    ALU_SLTU = 3'b011,
    ALU_XOR  = 3'b100,
    ALU_SRL  = 3'b101,
    ALU_OR   = 3'b110,
    ALU_AND  = 3'b111
} alu_funct3_optr;

typedef struct packed {
    logic funct7_5;
    alu_funct3_optr funct3;
} alu_optr;

typedef enum logic [ 2 : 0 ] {
    L_S_BYTE   = 3'b000,
    L_S_HALF   = 3'b001,
    L_S_WORD   = 3'b010,
    L_S_BYTE_U = 3'b100,
    L_S_HALF_U = 3'b101
} l_s_sel;

typedef enum opcode {
    OPC_L     = 7'b0000011,
    OPC_I     = 7'b0010011,
    OPC_S     = 7'b0100011,
    OPC_R     = 7'b0110011,
    OPC_B     = 7'b1100011,
    OPC_AUIPC = 7'b0010111,
    OPC_LUI   = 7'b0110111,
    OPC_JALR  = 7'b1100111,
    OPC_JAL   = 7'b1101111
} opcode_vals;

typedef enum logic [ 2 : 0 ] {
    PL0_STALL_NONE,
    PL0_STALL_IMM,
    PL0_STALL_BRANCH,
    PL0_STALL_1_BRANCH,
    PL0_STALL_ALU,
    PL0_STALL_1_ALU,
    PL0_STALL_1
} pl0_stall_state;


module top (

    input clock i_clk

);

instr_val       pc_val;
instr           cur_instr_val;
data_val        alu_out_val, ff_val_1, ff_val_2, ff_val_3, ff_val_4, ff_alu_out_val, alu_opnd_1, alu_opnd_2,
                alu_out_mem_val, mem_wr_val, alu_alt_out_val;
reg_addr        ff_addr_2, ff_addr_3, ff_addr_4, reg_wr_addr;
logic           funct3_2XOR0, funct3_0, reg_wr_en, mem_wr_en, mem_rd_en, reg_wr_en4, alu_use_optr;
l_s_sel         l_s_sel_val;
alu_optr        alu_optr_val;
pl0_stall_state pl0_stall_state_val;

pl0_fetch pl0_fetch_ (
    
    .i_clk           ( i_clk ),
    .i_stall_state   ( pl0_stall_state_val ),
    .i_funct3_2XOR0  ( funct3_2XOR0 ),
    .i_imm_val       ( ff_val_1 ),
    .i_alu_out_val   ( ff_alu_out_val ),

    .o_cur_instr_val ( cur_instr_val ),
    .o_pc_val        ( pc_val )

);

pl1_decode pl1_decode_ (

    .i_clk                    ( i_clk ),
    .i_pc_val                 ( pc_val ),
    .i_cur_instr_val          ( cur_instr_val ),
    .i_ff_val_2               ( ff_val_2 ),
    .i_ff_addr_2              ( ff_addr_2 ),
    .i_ff_val_3               ( ff_val_3 ),
    .i_ff_addr_3              ( ff_addr_3 ),
    .i_ff_val_4               ( ff_val_4 ),
    .i_ff_addr_4              ( ff_addr_4 ),
    .i_reg_wr_en              ( reg_wr_en4 ),
    .i_reg_wr_addr            ( ff_addr_4 ),
    .i_reg_wr_val             ( ff_val_4 ),

    .o_alu_opnd_1             ( alu_opnd_1 ),
    .o_alu_opnd_2             ( alu_opnd_2 ),
    .o_alu_optr_val           ( alu_optr_val ),
    .o_alu_use_optr           ( alu_use_optr ),
    .o_alu_alt_out_val        ( alu_alt_out_val ),
    .o_reg_wr_en              ( reg_wr_en ),
    .o_reg_wr_addr            ( reg_wr_addr ),
    .o_pl0_stall_state_val    ( pl0_stall_state_val ),
    .o_mem_wr_en              ( mem_wr_en ),
    .o_mem_wr_val             ( mem_wr_val ),
    .o_mem_rd_en              ( mem_rd_en ),
    .o_l_s_sel_val            ( l_s_sel_val ),
    .o_funct3_0               ( funct3_0 ),
    .ff_val_1                 ( ff_val_1 )

);

pl2_exec pl2_exec_ (

    .i_clk             ( i_clk ),
    .i_alu_opnd_1      ( alu_opnd_1 ),
    .i_alu_opnd_2      ( alu_opnd_2 ),
    .i_alu_optr_val    ( alu_optr_val ),
    .i_alu_use_optr    ( alu_use_optr ),
    .i_alu_alt_out_val ( alu_alt_out_val ),
    .i_ff_addr         ( reg_wr_addr ),
    .i_funct3_0        ( funct3_0 ),

    .o_alu_out_val     ( alu_out_val ),
    .o_ff_addr         ( ff_addr_2 ),
    .o_ff_val          ( ff_val_2 ),
    .o_ff_alu_out_val  ( ff_alu_out_val ),
    .o_funct3_2XOR0    ( funct3_2XOR0 )

);

pl3_mem pl3_mem_ (

    .i_clk         ( i_clk ),
    .i_alu_out_val ( alu_out_val ),
    .i_mem_wr_en   ( mem_wr_en ),
    .i_mem_wr_val  ( mem_wr_val ),
    .i_mem_rd_en   ( mem_rd_en ),
    .i_l_s_sel_val ( l_s_sel_val ),
    .i_ff_addr     ( ff_addr_2 ),

    .o_mem_rd_val  ( alu_out_mem_val ),
    .o_ff_addr     ( ff_addr_3 ),
    .o_ff_val      ( ff_val_3 )

);

pl4_write pl4_write_ (

    .i_clk                    ( i_clk ),
    .i_reg_wr_val             ( alu_out_mem_val ),
    .i_reg_wr_addr            ( ff_addr_3 ),
    .i_reg_wr_en              ( reg_wr_en ),

    .o_reg_wr_en              ( reg_wr_en4 ),
    .o_ff_addr                ( ff_addr_4 ),
    .o_ff_val                 ( ff_val_4 )

);

endmodule
