module top #(
  
    parameter ADDR_WIDTH = 5,  
    parameter DATA_WIDTH = 32 

) (

    input logic clk,
    input logic rst,

    output logic reg_write,
    output logic eq,
    output logic alu_src,
    output logic [3:0] alu_ctrl,
    output logic[DATA_WIDTH-1:0]  imm_op,
    output logic result_src,
    output logic mem_write,
    output logic [DATA_WIDTH-1:0] instr_o,
    output logic [DATA_WIDTH-1:0] a0_o

);
    
logic [ ADDR_WIDTH - 1 : 0 ] rs1;         // ALU registers read address 1
logic [ ADDR_WIDTH - 1 : 0 ] rs2;         // ALU registers read address 2
logic [ ADDR_WIDTH - 1 : 0 ] rd;          // ALU registers write address
logic                        pc_src;      // [0] - Increment PC by 4, [1] - Increment PC by immediate value
logic [ 31 : 0 ]             pc;          // Current PC value           
logic [ 31 : 0 ]             next_pc;     // Write value for PC
logic                        jalr_pc_src; // [1] Write JALR register to PC, [0] Otherwise
logic [ 31 : 0 ]             memory_read; // Value read from memory
logic [ DATA_WIDTH - 1 : 0 ] alu_out;     // output of ALU
logic [ DATA_WIDTH - 1 : 0 ] mem_write_val;     // output of ALU

assign rs1 = instr_o [ 19 : 15 ];
assign rs2 = instr_o [ 24 : 20 ];
assign rd = instr_o [ 11 : 7 ];

alu_top #( .ADDR_WIDTH( ADDR_WIDTH ), .DATA_WIDTH( DATA_WIDTH ) ) alu_regfile (

    .clk_i           ( clk ),
    .rs1_i           ( rs1 ),
    .rs2_i           ( rs2 ),
    .rd_i            ( rd ),
    .reg_write_i     ( reg_write ),
    .reg_write_src_i ( result_src ),
    .imm_op_i        ( imm_op ),
    .alu_src_i       ( alu_src ),
    .mem_read_val_i  ( memory_read ),
    .alu_ctrl_i      ( alu_ctrl ),

    .eq_o            ( eq ),
    .alu_out_o       ( alu_out )
    //.a0_o(a0_o), UNCOMMENT ONLY IF NEEDED

);

control_top #( .INSTR_WIDTH( DATA_WIDTH ) ) control_unit (

    .pc_i          ( pc ),
    .eq_i          ( eq ),

    .pc_src_o      ( pc_src ),
    .result_src_o  ( result_src ),
    .mem_write_o   ( mem_write ),
    .alu_src_o     ( alu_src ),
    .reg_write_o   ( reg_write ),
    .jalr_pc_src_o ( jalr_pc_src ),
    .alu_ctrl_o    ( alu_ctrl ),
    .imm_op_o      ( imm_op ),
    .instr_o       ( instr_o )

);

pc_reg pc_reg (

    .clk_i     ( clk ),
    .rst_i     ( rst ),
    .next_pc_i ( next_pc ),

    .pc_o      ( pc )

);

pc_mux pc_mux (

    .pc_i          ( pc ),
    .imm_op_i      ( imm_op ),
    .pc_src_i      ( pc_src ),
    .pc_jalr_i     ( alu_out ),
    .jalr_pc_src_i ( jalr_pc_src ),

    .next_pc_o     ( next_pc )

);

main_memory main_mem (

    .clk_i          ( clk ),
    .address_i      ( alu_out ),
    .write_enable_i ( mem_write ),
    .write_value_i  ( mem_write_val ),

    .read_value_o   ( memory_read )

);

endmodule
