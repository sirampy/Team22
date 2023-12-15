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
logic [ 31 : 0 ]             memory_readS;  //^^ from M to s pipline
logic [ DATA_WIDTH - 1 : 0 ] alu_out;       // output of ALU
logic [ DATA_WIDTH - 1 : 0 ] mem_write_val; // output of ALU
logic                        Jstore;
logic [ 31 : 0 ]             pc_plus4;
//logic                        reg_write;     // Register write enable
logic                        eq;            // Equal/zero flag
logic                        alu_src;       // [0] - Use rs2 as ALU input, [1] - Use imm_op as ALU input
logic                        alu_srcE;      //^^ after pip regester D to E
logic [ 3 : 0 ]              alu_ctrl;      // ALU operation select
logic [ 3 : 0]               alu_ctrlE      //^^ after pip regester D to E
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
logic [ DATA_WIDTH - 1 : 0 ] resultS;
logic reg_writeS;

logic stallFtoD;
logic ForwardAE;
logic flushDtoE;
logic flushFtoD;
logic regwriteE;
logic regwriteD;
logic [ 1 : 0] result_srcE;
logic [ 1 : 0] result_srcM;
logic [ 1 : 0] result_srcS;
logic [ 1 : 0] result_srcD;
logic mem_wD;
logic mem_wE;
logic mem_wM;
logic jumpD;
logic jumpE;
logic [ 31 : 0 ] pcD;
logic [ 31 : 0 ] pcE;
logic [ 31 : 0 ] pc_plus4D;
logic [ 31 : 0 ] pc_plus4E;
logic [ DATA_WIDTH - 1 : 0 ] alu_resultM;
logic [ DATA_WIDTH - 1 : 0 ] rd1;
logic [ DATA_WIDTH - 1 : 0 ] rd2;
logic [ DATA_WIDTH - 1 : 0 ] rd1E;
logic [ DATA_WIDTH - 1 : 0 ] rd2E;
logic [ DATA_WIDTH - 1 : 0 ] Alu_SrcAE,
logic [ DATA_WIDTH - 1 : 0 ] Alu_SrcBE,




assign rs1D = instr24_15 [ 19 : 15 ];
assign rs2D = instr24_15 [ 24 : 20 ];
assign rdD = instr11_7 [ 11 : 7 ];


alu_top #( .ADDR_WIDTH( ADDR_WIDTH ), .DATA_WIDTH( DATA_WIDTH ) ) alu_regfile (

    .clk_i           ( clk ),
    .rs1_i           ( rs1D ),
    .rs2_i           ( rs2D ),
    .rd_i            ( rdD ),
    .reg_write_i     ( reg_writeS ),
    .reg_write_src_i ( result_src ),
    .imm_op_i        ( imm_op ),
    .alu_src_i       ( alu_src ),
    .mem_read_val_i  ( memory_read ),
    .alu_ctrl_i      ( alu_ctrlE ),
    .Jstore_i        ( Jstore ),
    .pc_plus4_i      ( pc_plus4 ),
    .wd3_i(resultS),
    .Alu_SrcAE_i(Alu_SrcAE),
    .Alu_SrcBE_i(Alu_SrcBE),
    .eq_o            ( eq ),
    .alu_out_o       ( alu_out ),
    .rs2_val_o       ( rd1 )
    .rs1_val_o       (rd2 )

);

regEtoM #(.ADDR_WIDTH( ADDR_WIDTH ), .DATA_WIDTH( DATA_WIDTH )) reg_e_to_m(
    .clk_i           ( clk ),
    .reg_wE_i(regwriteE),
    .result_srcE_i(result_srcE),
    .mem_wE_i(mem_wE),
    .alu_resultE_i(alu_out),
    .data_wE_i(),
    .rdE_i(rdE),
    .pc_plus4E_i(pc_plus4E),
    .reg_wM_o(reg_writeM),
    .result_srcM_o(result_srcM),
    .mem_wM_o(mem_wM),
    .alu_resultM_o(alu_resultM),
    .data_wM_o(),
    .rdM_o(rdM),
    .pc_plus4M_o(pc_plus4M)
);
regDtoE #(.ADDR_WIDTH( ADDR_WIDTH ), .DATA_WIDTH( DATA_WIDTH )) reg_d_to_e(
    .clk_i           ( clk ),
    .reg_wD_i(regwriteD),
    .result_srcD_i(result_srcD),
    .mem_wD_i(mem_wD),
    .jumpD_i(),
    .branchD_i(),
    .alu_ctrlD_i(alu_ctrl),
    .alu_srcD_i(alu_src),
    .flush_i(flushDtoE),
    .rd1D_i(rd1),
    .rd2D_i(rd2),
    .rs1D_i(rs1D),
    .rs2D_i(rs2D),
    .pcD_i(pcD),
    .pc_srcD_i(pc_srcD)
    .rdD_i(rdD),
    .ext_immD_i(),
    .pc_plus4D_i(pc_plus4D),
    .reg_wE_o(regwriteE),
    .result_srcE_o(result_srcE),
    .mem_wrE_o(mem_wE),
    .jumpE_o(),
    .branchE_o(),
    .alu_ctrlE_o(alu_ctrlE),
    .alu_srcE_o(alu_srcE),
    .rd1E_o(rd1E),
    .rd2E_o(rd2E),
    .rs1E_o(rs1E),
    .rs2E_o(rs2E),
    .pcE_o(pcE),
    .rdE_o(rdE),
    .ext_immE_o(),
    .pc_plus4E_o(pc_plus4E),
    .pc_srcE_o(pc_srcE)

);
threeinputmulplx DtoE_AluSrcAE(
    .select(ForwardAE),
    .choice00(rd1E),
    .choice01(resultS),
    .choice10(alu_resultM),
    .out(Alu_SrcAE)
);
threeinputmulplx DtoE_AluSrcBE(
    .select(ForwardAE),
    .choice00(rd2E),
    .choice01(resultS),
    .choice10(alu_resultM),
    .out()
);

regMtoS #(.ADDR_WIDTH( ADDR_WIDTH ), .DATA_WIDTH( DATA_WIDTH )) reg_m_to_s
(
.clk_i(clk),
.reg_wM_i(reg_writeM),
.result_srcM_i(result_srcM),
.alu_resultM_i(alu_resultM),
.read_dataM_i(memory_read),
.rdM_i(rdM),  
.pc_plus4M_i(pc_plus4M),
.reg_wS_o(reg_writeS),
.result_srcS_o(result_srcS),
.alu_resultS_o(alu_resultS),
.read_dataS_o(memory_readS),
.rdS_o(rdS), 
.pc_plus4S_o(pc_plus4S)

);
threeinputmulplx MtS_multiplexer(
    .select(result_srcS),
    .choice00(alu_resultS),
    .choice01(memory_readS),
    .choice10(pc_plus4S),
    .out(resultS)

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
    .rs1D_i(rs1D),
    .rs2D_i(rs2D),
    .pc_srcE_i(pc_srcE),
    .forward_alua_E_o(ForwardAE),
    .forward_alub_E_o(),
    .flushFtoD_o(flushFtoD),
    .stallFtoD_o(stallFtoD),
    .flushDtoE_o(flushDtoE),
    .stalllPC_o(pcstall)

);


control_top #( .INSTR_WIDTH( DATA_WIDTH ) ) control_unit (

    .pc_i          ( pc ),
    .eq_i          ( eq ),
    .clk           (clk),
    .flushFtoD(stallFtoD),
    .stallFtoD(stallFtoD),
    .pcD_o(pcD),
    .pc_plus4D_o(pc_plus4D),
    .Jstore_o      ( Jstore ),
    .pc_src_o      ( pc_src ),
    .result_src_o  ( result_srcD ),
    .mem_write_o   ( mem_wD ),
    .alu_src_o     ( alu_src ),
    .reg_write_o   ( regwriteD ),
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
    .pc_src_i      ( pc_srcE ),
    .pc_jalr_i     ( alu_out ),
    .jalr_pc_src_i ( jalr_pc_src ),

    .pc_plus4_o    ( pc_plus4 ),
    .next_pc_o     ( next_pc )

);

main_memory main_mem (

    .clk_i          ( clk ),
    .address_i      ( alu_out ),
    .write_enable_i ( mem_wM ),
    .write_value_i  ( mem_write_val ),

    .read_value_o   ( memory_read )

);


endmodule
