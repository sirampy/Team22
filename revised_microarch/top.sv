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
logic [PC_WIDTH-1:0] pc_f;
logic [PC_WIDTH-1:0] pc_inced = pc + 4; // this logic must be replaced my a more extensive module if when the extensions that require it are implemented.
logic [PC_WIDTH-1:0] next_pc_f; 

// control signals
pipeline_contron_t piepline_control;

logic [31:0] instr_f;
logic [31:0] instr_d;


funct3_t funct3_d;
alu3_t alu3_d;
alu7_t alu7_d;

funct3_t funct3_e;
alu3_t alu3_e;
alu7_t alu7_e;


src1_t src1_d;
src2_t src2_d;
wire [4:0]   rs1_d;
wire [4:0]   rs2_d;
wire [11:0]  imm12;
wire [19:0]  imm20;

// return control signals
srcr_t srcr_d; 
logic [4:0] rd_d;
logic reg_write_d;
logic data_read_d;
logic data_write_d;
next_pc_t pc_control_d;

next_pc_t pc_control_e;


// input signals
logic [31:0] imm;
logic [31:0] reg_data_1;
logic [31:0] reg_data_2;
logic [31:0] alu_src_1_d;
logic [31:0] alu_src_2_d;

logic [31:0] alu_src_1_e;
logic [31:0] alu_src_2_e;



// result signals
logic [31:0] alu_out;
logic [31:0] data_mem_rd;
logic jump; 
logic [31:0] result;
logic [31:0] wd3;


assign next_pc_f [PC_WIDTH-1:0] = jump ? result[PC_WIDTH-1:0] : pc_inced;

pc_reg pc_reg(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .next_pc_i(next_pc_f),

    .pc_o(pc_f)
);

instr_mem instr_mem(
    .a_i(pc_f[7:0]), // TODO: parameterise correctly
    .rd_o(instr_f)
);

pipe_fetch fetch_reg(
    .clk_i(clk_i),
    .pipeline_control_i(piepline_control),

    .instr_i(instr_f),
    .instr__o(instr_d)
);


decoder decoder(
    .instr_i(instr_d),

    .alu3_o(alu3_d),
    .alu7_o(alu7_d),
    .funct3_o(funct3_d),

    .src1_o(src1_d),
    .src2_o(src2_d),
    .rs1_o(rs1_d),
    .rs2_o(rs2_d),
    .imm12_o(imm12),
    .imm20_o(imm20),

    .srcr_o(srcr_d),
    .rd_o(rd_d),
    .reg_write_o(reg_write_d),
    .data_read_o(data_read_d),
    .data_write_o(data_write_d),
    .pc_control_o(pc_control_d)
);

sign_extend sign_extend(
    .imm12_i(imm12),
    .imm20_i(imm20),
    .src2_i(src2_d),

    .imm_o(imm_d)
);

// TODO: writeback
assign wd3 = (srcr == NEXT_PC) ? {16'b0, pc_inced} : result; // not properly parameterised

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

assign alu_src_1_d = (src1 == RS1) ? reg_data_1 : (src1 == ZERO) ? 'b0 : (src1 == PC) ? {16'b0, pc} : -1; // last term should never occour
assign alu_src_2_d = (src2 == RS2) ? reg_data_2 : imm;

pipe_decode decode_reg(
    .clk_i(clk_i),
    .pipeline_control_i(piepline_control),

    .alu_src_1_i(alu_src_1_d),
    .alu_src_2_i(alu_src_2_d),
    .alu3_i(alu3_d),
    .alu7_i(alu7_d),

    .funct3_i(funct3_d),
    .pc_control_i(pc_control_d)

    .alu_src_1_o(alu_src_1_e),
    .alu_src_2_o(alu_src_2_e),
    .alu3_o(alu3_e),
    .alu7_o(alu7_e),

    .funct3_o(funct3_e),
    .pc_control_o(pc_control_e)
);


alu alu(
    .src1_i(alu_src_1_e),
    .src2_i(alu_src_2_e),

    .alu3_i(alu3_e),
    .alu7_i(alu7_e),

    .result_o(alu_out)
);

branch_tester branch_tester(
    .src1_i(reg_data_1_e),
    .src2_i(reg_data_2_e),

    .branch3_i(funct3_e),
    .pc_control_i(pc_control_e),

    .jump_o(jump)
);

pipe_excecute excecute_reg(
    
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