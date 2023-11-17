module top#(
    parameter ADDRESS_WIDTH = 32,
    DATA_WIDTH = 32
)(
    input logic             clk,
    input logic             rst,
    output logic [ADDRESS_WIDTH-1:0] a0,
    output logic wr_en,
    output logic eq,
    output logic aluSrc,
    output logic[2:0] aluCtrl,
);

    logic write_en;
    logic PC_instr;
    logic PC_src;
    logic rd;
    logic rs1;
    logic rs2;
    logic [DATA_WIDTH-1:0] write_data;
    logic aluSrc;
    logic [2:0] aluCtrl;
    logic eq;
    logic [DATA_WIDTH-1:0] immOp;
    logic [1:0]  immSrc;

topALU ALU(
    .clk    (clk),
    .rs1    (rs1),
    .rs2    (rs2),
    .rd     (rd),
    .regFileWen (write_en),
    .aluSrc (aluSrc),
    .immOp  (immOp),
    .aluCtrl (aluCtrl),
    .memWrite (memWrite),
    .eq     (eq)
);

topPC myPC(
    .immOp  (immOp),
    .pcSrc  (pcSrc),
    .clk    (clk),
    .rst    (rst),
    .instr   (pcInstr)
);