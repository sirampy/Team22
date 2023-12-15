module control_top #(

    parameter INSTR_WIDTH = 32,
           
             DATA_WIDTH = 32

) (

    input  logic [ 31 : 0 ]                 pc_i,          // Program counter
    input  logic                            eq_i,          // Equal/zero flag
    input logic                             clk,           //clock
    input logic                             flushFtoD,
    input logic                             stallFtoD,
    input logic [ DATA_WIDTH-1 : 0 ] pc_plus4,

    output logic                            pc_src_o,      // [0] - Increment PC by 4, [1] - Increment PC by immediate value
    output logic [ 1 : 0 ]                           result_src_o,  // [0] - Write ALU output to register, [1] - Write memory value to register
    output logic                            mem_write_o,   // Memory write enable
    output logic                            alu_src_o,     // [0] - Use rs2 as ALU input, [1] - Use imm_op as ALU input
    output logic                            reg_write_o,   // Register write enable
    output logic                            jalr_pc_src_o, // [0] - ?, [1] - ?
    //output logic                            Jstore_o,      
    output logic [ 3 : 0 ]                  alu_ctrl_o,    // ALU operation select
    output logic [ DATA_WIDTH-1 : 0 ]                imm_op_o,      // Immediate value
    output logic [ 24 : 15 ]                instr24_15_o,  // Current instruction [ 24 : 15 ]
    output logic [ 11 : 7 ]                 instr11_7_o,    // Current instruction [ 31 : 7 ]
    output logic [ DATA_WIDTH-1 : 0 ]                pcD_o ,         // Program counter out of pipeline register
    output logic [ DATA_WIDTH-1 : 0 ] pc_plus4D_o

); 
logic [ 1 : 0 ] alu_op;              // [00] - LW/SW, [01] - B-type, [10] - Mathematical expression (R-type or I-type)
logic [ 6 : 0 ] op;                  // Instruction operand
logic [ 2 : 0 ] funct3;              // Operator select
logic           funct7;              // Operator select
logic [ 2 : 0 ] imm_src;             // Immediate value type
logic [ INSTR_WIDTH - 1 : 0 ] instr; // Current instruction from intr mem
logic [ INSTR_WIDTH - 1 : 0 ] instr_frompip; // Current instruction to execute from flip flop


assign op = instr_frompip [ 6 : 0 ]   + ( {1'b0, instr_frompip [ 31 ], instr_frompip [ 29 : 25 ] } & 7'h00 );
assign funct3 = instr_frompip [ 14 : 12 ];
assign funct7 = instr_frompip [ 30 ];
assign instr24_15_o = instr_frompip [ 24 : 15 ];
assign instr11_7_o = instr_frompip [ 11 : 7 ];

instr_mem instr_mem (

    .addr_i ( pc_i ),

    .rd_o   ( instr )

);

main_decoder main_decoder (

    .eq_i          ( eq_i ),
    .op_i          ( op ),
    .funct3_i      ( funct3 ),

    .pc_src_o      ( pc_src_o ),
    .result_src_o  ( result_src_o),
    .mem_write_o   ( mem_write_o ),
    .alu_src_o     ( alu_src_o ),
    .imm_src_o     ( imm_src ),
    .reg_write_o   ( reg_write_o ),
    .jalr_pc_src_o ( jalr_pc_src_o ),
    .alu_op_o      ( alu_op )
    //.Jstore_o      ( Jstore_o )

);

alu_decoder alu_decoder (

    .funct3_i      ( funct3 ),
    .funct7_i      ( funct7 ),
    .op5_i         ( op [ 5 ] ),
    .alu_op_i      ( alu_op ),

    .alu_control_o ( alu_ctrl_o )

);

sign_extend sign_extend (

    .instr31_7_i ( instr [ 31 : 7 ] ),
    .imm_src_i   ( imm_src ),
    
    .imm_ext_o   ( imm_op_o )

);


regFtoD #( .DATA_WIDTH( DATA_WIDTH )) reg_f_to_d(
    .clk_i(clk),
    .flush(flushFtoD),
    .stall(stallFtoD),
    .rd_i(instr),
    .pcF_i(pc_i),
    .pc_plus4F_i(pc_plus4),
    .instrD_o(instr_frompip),
    .pcD_o(pcD_o),
    .pc_plus4D_o(pc_plus4D_o)
);

endmodule
