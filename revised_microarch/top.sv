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
logic [PC_WIDTH-1:0] pc_inced_f = pc + 4; // this logic must be replaced my a more extensive module if when the extensions that require it are implemented.
logic [PC_WIDTH-1:0] next_pc_f; 

logic [PC_WIDTH-1:0] pc_inced_d;
logic [PC_WIDTH-1:0] pc_inced_e;
logic [PC_WIDTH-1:0] pc_inced_w;


// control signals
pipeline_contron_t pipeline_control_f;
pipeline_contron_t pipeline_control_d;
pipeline_contron_t pipeline_control_e;

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

srcr_t srcr_e; 
logic [4:0] rd_e;
logic reg_write_e;
logic data_read_e;
logic data_write_e;
next_pc_t pc_control_e;

next_pc_t pc_control_e;


// input signals
logic [31:0] imm;
logic [31:0] reg_data_1_d;
logic [31:0] reg_data_2_d;
logic [31:0] alu_src_1_d;
logic [31:0] alu_src_2_d;

logic [31:0] reg_data_1_e;
logic [31:0] reg_data_2_e;
logic [31:0] alu_src_1_e;
logic [31:0] alu_src_2_e;

logic [31:0] alu_src_1_e;
logic [31:0] alu_src_2_e;



// result signals
logic [31:0] alu_out_e;
logic [31:0] data_mem_rd;
logic jump_e; 
logic [31:0] result_m;
logic [31:0] wd3;

// forwarding signals
logic [1:0] forward_aE;
logic [1:0] forward_bE;


assign next_pc_f [PC_WIDTH-1:0] = jump_e ? result_e[PC_WIDTH-1:0] : pc_inced;

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
    .pipeline_control_i(pipeline_control_f),
    
    .pc_inced_i(pc_inced_f),
    .instr_i(instr_f),

    .pc_inced_o(pc_inced_d),
    .instr_o(instr_d)
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

reg_file reg_file(
    .clk_i(clk_i),

    .ad1_i(rs1),
    .ad2_i(rs2),
    .ad3_i(rd),

    .we3_i(reg_write_w),
    .wd3_i(wd3_w),

    .rd1_o(reg_data_1_d),
    .rd2_o(reg_data_2_d)
);

assign alu_src_1_d = (src1 == RS1) ? reg_data_1_d : (src1 == ZERO) ? 'b0 : (src1 == PC) ? {16'b0, pc} : -1; // last term should never occour
assign alu_src_2_d = (src2 == RS2) ? reg_data_2_d : imm;

pipe_decode decode_reg(
    .clk_i(clk_i),
    .pipeline_control_i(pipeline_control_d),

    .alu_src_1_i(alu_src_1_d),
    .alu_src_2_i(alu_src_2_d),
    .alu3_i(alu3_d),
    .alu7_i(alu7_d),

    .funct3_i(funct3_d),
    .pc_control_i(pc_control_d),

    .srcr_i(srcr_d),
    .pc_inced_i(pc_inced_d),
    .rd_i(rd_d),
    .reg_write_i(reg_write_d),
    .data_read_i(data_read_d),
    .data_write_i(data_write_d),
    .pc_control_i(pc_control_d),
    .reg_data_2_i(reg_data_2_d),

    .srcr_o(srcr_e),
    .rd_o(rd_e),
    .reg_write_o(reg_write_e),
    .data_read_o(data_read_e),
    .data_write_o(data_write_e),
    .pc_control_o(pc_control_e),
    .reg_data_2_o(reg_data_2_e),

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

    .result_o(alu_out_e)
);

branch_tester branch_tester(
    .src1_i(reg_data_1_e),
    .src2_i(reg_data_2_e),

    .branch3_i(funct3_e),
    .pc_control_i(pc_control_e),

    .jump_o(jump_e)
);
// TODO: branch if needed

pipe_excecute excecute_reg(
    .clk_i(clk_i),
    .pipeline_control_i(pipeline_control_e),

    .alu_out_i(alu_out_e),
    .reag_data_2_i(reg_data_2_e),
    .funct3_i(funct3_e),

    .srcr_i(srcr_e),
    .rd_i(rd_e),
    .reg_write_i(reg_write_e),
    .data_read_i(data_read_e),
    .data_write_i(data_write_e),
    .pc_control_i(pc_control_e),
    .reg_data_2_i(reg_data_2_e),

    .srcr_i(srcr_m),
    .rd_i(rd_m),
    .reg_write_o(reg_write_m),
    .data_read_o(data_read_m),
    .data_write_o(data_write_m),
    .pc_control_o(pc_control_m),
    .reg_data_2_o(reg_data_2_m),

    
    .alu_out_o(alu_out_m),
    .reag_data_2_o(reag_data_2_m),
    .funct3_o(functr_m)
);


data_mem data_mem(
   .a_i(alu_out_m[19:0]),
   .wd_i(reg_data_2_m),

   .wen_i(data_write_m),
   .load3_i(funct3_m),

   .rd_o(data_mem_rd)
);

assign result_m = (data_read == 1) ? data_mem_rd : alu_out_m;
assign wd3_m = (srcr == NEXT_PC) ? {16'b0, pc_inced} : result; 

pipe_mem mem_reg(
    .clk_i(clk_i),
//    .pipeline_control_i(pipeline_control),

    .wd3_i(wd3_m),
    .reg_write_i(data_write_m),  

    .wd3_o(wd3_w),
    .reg_write_o(data_write_w),  
);

hazard_unit hazard(
    .alu_src_1_i(alu_src_1_e),
    .alu_src_2_i(alu_src_2_e),
    .rd_e_i (rd_e),
    .rd_m_i (rd_m),  
    .rd_w_i (rd_w),
    .reg_write_m_i (reg_write_m),
    .reg_write_w_i (reg_write_e),
    .result_src_e_i (srcr_e[0]),
    .rs1_d_i (instr_d[19:15]),
    .rs2_d_i (instr_d[24:20]),
    .pc_src_e_i (pc_control_e),

    .forward_aE_o (forward_aE),
    .forward_bE_o (forward_bE),
    .control_f (pipeline_control_f),
    .control_d (pipeline_control_d),
    .control_e (pipeline_control_e)
);

endmodule
