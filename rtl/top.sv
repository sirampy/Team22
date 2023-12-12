module top #(
    parameter ADDR_WIDTH = 5,  //address width for reg
              DATA_WIDTH = 32, 
              PC_WIDTH = 32
)(
    input logic clk_i,      
    input logic rst_i,
    output logic [DATA_WIDTH-1:0] a0
);
    // pc signals
    logic [PC_WIDTH-1:0] pc;       // pcf
    logic [PC_WIDTH-1:0] next_pc;  // pcf'
    logic                pc_src;   // select +4 or pc_target (jumps)
    logic [PC_WIDTH-1:0] pc_plus4;
    logic [PC_WIDTH-1:0] pc_target;

    // instr mem signals
    logic [DATA_WIDTH-1:0] instr;
    logic [DATA_WIDTH-1:0] imm_ext;

    // reg file signals
    logic                  reg_write; // write enable
    logic [DATA_WIDTH-1:0] reg_op1;   // contents of register 1 
    logic [DATA_WIDTH-1:0] reg_op2;   // contents of register 2

    // control signals
    logic [1:0] result_src; // select what data to write
    logic       mem_write;
    logic       jump;
    logic       branch;
    logic [3:0] alu_ctrl;
    logic       alu_src;
    logic [2:0] imm_src;
    logic [1:0] alu_op;    // [00] - LW/SW, [01] - B-type, [10] - (R-type or I-type)

    // alu signals
    logic [DATA_WIDTH-1:0] alu_op1;   // input 1
    logic [DATA_WIDTH-1:0] alu_op2;   // input 2
    logic [DATA_WIDTH-1:0] alu_out;   // output of ALU
    logic                  zero;      // zero flag

    // data mem contents
    logic [DATA_WIDTH-1:0] read_data; 

    // pipelining signals
    logic stall_f; // fetch
    logic stall_d; // decode

    logic [PC_WIDTH-1:0] pcD; 
    logic [PC_WIDTH-1:0] instrD;
    logic [PC_WIDTH-1:0] pc_plus4D;

    logic [DATA_WIDTH-1:0] rd1E;
    logic [DATA_WIDTH-1:0] rd2E;
    logic [ADDR_WIDTH-1:0] rs1E;
    logic [ADDR_WIDTH-1:0] rs2E;
    logic [PC_WIDTH-1:0]   pcE;
    logic [ADDR_WIDTH-1:0] rdE;
    logic [DATA_WIDTH-1:0] imm_extE;
    logic [PC_WIDTH-1:0]   pc_plus4E;

    logic       reg_writeE;
    logic [1:0] result_srcE;
    logic       mem_writeE;
    logic       jumpE;
    logic       branchE;
    logic [3:0] alu_ctrlE;
    logic       alu_srcE;


    // program counter
    assign pc_plus4 = pc + 4; 
    assign next_pc = pc_src ? pc_target : pc_plus4;

    pc_reg pc_module (
        .clk_i (clk_i),
        .rst_i (rst_i),
        .en_i (stall_f),
        .next_pc_i (next_pc),
        .pc_o (pc)
    );

    instr_mem instr_mem ( 
        .addr_i (pc),
        .rd_o (instr)
    );

    // fetch stage pipeling:
    pipe_reg1 pipe_reg1 (
        .clk_i (clk_i),
        .en_i (stall_d),
        .clr_i (flushD),
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
        .ad3_i (rdW),           // address of write register
        .we3_i (reg_writeW),    //write enable
        .wd3_i (resultW),       //write data
        .rd1_o (reg_op1),
        .rd2_o (reg_op2),
        .a0_o  (a0)
    );

    // control unit - split up for pipelining
    main_decoder main_decoder (
        .op_i          (instrD[6:0]),

        .result_src_o  (result_src),
        .mem_write_o   (mem_write),
        .alu_src_o     (alu_src),
        .imm_src_o     (imm_src),
        .reg_write_o   (reg_write),
        .jalr_pc_src_o (jump),
        .branch_o      (branch),
        .alu_op_o      (alu_op)
    );

    alu_decoder alu_decoder (
        .funct3_i      (instrD[14:12]),
        .funct7_i      (instrD[30]),
        .op5_i         (instrD[5]),
        .alu_op_i      (alu_op),
        .alu_control_o (alu_ctrl)
    );

    sign_extend sign_ext (
        .instr31_7_i (instrD[31:7]),
        .imm_src_i (imm_src),
        .imm_ext_o (imm_ext)
    );

    // decode stage pipelining
    pipe_reg2 pipe_reg2 (
        // main inputs
        .clk_i(clk_i),
        .clr_i (flushE),
        .rd1D_i (reg_op1), // read reg 1 val
        .rd2D_i (reg_op2), // read reg 2 val
        .rs1D_i (instrD[19:15]), // read reg 1 addr
        .rs2D_i (instrD[24:20]), // read reg 2 addr
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
        .rs1E_o (rs1E), // read reg 1 addr
        .rs2E_o (rs2E), // read reg 2 addr
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

    logic [DATA_WIDTH-1:0] alu_op2_a; // to use for alu_op2 mux

    // mux for forwarding
    always_comb begin
        case (forward_aE)
            2'b00: alu_op1 = rd1E;
            2'b01: alu_op1 = resultW;
            2'b10: alu_op1 = alu_resultM;
            default: alu_op1 = rd1E;
        endcase
        case (forward_bE)
            2'b00: alu_op2_a = rd2E;
            2'b01: alu_op2_a = resultW;
            2'b10: alu_op2_a = alu_resultM;
            default: alu_op1 = rd2E;
        endcase
    end

    // alu
    alu alu (
        .op1_i  (alu_op1),
        .op2_i  (alu_op2),
        .ctrl_i (alu_ctrlE),
        .out_o  (alu_out),
        .eq_o   (zero)
    );

    // mux for pc src
    logic bne;
    assign bne = (instrD[14:12] == 3'b001) ? 1 : 0; // check for BNE
    assign pc_src = (jumpE) | ((zero ^ bne) & branchE); // [0] - Increment PC by 4, [1] - Increment PC by immediate value
    assign pc_target = pcE + imm_extE; 

    // mux for alu_op2
    assign alu_op2 = alu_srcE ? imm_ext : alu_op2_a; // 1 for imm_ext and 0 for alu_op2_a

    // execute stage:
    logic [DATA_WIDTH-1:0] alu_resultM;
    logic [ADDR_WIDTH-1:0] rdM;
    logic [PC_WIDTH-1:0]   pc_plus4M;

    logic       reg_writeM;
    logic [1:0] result_srcM;
    logic       mem_writeM;

    pipe_reg3 pipe_reg3 (
        // main input
        .clk_i(clk_i),
        .alu_resultE_i (alu_out),
        .write_dataE_i (alu_op2_a),
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

    main_memory main_mem (
        .clk_i (clk_i),
        .address_i (alu_resultM),
        .write_value_i (write_dataM),
        .write_enable_i (mem_writeM),
        .read_value_o (read_data)
    );

    // memory stage:
    logic [DATA_WIDTH-1:0] alu_resultW;
    logic [DATA_WIDTH-1:0] read_dataW;
    logic [ADDR_WIDTH-1:0] rdW;
    logic [DATA_WIDTH-1:0] write_dataM;
    logic [PC_WIDTH-1:0]   pc_plus4W;

    logic       reg_writeW;
    logic [1:0] result_srcW;

    pipe_reg4 pipe_reg4 (
        .clk_i (clk_i),
        .alu_resultM_i (alu_resultM),
        .read_dataM_i (read_data),
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
            2'b00: resultW = alu_resultW;
            2'b01: resultW = read_dataW;
            2'b10: resultW = pc_plus4W;
            default: $error ("unsupported");
        endcase
    end

    // hazard handling
    logic [1:0] forward_aE;
    logic [1:0] forward_bE;
    logic       flushD;
    logic       flushE;

    hazard_unit hazard_unit (
        .rs1E_i (rs1E), // register 1 address (e)
        .rs2E_i (rs2E), // resister 2 address (e)
        .rdE_i (rdE),
        .rdM_i (rdM),
        .rdW_i (rdW),
        .reg_writeM_i (reg_writeM),
        .reg_writeW_i (reg_writeW),
        .result_srcE_i (result_srcE[0]),
        .rs1D_i (instrD[19:15]),
        .rs2D_i (instrD[24:20]),
        .pc_srcE_i (pc_src),
        .forward_aE_o (forward_aE), // forward select for register 1 (e)
        .forward_bE_o (forward_bE), // forward select for register 2 (e)
        .stall_f_o (stall_f),
        .stall_d_o (stall_d),
        .flushD_o (flushD),
        .flushE_o (flushE)
    );

endmodule
