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

// control signals
logic [31:0] instr;

funct3_t funct3;
alu3_t alu3;
alu7_t alu7;

src1_t src1;
src2_t src2;
wire [4:0]    rs1,
wire [4:0]    rs2,
wire [11:0]  imm12,
wire [19:0]  imm20,

srcr_t srcr, // return source
logic [4:0] rd,
logic reg_write,
logic data_read, 
logic data_write, 
next_pc_t pc_control,

wire [31:0] imm;

// input signals
logic [31:0] reg_data_1;
logic [31:0] reg_data_2;
logic [31:0] alu_src_1;
logic [31:0] alu_src_2;

// result signals
logic [31:0] wd3;
logic [31:0] result;

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




endmodule