module control_top #(
    param INSTR_WIDTH = 32;
    param REG_ADDR_WIDTH = 32;
)(
    input  logic [15:0]   pc,           //program counter
    input  logic          eq,           // equal/zero flag
    output logic          pc_src,       // select pc next
    output logic          result_src,   // select write input
    output logic          mem_write,    // memory write enable
    output logic          alu_src,      // select rd2 or imm
    output logic          reg_write,    // register write enable
    output logic [1:0]    alu_ctrl,        // input to alu
    output logic [31:0]   imm_op //sign extended imm
);

logic [INSTR_WIDTH-1:0] instr;      //instruction from mem
logic [REG_ADDR_WIDTH-1:0] rs1, rs2, rd; //register addresses
logic [1:0]    imm_src,      // imm select

assign rs1 = instr[]
assign rs2 = instr[]
assign rd = instr[]
assign imm = instr[]



endmodule
