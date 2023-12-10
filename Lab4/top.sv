module top #(
    parameter ADDR_WIDTH = 5,  
              DATA_WIDTH = 32 
)(
    input logic clk,      
    input logic rst,
    output logic reg_write,
    output logic [DATA_WIDTH-1:0] a0,
    output logic eq,
    output logic alu_src,
    output logic [2:0] alu_ctrl,
    output logic[DATA_WIDTH-1:0]  imm_op,

    output logic result_src,
    output logic mem_write,
    output logic[1:0] imm_src,
    output logic [DATA_WIDTH-1:0] instr
);


    
    logic [ADDR_WIDTH-1:0] rs1;     // ALU registers read address 1
    logic [ADDR_WIDTH-1:0] rs2;     // ALU registers read address 2
    logic [ADDR_WIDTH-1:0] rd;      // ALU registers write address
    logic pc_src;                   // [0] - Increment PC as usual, [1] - Write imm to PC
    logic [31:0] pc;                // Current PC value           
    logic [31:0] next_pc;
    logic jalr_pc_src; 
    logic[31:0] memory_read;
    logic [DATA_WIDTH-1:0] alu_out;   // output of ALU


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
        .eq(eq),
        .a0(a0),
        .memory_read_value(memory_read),
        .register_write_source(result_src),
        .alu_out(alu_out)
    );

    //control: 
    control_top #(.INSTR_WIDTH(DATA_WIDTH), .REG_ADDR_WIDTH(ADDR_WIDTH)) control_unit (
//        .clk(clk),
        .pc(pc),
        .imm_src(imm_src),
        .instr(instr),
        .op (instr[6:0]),
        .funct3 (instr[14:12]),
        .funct7(instr[30]),
        .jalr_pc_src(jalr_pc_src),
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
 /*   pc_top #(.PC_WIDTH(DATA_WIDTH)) pc_module (
        .imm_op(imm_op),
        .clk(clk),
        .rst(rst),
        .pc_src(pc_src),
        .pc(pc)
    );*/

    pc_reg pc_reg(
        .pc(pc),
        .next_pc (next_pc),
        .clk (clk),
        .rst (rst)
    );

    pc_mux pc_mux(
        .pc(pc),
        .imm_op(imm_op),
        .pc_jalr(alu_out),
        .pc_src(pc_src),
        .jalr_pc_src(jalr_pc_src),
        .next_pc(next_pc)
    );

    main_memory main_mem (
        .clk(clk),
        .address_i(alu_out), 
        .write_enable_i(mem_write),
        .write_value_i(pc), 
        .read_value_o(memory_read)
    );

endmodule
