module top #(
    parameter ADDR_WIDTH = 5,  //address width for reg
              DATA_WIDTH = 32,
              PC_WIDTH = 32
)(
    input logic clk_i,      
    input logic rst,
    output logic [DATA_WIDTH-1:0] a0
);
    // pc signals
    logic [PC_WIDTH-1:0] pc; // pcf
    logic [PC_WIDTH-1:0] next_pc; // pcf'
    logic pc_src;  // select +4 or pc_target (jumps)
    logic [PC_WIDTH-1:0] pc_plus4;
    logic [PC_WIDTH-1:0] pc_target;

    // instr mem signals
    logic [DATA_WIDTH-1:0] instr;
    logic [DATA_WIDTH-1:0] imm_ext;

    // reg file signals
    logic reg_write; // write enable
    logic [DATA_WIDTH-1:0] reg_op1; // contents of register 1
    logic [DATA_WIDTH-1:0] reg_op2; // contents of register 2

    // control signals
    logic [1:0] result_src; // select what data to write
    logic mem_write;
    logic [1:0] jump;
    logic branch;
    logic [2:0] alu_ctrl;
    logic alu_src;
    logic [1:0] imm_src;

    // alu signals
    logic [DATA_WIDTH-1:0] alu_op1;   // input 1
    logic [DATA_WIDTH-1:0] alu_op2;   // input 2
    logic [DATA_WIDTH-1:0] alu_out;   // output of ALU
    logic zero; // zero flag - NOTE: RENAME the eq stuff down below

    // data mem contents
    logic [DATA_WIDTH-1:0] read_data; 

    logic [PC_WIDTH-1:0] pcD; 
    logic [PC_WIDTH-1:0] instrD;
    logic [PC_WIDTH-1:0] pc_plus4D;

    logic [ADDR_WIDTH-1:0] rd1E;
    logic [ADDR_WIDTH-1:0] rd2E;
    logic [PC_WIDTH-1:0] pcE;
    logic [ADDR_WIDTH-1:0] rdE;
    logic [DATA_WIDTH-1:0] imm_extE;
    logic [PC_WIDTH-1:0] pc_plus4E;

    logic reg_writeE;
    logic [1:0] result_srcE;
    logic mem_writeE;
    logic jumpE;
    logic branchE;
    logic [1:0] alu_ctrlE;
    logic alu_srcE;


    // program counter
    assign pc_plus4 = pc + 4; 
    assign next_pc = pc_src ? pc_target : pc_plus4;

    pc_reg pc_module (
        .clk_i (clk_i),
        .rst_i (rst),
        .next_pc_i (next_pc),
        .pc_o (pc)
    );

    instr_mem instr_mem ( 
        .a_i (pc),
        .rd_o (instr)
    );

    // fetch stage pipeling:
    flip_flop1 ff1 (
        .clk_i (clk_i),
        .rd_i (instr),              // read data from instr mem
        .pcF_i (pc),
        .pc_plus4F_i (pc_plus4), 
        .instrD_o (instrD),
        .pcD_o (pcD),
        .pc_plus4D_o (pc_plus4D)
    );

    // register file
    reg_file regfile (
        .clk_i (clk_i),
        .ad1_i (instrD[19:15]), // address of register 1
        .ad2_i (instrD[24:20]), // address of register 2
        .ad3_i (rdW),            // address of write register
        .we3_i (reg_writeW), //write enable
        .wd3_i (resultW), //write data
        .rd1_o (reg_op1),
        .rd2_o (reg_op2)
    );

    sign_extend sign_ext (
        .instr_i (instrD[31:7]),
        .imm_src_i (imm_src),
        .imm_ext_o (imm_ext)
    );

    //control: 
    control_top control_unit (
        .op_i (instr[6:0]),
        .funct3_i (instr[14:12]),
        .funct7_i (instr[30]),
        .result_src_o(result_src),
        .mem_write_o(mem_write),
        .alu_src_o(alu_src),
        .reg_write_o(reg_write),
        .alu_ctrl_o(alu_ctrl),
        .imm_src_o (imm_src),
        .jump_o (jump),
        .branch_o (branch)
    );

    // decode stage pipelining
    flip_flop2 ff2(
        // main inputs
        .clk_i(clk_i),
        .rd1D_i (reg_op1), // read reg 1
        .rd2D_i (reg_op2), // read reg 2
        .pcD_i (pcD), 
        .rdD_i (instrD[11:7]),   // write reg
        .imm_extD_i (imm_ext),
        .pc_plus4D_i (pc_plus4D),
        // control unit inputs
        .reg_writeD_i (reg_write),
        .result_srcD_i (result_src),
        .mem_writeD_i (mem_write),
        .jumpD_i (jump),
        .branchD_i (branch),
        .alu_ctrlD_i (alu_ctrl),
        .alu_srcD_i (alu_src),
        // main outputs
        .rd1E_o (rd1E),
        .rd2E_o (rd2E),
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
        .alu_srcE_o (alu_srcE)
    );

    // alu
    alu alu (
        .aluOp1_i (alu_op1),
        .aluOp2_i (alu_op2),
        .aluCtrl_i (alu_ctrl),
        .sum_o (alu_out),
        .eq_o (zero)
    ); 

    // mux for pc src
    assign pc_src = (jumpE) | (zero & branchE);

    // mux for alu_op2
    assign alu_op2 = alu_src ? imm_ext : reg_op2; // 1 for imm_ext and 0 for reg_op2

    // execute stage:
    logic [DATA_WIDTH-1:0] alu_resultM;
    logic [DATA_WIDTH-1:0] write_dataM;
    logic [ADDR_WIDTH-1:0] rdM;
    logic [PC_WIDTH-1:0] pc_plus4M;

    logic reg_writeM;
    logic [1:0] result_srcM;
    logic mem_writeM;

    flip_flop3 ff3 (
        // main input
        .clk_i(clk_i),
        .alu_resultE_i (alu_out),
        .write_dataE_i (reg_op2),
        .rdE_i (rdE),
        .pc_plus4E_i (pc_plus4E),
        // control input
        .reg_writeE_i (reg_writeE),
        .result_srcE_i (result_srcE),
        .mem_writeE_i (mem_writeE),
        // main output
        .alu_resultM_o (alu_resultM),
        .write_dataM_o (write_dataM),
        .rdM_o (rdM),
        .pc_plus4M_o (pc_plus4M),
        // control output
        .reg_writeM_o (reg_writeM),
        .result_srcM_o (result_srcM),
        .mem_writeM_o (mem_writeM)
    );

    data_mem data_mem (
        .a_i (alu_resultM),
        .wd_i (write_dataM),
        .wen_i (mem_writeM),
        .rd_o (read_data)
    );

    // memory stage:
    logic [DATA_WIDTH-1:0] alu_resultW;
    logic [DATA_WIDTH-1:0] read_dataW;
    logic [ADDR_WIDTH-1:0] rdW;
    logic [DATA_WIDTH-1:0] write_dataM_o;
    logic [PC_WIDTH-1:0] pc_plus4W;

    logic reg_writeW;
    logic [1:0] result_srcW;

    flip_flop4 ff4 (
        .clk_i(clk_i),
        .alu_resultM_i (alu_resultM),
        .read_dataM_i (read_dataM),
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

    logic [DATA_WIDTH-1:0] resultW;

    always_comb begin
        case (result_srcW)
            2'b00: resultW = alu_resultM;
            2'b01: resultW = read_dataW;
            2'b10: resultW = pc_plus4W;
        endcase
    end

endmodule
