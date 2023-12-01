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

    // pipelining flipflops
    // to-do: need to add wires for all pipelined inputs/outputs
    // so that the signals pass through the flip flops one at a time  

    // fetch stage:
    logic [] pcD; 
    logic [] instrD;
    logic pc_plus4D;

    flip_flop1 ff1 (
        .clk_i (clk),
        .rd_i (rd),     // read instr mem
        .pcF_i (pc),
        .pc_plus4F_i (pc),  //IDK FIX THIS PART
        .instrD_o (instrD),
        .pcD_o (pcD),
        .pc_plus4D_o ()
    );
 
    // decode stage:
    logic rd1E;
    logic rd2E;
    logic pcE;
    logic rdE;
    logic imm_extE;
    logic pc_plus4E;

    logic reg_writeE;
    logic result_srcE;
    logic mem_writeE;
    logic jumpE;
    logic branchE;
    logic alu_ctrlE;
    logic alu_srcE;

    flip_flop1 ff2 (
        // main inputs
        .clk_i(clk),
        .rd1D_i (rs1), // read reg 1
        .rd2D_i (rs2), // read reg 2
        .pcD_i (pcD), 
        .rdD_i (rd),   // write reg
        .imm_extD_i (imm_op), // imm after going through sign_ext
        .pc_plus4D_i (pc_plus4D),
        // control unit inputs
        .reg_writeD_i (reg_write),
        .result_srcD_i (result_src),
        .mem_writeD_i (mem_write),
        .jumpD_i () // not yet included in control unit
        .branchD_i () //not yet included in control unit
        .alu_ctrlD_i (alu_ctrl),
        .alu_srcD_i (alu_src),
        // main outputs
        .rd1E_o (rd1E),
        .rd1E_o (rd2E),
        .pcE_o (pcE),
        .rdE_o (rdE),
        .imm_extE_o (imm_extE),
        .pc_plus4E_o (pc_plus4E),
        // control unit outputs
        .reg_writeE_o (reg_writeE),
        .result_srcE_o (result_srcE),
        .mem_writeE_o (mem_writeE),
        .jumpE_o (jumpE),
        .branchE_o (branchE),
        .alu_ctrlE_o (alu_ctrlE),
        .alu_srcE_o (alu_srcE),
    );


    // execute stage:
    logic alu_resultM;
    logic write_dataM;
    logic rdM;
    logic pc_plus4M;

    logic reg_writeM;
    logic result_srcM;
    logic mem_writeM;

    flip_flop1 ff3 (
        .clk_i(clk),
        .alu_resultE_i (alu_out), //NOTE: need to break up alu top to include this
        .write_dataE_i (rd2E),
        .rdE_i (rdE),
        .pc_plus4E_i (pc_plus4E),
        .reg_writeE_i (reg_writeE),
        .result_srcE_i (result_srcE),
        .mem_writeE_i (mem_writeE),
        .alu_resultM_o (alu_resultM),
        .write_dataM_o (write_dataM),
        .rdM_o (rdM),
        .pc_plus4M_o (pc_plus4M),
        .reg_writeM_o (reg_writeM),
        .result_srcM_o (result_srcM),
        .mem_writeM_o (mem_writeM)
    );

    // memory stage:
    logic alu_resultW;
    logic read_dataW;
    logic rdW;
    logic write_dataM_o;
    logic pc_plus4W;

    logic reg_writeW;
    logic result_srcW;

    flip_flop1 ff4 (
        .clk_i(clk),
        .alu_resultM_i (alu_resultM),
        .read_dataM_i (), // data mem mod not declared yet
        .rdM_i (rdM),
        .pc_plus4M_i (pc_plus4M),
        .reg_writeM_i (reg_writeM),
        .result_srcM_i (result_srcM),
        .alu_resultW_o (alu_resultW),
        .read_dataW_o (read_dataW),
        .rdW_o (rdW),
        .pc_plus4W_o (pc_plus4W),
        .reg_writeW_o (reg_writeW),
        .result_srcW_o (result_srcW)
    );


endmodule
