import control_types::* ;

module rv32i #(
    PC_WIDTH = 16;
)
(
    input clk_i,
    input rst_i
    // no outputs! this is peak CPU design.
)

// PC signals
logic [PC_WIDTH-1:0] pc;
assign logic [PC_WIDTH-1:0 ]pc_inced = PC + 4; // this logic must be replaced my a more extensive module if when the extensions that require it are implemented.
logic [PC_WIDTH-1:0] next_pc; 

// control signals
logic [31:0] instr;

funct3_t funct3;
alu3_t alu3;
alu7_t alu7;

src1_t src1;
src2_t src2;
wire [4:0]   rs1,
wire [4:0]   rs2,
wire [11:0]  imm12,
wire [19:0]  imm20,

srcr_t srcr, // return source
logic [4:0] rd,
logic reg_write,
logic data_read, 
logic data_write, 
next_pc_t pc_control,

// input signals
wire [31:0] imm;
logic [31:0] reg_data_1;
logic [31:0] reg_data_2;
logic [31:0] alu_src_1;
logic [31:0] alu_src_2;

// data_mem wrapper
logic [31:0] bytes_selector_in;
logic [31:0] bytes_selector_out;
logic [31:0] data_mem_rd;

// result signals
logic [31:0] alu_out;
logic [31:0] read_data;
logic jump;
logic [31:0] result;
logic [31:0] wd3;

//TODO: pc reg / selection logic + instruction mem

next_pc = jump ? result : next_pc;

pc_reg pc_reg(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .next_pc_i(next_pc),

    .pc_o(pc)
);

decoder decoder(
    .instr_i(instr),

    .alu3_o(alu3),
    .alu7_o(alu7),
    .funct3_o(funct3),

    .src1_o(src1),
    .src2_o(src2),
    .rs1_o(rs1),
    .rs2_o(rs2),
    .imm12_o(imm12),
    .imm20_o(imm20),

    .srcr_o(srcr)
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


assign wd3 = (srcr == NEXT_PC) ? pc_inced : result;

reg_file reg_file(
    .clk_i(clk_i)

    .ad1_i(rs1),
    .ad2_i(rs2),
    .ad3_i(rd),

    .we3_i(reg_write),
    .wd3_i(wd3),

    .rd1_o(reg_data_1),
    .rd2_o(reg_data_2)
);


assign alu_src_1 = (src1 == RS1) ? reg_data_1 : (src1 == ZERO) ? 'b0 : (src1 == PC) ? pc_inced : -1; // last term should never occour
assign alu_src_2 = (src2 == RS2) ? rs2 : imm;

alu alu(
    .src1_i(alu_src_1),
    .src2_i(alu_src_2),

    .alu3_i(alu3),
    .alu7_i(alu7),

    .result_o(alu_out)
);

branch_tester branch_tester(
    .src1_i(rs1),
    .src2_i(rs2),

    .branch3_i(funct3),
    .next_pc_i(pc_control),

    .jump_o(jump)
);


data_mem data_mem(
   .a_i(alu_out),
   .wd_i(bytes_selector_out),
   .wen_i(data_write),

   .rd_o(data_mem_rd)
);

bytes_selector_in = data_read ? data_mem_rd : alu_out;

bytes_selector bytes_selector( // may need 2 of these for pipelining, but for now I think its cool that we can re-use only one of these
    .load3_i(funct3);
    .data_i(bytes_selector_in);

    .data_o(bytes_selector_out);
);

result = data_read ? bytes_selector_out : alu_out;

endmodule