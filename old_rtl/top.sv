module top #(
    parameter ADDR_WIDTH = 5,  //address width for reg
              DATA_WIDTH = 32, //
)(
    input logic clk,      
    input logic rst,
    output logic reg_write,
    output logic [DATA_WIDTH-1:0] a0,
    output logic reg_write,
    output logic eq,
    output logic alu_src,
    output logic [2:0] alu_ctrl,
    output logic[DATA_WIDTH-1:0]  imm_op
);

    
    logic [ADDR_WIDTH-1:0] rs1; 
    logic [ADDR_WIDTH-1:0] rs2; 
    logic [ADDR_WIDTH-1:0] rd;
    logic reg_write; //write enable
    logic alu_src; 
    logic eq; 
    logic pc_src; 
    logic result_src;
    logic mem_write;
    logic [31:0] alu_out;
    logic [2:0] alu_ctrl;
    logic [31:0] imm_op;
    logic [11:0] imm_ext
    logic [1:0] imm_src;
    logic [15:0] pc;
    logic [15:0] next_pc;
    logic [DATA_WIDTH-1:0] instr;

    //alu+regfile
    alu_top #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) alu_regfile (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .reg_write(reg_write),
        .imm_op(imm_op),
        .alu_src(alu_src),
        .alu_ctrl(alu_ctrl),
        .eq(eq)
    );

    //control: 
    control_top control_unit (
        .op (instr[6:0]),
        .funct3 (instr[14:12]),
        .funct7(instr[30]),
        .eq(eq),
        .pc_src(pc_src),
        .result_src(result_src),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .alu_ctrl(alu_ctrl),
        .imm_op(imm_op),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd)
    );

    //program counter
    pc_top pc_module (
        .imm_op(imm_op),
        .clk(clk),
        .rst(rst),
        .pc_src(pc_src),
        .pc(pc)
    );



endmodule
