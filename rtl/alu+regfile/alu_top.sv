module alu_top #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32
)(
    input logic                     clk_i,           // clock
    input logic [ADDR_WIDTH-1:0]    rs1_i,           // address of register 1
    input logic [ADDR_WIDTH-1:0]    rs2_i,           // address of register 2
    input logic [ADDR_WIDTH-1:0]    rd_i,            // address of file to be written to
    input logic                     reg_write_i,     // write enable
    input logic [DATA_WIDTH-1:0]    imm_op_i,        // immediate value
    input logic                     alu_src_i,       // selects second input
    input logic [2:0]               alu_ctrl_i,      // determines operation in alu
    output logic                    eq_o             // equal flag
);

logic [DATA_WIDTH-1:0] alu_op1;   // input 1
logic [DATA_WIDTH-1:0] alu_op2;   // input 2
logic [DATA_WIDTH-1:0] alu_out;   // output of ALU
logic [DATA_WIDTH-1:0] reg_op2;   // second register

reg_file regfile (
    .clk_i (clk_i),
    .ad1_i (rs1_i),
    .ad2_i (rs2_i),
    .ad3_i (rd_i),
    .we3_i (reg_write_i), //write enable
    .wd3_i (alu_out), //write data
    .rd1_o (alu_op1),
    .rd2_o (reg_op2)
);

assign alu_op2 = alu_src_i ? imm_op_i : reg_op2; //1 for imm_op and 0 for reg_op2

alu alu (
    .aluOp1_i (alu_op1),
    .aluOp2_i (alu_op2),
    .aluCtrl_i (alu_ctrl_i),
    .sum_o (alu_out),
    .eq_o (eq_o)
);

endmodule
