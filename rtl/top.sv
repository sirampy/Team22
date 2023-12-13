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
    PC_RST,
    PC_INCR,
    PC_IMM_OFFSET,
    PC_ALU_OUT
} pc_sel;

typedef enum logic [ 1 : 0 ] {
    REG_WR_ALU_OUT,
    REG_WR_MEM,
    REG_WR_PC
} reg_wr_sel;

typedef enum logic {
    ALU_OPND_SEL_REG = 0,
    ALU_OPND_SEL_IMM = 1
} alu_opnd_sel;

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



module top (

    input clock i_clk

);

instr_val       pc_val, pc_val_incr;
instr           cur_instr_val;
data_val        reg_val_1, reg_val_2, imm_val, reg_wr_val, alu_out_val, mem_addr_val, mem_rd_val, mem_wr_val, alu_opnd2;
reg_addr        reg_rd_addr_1, reg_rd_addr_2, reg_wr_addr;
logic           reg_wr_en, mem_wr_en, flg_z;
pc_sel          pc_sel_val;
reg_wr_sel      reg_wr_sel_val;
alu_opnd_sel    alu_opnd_sel_val;
alu_optr        alu_optr_val;
l_s_sel         l_s_sel_val;

assign pc_val_incr   = pc_val + 4;
assign mem_addr_val  = alu_out_val;
assign flg_z         = alu_out_val == 0 ? 0 : 1;
assign reg_rd_addr_1 = cur_instr_val.body.R.rs1;
assign reg_rd_addr_2 = cur_instr_val.body.R.rs2;
assign reg_wr_addr   = cur_instr_val.body.R.rd;
assign l_s_sel_val   = cur_instr_val.body.R.funct3;

always_comb
    case ( alu_opnd_sel_val )
        ALU_OPND_SEL_REG:
            alu_opnd2 = reg_val_2;
        ALU_OPND_SEL_IMM:
            alu_opnd2 = imm_val;
    endcase

always_comb
    case ( reg_wr_sel_val )
    REG_WR_ALU_OUT:
        reg_wr_val = alu_out_val;
    REG_WR_MEM:
        case ( l_s_sel_val )
        L_S_BYTE:
            reg_wr_val = { { 24 { mem_rd_val [ 7 ] } }, mem_rd_val [ 7 : 0 ] };
        L_S_HALF:
            reg_wr_val = { { 16 { mem_rd_val [ 15 ] } }, mem_rd_val [ 15 : 0 ] };
        L_S_WORD:
            reg_wr_val = mem_rd_val;
        L_S_BYTE_U:
            reg_wr_val = { 24'h000000, mem_rd_val [ 7 : 0 ] };
        L_S_HALF_U:
            reg_wr_val = { 16'h0000, mem_rd_val [ 15 : 0 ] };
        default: reg_wr_val = 0;
        endcase
    REG_WR_PC:
        reg_wr_val = pc_val_incr;
    default: reg_wr_val = 0;
    endcase

always_comb
    case ( l_s_sel_val )
    L_S_BYTE:
        mem_wr_val = { 24'h000000, reg_val_2 [ 7 : 0 ] };
    L_S_HALF:
        mem_wr_val = { 16'h0000, reg_val_2 [ 15 : 0] };
    L_S_WORD:
        mem_wr_val = reg_val_2;
    default: mem_wr_val = 0;
    endcase

pc pc_ (

    .i_clk        ( i_clk ),
    .i_pc_val_inc ( pc_val_incr ),
    .i_imm_val    ( imm_val ),
    .i_reg_val    ( reg_val_1 ),
    .i_sel        ( pc_sel_val ),

    .o_pc_val     ( pc_val )

);

instr_mem instr_mem_ (

    .i_addr ( pc_val ),
    
    .o_val  ( cur_instr_val )

);

regs regs_ (

    .i_clk       ( i_clk ),
    .i_rd_addr_1 ( reg_rd_addr_1 ),
    .i_rd_addr_2 ( reg_rd_addr_2 ),
    .i_wr_addr   ( reg_wr_addr ),
    .i_wr_en     ( reg_wr_en ),
    .i_wr_val    ( reg_wr_val ),

    .o_val_1     ( reg_val_1 ),
    .o_val_2     ( reg_val_2 )

);

alu alu_ (

    .i_opnd1 ( reg_val_1 ),
    .i_opnd2 ( alu_opnd2 ),
    .i_optr  ( alu_optr_val ),
    
    .o_out   ( alu_out_val )

);

main_mem main_mem_ (

    .i_clk    ( i_clk ),
    .i_addr   ( mem_addr_val ),
    .i_wr_en  ( mem_wr_en ),
    .i_wr_val ( mem_wr_val ),

    .o_val    ( mem_rd_val )

);

decoder decoder_ (

    .i_cur_instr_val    ( cur_instr_val ),
    .i_flg_z            ( flg_z ),
    
    .o_pc_sel_val       ( pc_sel_val ),
    .o_reg_wr_sel_val   ( reg_wr_sel_val ),
    .o_alu_opnd_sel_val ( alu_opnd_sel_val ),
    .o_alu_optr_val     ( alu_optr_val ),
    .o_reg_wr_en        ( reg_wr_en ),
    .o_mem_wr_en        ( mem_wr_en ),
    .o_imm_val          ( imm_val )

);

endmodule
