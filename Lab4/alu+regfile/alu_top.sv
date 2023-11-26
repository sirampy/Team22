module alu_top #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32
)(
    input logic                     clk,           // clock
    input logic [ADDR_WIDTH-1:0]    rs1,           // address of register 1
    input logic [ADDR_WIDTH-1:0]    rs2,           // address of register 2
    input logic [ADDR_WIDTH-1:0]    rd,            // address of file to be written to
    input logic                     reg_write,     // write enable
    input logic [DATA_WIDTH-1:0]    imm_op,        // immediate value
    input logic                     alu_src,       // selects second input
    input logic [2:0]               alu_ctrl,      // determines operation in alu
    output logic                    eq             // equal flag
);

logic [DATA_WIDTH-1:0] alu_op1;   // input 1
logic [DATA_WIDTH-1:0] alu_op2;   // input 2
logic [DATA_WIDTH-1:0] alu_out;   // output of ALU
logic [DATA_WIDTH-1:0] reg_op2;   // second register

reg_file regfile (
    .clk (clk),
    .ad1 (rs1),
    .ad2 (rs2),
    .ad3 (rd),
    .we3 (reg_write), //write enable
    .wd3 (alu_out), //write data
    .rd1 (alu_op2),
    .rd2 (reg_op2)
);

assign alu_op2 = alu_src ? reg_op2 : imm_op;

alu alu (
    .aluOp1 (alu_op1),
    .aluOp2 (alu_op2),
    .aluCtrl (alu_ctrl),
    .sum (alu_out),
    .eq (eq)
);

endmodule
