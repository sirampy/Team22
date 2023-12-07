module top #(
    parameter ADDR_WIDTH = 5,  //address width for reg
              DATA_WIDTH = 32 //
)(
    input logic clk,      
    input logic rst,
    output logic reg_write,
    output logic [DATA_WIDTH-1:0] a0,
//    output logic reg_write,           Note: Repeat output declaration? Is this supposed to be a different variable?
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
//    logic reg_write;                // Enable write to ALU registers              Note: Already defined in outputs, hence commented
//    logic alu_src;                  // [0] - use rd2, [1] - use imm               Note: Already defined in outputs, hence commented
//    logic eq;                       // rd1 == rd2                                 Note: Already defined in outputs, hence commented
    logic pc_src;                   // [0] - Increment PC as usual, [1] - Write imm to PC
//    logic result_src;               // [0] - Write ALU output to rd, [1] - Write memory value to rd 
//    logic mem_write;                // Enable write to memory. Not used in scope of Lab4. Included for completeness' sake
////    logic [31:0] alu_out;           // Output from ALU
//    logic [2:0] alu_ctrl;           // Select ALU mathematical operation          Note: Already defined in outputs, hence commented
//    logic [31:0] imm_op;            // Immediate value                            Note: Already defined in outputs, hence commented
//    logic [11:0] imm_ext;           // Sign extended immediate value? Why is it 12 bits? Not used in sheet, can this be removed?
//    logic [1:0] imm_src;            // Select which extend to perform             Note: Why is this in this sheet?
    logic [31:0] pc;                // Current PC value                             Note: Why was this 16 bit?
//    logic [31:0] next_pc;           // Next PC value                              Note: Why was this 16 bit? Why is this in this sheet?
//    logic [DATA_WIDTH-1:0] instr;   // Current instruction

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
    pc_top #(.PC_WIDTH(DATA_WIDTH)) pc_module (
        .imm_op(imm_op),
        .clk(clk),
        .rst(rst),
        .pc_src(pc_src),
        .pc(pc)
    );

    main_memory main_mem (
        .clk(clk),
        .address_i(alu_out), // want alu_out = I add
        .write_enable_i(mem_write),
        .write_value_i(pc), // Not used in scope of lab 4, so random wire attached. Actual wire would be register value of address rs2, requires new output from alu_top
        .read_value_o(memory_read)
    );

endmodule
