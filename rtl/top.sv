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
    output logic [3:0] alu_ctrl,
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
        .clk_i(clk),
        .rs1_i(rs1),
        .rs2_i(rs2),
        .rd_i(rd),
        .reg_write_i(reg_write),
        .imm_op_i(imm_op),
        .alu_src_i(alu_src),
        .alu_ctrl_i(alu_ctrl),
        .eq_o(eq),
        .a0_o(a0),
        .mem_read_val_i(memory_read),
        .reg_write_src_i(result_src),
        .alu_out_o(alu_out)
    );

    //control: 
    control_top #(.INSTR_WIDTH(DATA_WIDTH), .REG_ADDR_WIDTH(ADDR_WIDTH)) control_unit (
        .pc_i(pc),
        .imm_src_o(imm_src),
        .instr(instr),
        .op_i (instr[6:0]),
        .funct3_i (instr[14:12]),
        .funct7_i(instr[30]),
        .jalr_pc_src_o(jalr_pc_src),
        .eq_i(eq),
        .pc_src_o(pc_src),
        .result_src_o(result_src),
        .mem_write_o(mem_write),
        .alu_src_o(alu_src),
        .reg_write_o(reg_write),
        .alu_ctrl_o(alu_ctrl),
        .imm_op_o(imm_op),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd)
    );

    pc_reg pc_reg(
        .pc_o(pc),
        .next_pc_i (next_pc),
        .clk_i (clk),
        .rst_i (rst)
    );

    pc_mux pc_mux(
        .pc_i(pc),
        .imm_op_i(imm_op),
        .pc_jalr_i(alu_out),
        .pc_src_i(pc_src),
        .jalr_pc_src_i(jalr_pc_src),
        .next_pc_o(next_pc)
    );

    main_memory main_mem (
        .clk_i(clk),
        .address_i(alu_out), 
        .write_enable_i(mem_write),
        .write_value_i(pc), 
        .read_value_o(memory_read)
    );

endmodule
