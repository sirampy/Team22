module alu_top #(

    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32

) (
    
    input logic                         clk_i,           // Clock
    input logic [ ADDR_WIDTH - 1 : 0 ]  rs1_i,           // Address of operand register 1
    input logic [ ADDR_WIDTH - 1 : 0 ]  rs2_i,           // Address of operand register 2
    input logic [ ADDR_WIDTH - 1 : 0 ]  rd_i,            // Address of write register
    input logic                         reg_write_i,     // Register write enable
    input logic                         reg_write_src_i, // [0] - Write ALU output to registers, [1] - Write memory read to registers
    input logic [ DATA_WIDTH - 1 : 0 ]  imm_op_i,        // Immediate value
    input logic                         alu_src_i,       // [0] - Use rs2 as ALU input, [1] - Use imm_op as ALU input
    input logic [ DATA_WIDTH - 1 : 0 ]  mem_read_val_i,  // Value read from memory
    input logic [ 3 : 0 ]               alu_ctrl_i,      // ALU operation select
    
    input logic                        Jstore_i,      
    input logic [ 31 : 0 ]             pc_plus4_i,       //pc+4 output to write into reg_file.sv
    output logic                        eq_o,            // Equal flag: [1] - (ALU output == 0), [0] - otherwise
    output logic [ DATA_WIDTH - 1 : 0 ] alu_out_o,       // ALU output
    output logic [ DATA_WIDTH - 1 : 0 ] rs2_val_o,       // Value at rs2, output for memory write

    output logic [ DATA_WIDTH - 1 : 0 ] a0_o

);

logic [ DATA_WIDTH - 1 : 0 ] rs1_val; // Value at rs1

reg_file regfile (

    .clk_i ( clk_i ),
    .ad1_i ( rs1_i ),
    .ad2_i ( rs2_i ),
    .ad3_i ( rd_i ),
    .we3_i ( reg_write_i ),
    .wd3_i ( Jstore_i ? pc_plus4_i : (reg_write_src_i ? mem_read_val_i : alu_out_o )), // When Jstore is high, pc + 4 is written to reg_file
    
    .rd1_o ( rs1_val ),
    .rd2_o ( rs2_val_o ),
    .a0_o  ( a0_o )
);

// assign alu_op2 = alu_src ? imm_op : reg_op2; 

alu alu (

    .op1_i  ( rs1_val ),
    .op2_i  ( alu_src_i ? imm_op_i : rs2_val_o ), // alu_op2),
    .ctrl_i ( alu_ctrl_i ),

    .out_o  ( alu_out_o ),
    .eq_o   ( eq_o )

);

endmodule
