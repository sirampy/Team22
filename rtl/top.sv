module top #(
  
    parameter ADDR_WIDTH = 5,  
    parameter DATA_WIDTH = 32 

) (

    input logic clk
);
    
logic [ ADDR_WIDTH - 1 : 0 ] rs1;           // ALU registers read address 1
logic [ ADDR_WIDTH - 1 : 0 ] rs2;           // ALU registers read address 2
logic [ ADDR_WIDTH - 1 : 0 ] rd;            // ALU registers write address
logic                        pc_src;        // [0] - Increment PC by 4, [1] - Increment PC by immediate value
logic [ 31 : 0 ]             pc;            // Current PC value           
logic [ 31 : 0 ]             next_pc;       // Write value for PC
logic                        jalr_pc_src;   // [1] Write JALR register to PC, [0] Otherwise
logic [ 31 : 0 ]             memory_read;   // Value read from memory
logic [ DATA_WIDTH - 1 : 0 ] alu_out;       // output of ALU
logic [ DATA_WIDTH - 1 : 0 ] mem_write_val; // output of ALU
logic                        Jstore;
logic [ 31 : 0 ]             pc_plus4;
logic                        reg_write;     // Register write enable
logic                        eq;            // Equal/zero flag
logic                        alu_src;       // [0] - Use rs2 as ALU input, [1] - Use imm_op as ALU input
logic [ 3 : 0 ]              alu_ctrl;      // ALU operation select
logic [ DATA_WIDTH - 1 : 0 ] imm_op;        // Immediate value
logic                        result_src;    // [0] - Write ALU output to register, [1] - Write memory value to register
logic                        mem_write;     // Memory write enable
logic [ 24 : 15 ]            instr24_15;    // Current instruction [ 24 : 15 ]
logic [ 11 : 7 ]             instr11_7;     // Current instruction [ 11 : 7 ]
logic                        pcstall;       //pc stall enable [1] for enable stall

// execute signals
logic [ ADDR_WIDTH - 1 : 0 ] rs1E;
logic [ ADDR_WIDTH - 1 : 0 ] rs2E; 
logic [ ADDR_WIDTH - 1 : 0 ] rdE;
logic           reg_writeE;
logic [ 1 : 0]  result_srcE;
logic           mem_writeE;
logic           jumpE;
logic           branchE;
logic [ 3 : 0 ] alu_ctrlE;
logic           alu_srcE;

// memory signals
logic [ ADDR_WIDTH - 1 : 0 ] rdM;
logic [ DATA_WIDTH - 1 : 0 ] alu_outM;  
logic           reg_writeM;
logic [ 1 : 0 ] result_srcM;
logic           mem_writeM;

// s signals
logic [ ADDR_WIDTH - 1 : 0 ] rdS;
logic [ DATA_WIDTH - 1 : 0 ] alu_outS; 
logic [ 31 : 0 ]             memory_readS;
logic           reg_writeS;
logic [ 1 : 0 ] result_srcS;

logic stallFtoD;
logic flushDtoE;
logic flushFtoD;


assign rs1 = instr24_15 [ 19 : 15 ];
assign rs2 = instr24_15 [ 24 : 20 ];
assign rd = instr11_7 [ 11 : 7 ];


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
    .Jstore_i        ( Jstore ),
    .pc_plus4_i      ( pc_plus4 ),

    .eq_o            ( eq ),
    .alu_out_o       ( alu_out ),
    .rs2_val_o       ( mem_write_val )

);

regFtoD #(.ADDR_WIDTH( ADDR_WIDTH ), .DATA_WIDTH( DATA_WIDTH )) reg_f_to_d(
    .clk_i(clk),
    .flush(flushFtoD),
    .stall(stallFtoD),
    .rd_i(),
    .pcF_i(),
    .pc_plus4F_i(),
    .instrD_o(),
    .pcD_o(),
    .pc_plus4D_o()
);

regDtoE #(.ADDR_WIDTH( ADDR_WIDTH ), .DATA_WIDTH( DATA_WIDTH )) reg_d_to_e(
    .clk_i           ( clk ),
    .reg_wD_i(reg_write),
    .result_srcD_i(result_src),
    .mem_wD_i(mem_write),
    .jumpD_i(),
    .branchD_i(),
    .alu_ctrlD_i(alu_ctrl),
    .alu_srcD_i(alu_src),
    .flush_i(flushDtoE),
    .rd1D_i(),
    .rd2D_i(),
    .rs1D_i(rs1),
    .rs2D_i(rs2),
    .pcD_i(),
    .rdD_i(rd),
    .ext_immD_i(),
    .pc_plus4D_i(),
    .reg_wE_o(reg_writeE),
    .result_srcE_o(result_srcE),
    .mem_wrE_o(mem_writeE),
    .jumpE_o(jumpE),
    .branchE_o(branchE),
    .alu_ctrlE_o(alu_ctrlE),
    .alu_srcE_o(alu_srcE),
    .rd1E_o(),
    .rd2E_o(),
    .rs1E_o(rs1E),
    .rs2E_o(rs2E),
    .pcE_o(),
    .rdE_o(rdE),
    .ext_immE_o(),
    .pc_plus4E_o()

);

regEtoM #(.ADDR_WIDTH( ADDR_WIDTH ), .DATA_WIDTH( DATA_WIDTH )) reg_e_to_m(
    .clk_i           ( clk ),
    .reg_wE_i(reg_writeE),
    .result_srcE_i(result_srcE),
    .mem_wE_i(mem_writeE),
    .alu_resultE_i(alu_out),
    .data_wE_i(),
    .rdE_i(),
    .pc_plus4E_i(),
    .reg_wM_o(reg_writeM),
    .result_srcM_o(result_srcM),
    .mem_wM_o(mem_writeM),
    .alu_resultM_o(alu_outM),
    .data_wM_o(),
    .rdM_o(rdM),
    .pc_plus4M_o()
);

regMtoS #(.ADDR_WIDTH( ADDR_WIDTH ), .DATA_WIDTH( DATA_WIDTH )) reg_m_to_s
(
    .clk_i(clk),
    .reg_wM_i(reg_writeM),
    .result_srcM_i(result_srcM),
    .alu_resultM_i(alu_outM),
    .read_dataM_i(memory_read),
    .rdM_i(rdM),
    .pc_plus4M_i(),
    .reg_wS_o(reg_writeS),
    .result_srcS_o(result_srcS),
    .alu_resultS_o(alu_outS),
    .read_dataS_o(memory_readS),
    .rdS_o(rdS),
    .pc_plus4S_o()
);

hazardunit #(.ADDR_WIDTH( ADDR_WIDTH )) hazardunit(
    .rs1E_i(rs1E),
    .rs2E_i(rs2E),
    .rdE_i(rdE),
    .rdM_i(rdM),
    .rdS_i(rdS),
    .reg_wrM_i(reg_writeM),
    .reg_wS_i(reg_writeS),
    .result_srcE_i(result_srcE),
    .rs1D_i(rs1),
    .rs2D_i(rs2),
    .pc_srcE_i(),
    .forward_alua_E_o(),
    .forward_alub_E_o(),
    .flushFtoD_o(flushFtoD),
    .stallFtoD_o(stallFtoD),
    .flushDtoE_o(flushDtoE),
    .stalllPC_o(pcstall)

);

control_top #( .INSTR_WIDTH( DATA_WIDTH ) ) control_unit (

    .pc_i          ( pc ),
    .eq_i          ( eq ),

    .Jstore_o      ( Jstore ),
    .pc_src_o      ( pc_src ),
    .result_src_o  ( result_src ),
    .mem_write_o   ( mem_write ),
    .alu_src_o     ( alu_src ),
    .reg_write_o   ( reg_write ),
    .jalr_pc_src_o ( jalr_pc_src ),
    .alu_ctrl_o    ( alu_ctrl ),
    .imm_op_o      ( imm_op ),
    .instr24_15_o  ( instr24_15 ),
    .instr11_7_o   ( instr11_7 )

);

pc_reg pc_reg (

    .clk_i     ( clk ),
    .next_pc_i ( next_pc ),
    .stall(pcstall),
    .pc_o      ( pc )

);

pc_mux pc_mux (

    .pc_i          ( pc ),
    .imm_op_i      ( imm_op ),
    .pc_src_i      ( pc_src ),
    .pc_jalr_i     ( alu_out ),
    .jalr_pc_src_i ( jalr_pc_src ),

    .pc_plus4_o    ( pc_plus4 ),
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
