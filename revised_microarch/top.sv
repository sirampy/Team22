// import control_types::* ;
`include "control_types.sv"

module top #(
    PC_WIDTH = 16
)
(
    input clk_i,
    input rst_i
    // no outputs! this is peak CPU design.
);

// PC signals
logic [PC_WIDTH-1:0] pc;
logic [PC_WIDTH-1:0] pc_inced = pc + 4; // NOTE: this name has been changed from pc_4
logic [PC_WIDTH-1:0] next_pc;
logic [PC_WIDTH-1:0] pc_target;

// control signals
logic [31:0] instr;

funct3_t funct3;
alu3_t alu3;
alu7_t alu7;

src1_t src1;
src2_t src2;
wire [4:0]   rs1;
wire [4:0]   rs2;
wire [11:0]  imm12;
wire [19:0]  imm20;

srcr_t srcr; // return source
logic [4:0] rd;
logic reg_write;
logic data_read;
logic data_write;
next_pc_t pc_control;

// input signals
logic [31:0] imm;
logic [31:0] reg_data_1;
logic [31:0] reg_data_2;
logic [31:0] alu_src_1;
logic [31:0] alu_src_2;

// result signals
logic [31:0] alu_out;
logic [31:0] data_mem_rd;
logic jump; 
logic [31:0] result;
logic [31:0] wd3;

// pipelining signals
logic stall_f; // fetch
logic stall_d; // decode

logic [PC_WIDTH-1:0] pcD; 
logic [PC_WIDTH-1:0] instrD;
logic [PC_WIDTH-1:0] pc_incedD;

logic [DATA_WIDTH-1:0] rd1E;
logic [DATA_WIDTH-1:0] rd2E;
logic [ADDR_WIDTH-1:0] rs1E;
logic [ADDR_WIDTH-1:0] rs2E;
logic [PC_WIDTH-1:0]   pcE;
logic [ADDR_WIDTH-1:0] rdE;
logic [DATA_WIDTH-1:0] imm_extE;
logic [PC_WIDTH-1:0]   pc_plus4E;

logic       reg_writeE;
logic [1:0] result_srcE;
logic       mem_writeE;
logic       jumpE;
logic       branchE;
logic [3:0] alu_ctrlE;
logic       alu_srcE;


assign next_pc [PC_WIDTH-1:0] = jump ? result[PC_WIDTH-1:0] : pc_inced;

pc_reg pc_reg(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .next_pc_i(next_pc),

    .pc_o(pc)
);

instr_mem instr_mem(
    .a_i(pc[7:0]), // TODO: parameterise correctly
    .rd_o(instr)
);

// fetch stage pipeling:
pipe_reg1 pipe_reg1 (
    .clk_i (clk_i),
    .en_i (stall_d),
    .clr_i (flushD),
    .rd_i (instr),              // read data from instr mem
    .pcF_i (pc),
    .pc_plus4F_i (pc_inced), 
    .instrD_o (instrD),
    .pcD_o (pcD),
    .pc_plus4D_o (pc_incedD)
);

decoder decoder(
    .instr_i(instrD),
    .alu3_o(alu3),
    .alu7_o(alu7),
    .funct3_o(funct3),

    .src1_o(src1),
    .src2_o(src2),
    .rs1_o(rs1),
    .rs2_o(rs2),
    .imm12_o(imm12),
    .imm20_o(imm20),

    .srcr_o(srcr),
    .rd_o(rd),
    .reg_write_o(reg_write),
    .data_read_o(data_read),
    .data_write_o(data_write),
    .pc_control_o(pc_control)
);

sign_extend sign_extend(
    .imm12_i(imm12),
    .imm20_i(imm20),
    .src2_i(src2),

    .imm_o(imm)
);

// decode stage pipelining
pipe_reg2 pipe_reg2 (
    // main inputs
    .clk_i(clk_i),
    .clr_i (flushE),
    .rd1D_i (reg_data_1), // read reg 1 val
    .rd2D_i (reg_data_2), // read reg 2 val
    .rs1D_i (instrD[19:15]), // read reg 1 addr
    .rs2D_i (instrD[24:20]), // read reg 2 addr
    .pcD_i (pcD), 
    // .rdD_i (instrD[11:7]),   // write reg
    .imm_extD_i (imm),
    .pc_plus4D_i (pc_incedD),

    // control unit inputs
    .alu3_i(alu3),
    .alu7_i(alu7),
    .funct3_i(funct3),

    .src1_i(src1),
    .src2_i(src2),
    .rs1_i(rs1),
    .rs2_i(rs2),
    .imm12_i(imm12),
    .imm20_i(imm20),

    .srcr_i(srcr),
    .rd_i(rd),
    .reg_write_i(reg_write),
    .data_read_i(data_read),
    .data_write_i(data_write),
    .pc_control_i(pc_control)

    // main outputs
    .rd1E_o (rd1E),
    .rd2E_o (rd2E),
    .rs1E_o (rs1E), // read reg 1 addr
    .rs2E_o (rs2E), // read reg 2 addr
    .pcE_o (pcE),
    .imm_extE_o (immE),
    .pc_plus4E_o (pc_incedE),

    // control unit outputs
    .alu3_o(alu3E),
    .alu7_o(alu7E),
    .funct3_o(funct3E),

    .src1_o(src1E),
    .src2_o(src2E),
    .rs1_o(rs1E),
    .rs2_o(rs2E),
    .imm12_o(imm12E),
    .imm20_o(imm20E),

    .srcr_o(srcrE),
    .rd_o(rdE),
    .reg_write_o(reg_write),
    .data_read_o(data_read),
    .data_write_o(data_write),
    .pc_control_o(pc_control)
);

// assign wd3 = (srcr == NEXT_PC) ? {16'b0, pc_inced} : result; // not properly parameterised
// this is all replaced by resultW

reg_file reg_file(
    .clk_i(clk_i),

    .ad1_i(rs1),
    .ad2_i(rs2),
    .ad3_i(rd),

    .we3_i(reg_write),
    .wd3_i(wd3),

    .rd1_o(reg_data_1),
    .rd2_o(reg_data_2)
);


assign alu_src_1 = (src1 == RS1) ? reg_data_1 : (src1 == ZERO) ? 'b0 : (src1 == PC) ? {16'b0, pc} : -1; // last term should never occour
assign alu_src_2 = (src2 == RS2) ? reg_data_2 : imm;

alu alu(
    .src1_i(alu_src_1),
    .src2_i(alu_src_2),

    .alu3_i(alu3),
    .alu7_i(alu7),

    .result_o(alu_out)
);

pipe_reg3 pipe_reg3 (
    // main input
    .clk_i(clk_i),
    .alu_resultE_i (alu_out),
    .write_dataE_i (reg_op2),
    .rdE_i (rdE),
    .pc_plus4E_i (pc_plus4E),

    // control input
    .reg_writeE_i (reg_writeE),
    .result_srcE_i (result_srcE),
    .mem_writeE_i (mem_writeE),

    // main output
    .alu_resultM_o (alu_resultM),
    .write_dataM_o (write_dataM),
    .rdM_o (rdM),
    .pc_plus4M_o (pc_plus4M),

    // control output
    .reg_writeM_o (reg_writeM),
    .result_srcM_o (result_srcM),
    .mem_writeM_o (mem_writeM)
);

branch_tester branch_tester(
    .src1_i(reg_data_1),
    .src2_i(reg_data_2),

    .branch3_i(funct3),
    .pc_control_i(pc_control),

    .jump_o(jump)
);

data_mem data_mem(
   .a_i(alu_out[19:0]),
   .wd_i(reg_data_2),

   .wen_i(data_write),
   .load3_i(funct3),

   .rd_o(data_mem_rd)
);

assign result = (data_read == 1) ? data_mem_rd : alu_out;

endmodule
