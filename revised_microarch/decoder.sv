
module decoder (
    input [31:0]    instr_i,

    // operation
    output alu3_t   alu3_o, // some instructions drive this manually
    output alu7_t   alu7_o, // we keep this as all 7 bits. whilst it might seem wasteful, other extensions (EG: RV32M) use funct7, and this keeps things nice and modular.
    output funct3_t  funct3_o, 

    // opperands
    output src1_t   src1_o,
    output src2_t   src2_o, // which src2 to use in the ALU
    output [4:0]    rs1_o,
    output [4:0]    rs2_o,
    output wire [11:0]  imm12_o,
    output wire [19:0]  imm20_o,

    // result
    output srcr_t srcr_o, // what to use as input to result
    output [4:0] rd_o,    // dest. register
    output reg_write_o,
    output data_read_o,   // load from data_mem
    output data_write_o,  // store to data_mem
    output next_pc_t pc_control_o
 
);


opc_t opc = instr_i [6:0];
alu7_t funct7 = instr_i [31:25];
funct3_t funct3 = instr_i [14:12];


assign rd_o = instr_i[11:7];
assign rs1_o = instr_i[19:15];
assign rs2_o = instr_i[24:20];
assign funct3_o = instr_i[14:12];


// this module decodes the immedates into they're values so all they're bits are in the correct order (but dosn't sign extend / shift them)
// this varies from the lab instructions, but makes sense as it will make the sign extender more readable
logic [19:0] u_imm = instr_i[31:12]; // will get shifted by extender
logic [19:0] j_imm = {instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21]}; // will get shifted by extender
assign imm20_o = (src2_o == J_IMM) ? j_imm : u_imm;

logic [11:0] i_imm = instr_i[31:20];
logic [11:0] s_imm = {instr_i[31:25], instr_i[11:7]};
logic [11:0] b_imm = {instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8]}; // will get shifted by extender

// this is where the magic happens
always_latch begin
    case(opc)
        R: begin

            alu3_o = funct3;
            alu7_o = funct7;

            src1_o = RS1;
            src2_o = RS2;

            srcr_o = RESULT;
            reg_write_o = 1;
            data_read_o = 0;
            data_write_o = 0;
            pc_control_o = NEXT;

        end

        I_ALU: begin

            alu3_o = funct3;
            alu7_o = (funct3.alu == R_SHIFT) ? i_imm [11:5] : I_STD; // not certain this is entirely correct
           
            src1_o = RS1;
            src2_o = IS_IMM12;
            imm12_o = i_imm;

            srcr_o = RESULT;
            reg_write_o = 1;
            data_read_o = 0;
            data_write_o = 0;
            pc_control_o = NEXT;


        end

        I_LD: begin // adds IMM to rs1 and looks it up in the memory
            
            alu3_o = ADD;
            alu7_o = I_STD;

            src1_o = RS1;
            src2_o = IS_IMM12;
            imm12_o = i_imm;

            srcr_o = RESULT;
            reg_write_o = 1;
            data_read_o = 1;
            data_write_o = 0;
            pc_control_o = NEXT;

        end

        S: begin

            alu3_o = ADD;
            alu7_o = I_STD;

            src1_o = RS1;
            src2_o = IS_IMM12;
            imm12_o = s_imm;

            reg_write_o = 0;
            data_read_o = 0;
            data_write_o = 1;
            pc_control_o = NEXT;

        end

        B: begin

            alu3_o = ADD;
            alu7_o = I_STD;

            src1_o = PC;
            src2_o = B_IMM12;
            imm12_o = b_imm;

            reg_write_o = 0;
            data_read_o = 0;
            data_write_o = 0;
            pc_control_o = BRANCH;
            
        end

        U_AUIPC: begin

            alu3_o = ADD;
            alu7_o = I_STD;

            src1_o = PC;
            src2_o = U_IMM;

            srcr_o = NEXT_PC;
            reg_write_o = 1;
            data_read_o = 0;
            data_write_o = 0;
            pc_control_o = NEXT;

        end

        U_LUI: begin 

            alu3_o = ADD;
            alu7_o = I_STD;

            src1_o = ZERO;
            src2_o = U_IMM;

            srcr_o = NEXT_PC;
            reg_write_o = 1;
            data_read_o = 0;
            data_write_o = 0;
            pc_control_o = NEXT;

        end

        J: begin // JAL is only j type instruction

            alu3_o = ADD;
            alu7_o = I_STD;

            src1_o = PC;
            src2_o = J_IMM;

            srcr_o = NEXT_PC;
            reg_write_o = 1;
            data_read_o = 0;
            data_write_o = 0;
            pc_control_o = JUMP;

        end

        I_JALR: begin // TODO: enforce funct3 - 0x0 (currently dosnt respect reserved instructions - fixing this is only necesarry to enable extensions)

            alu3_o = ADD;
            alu7_o = I_STD;

            src1_o = RS1;
            src2_o = IS_IMM12;

            srcr_o = NEXT_PC;
            reg_write_o = 1;
            data_read_o = 0;
            data_write_o = 0;
            pc_control_o = JUMP;

        end 

        I_ENV: begin
            $error("env calls not implemented - no interrupt routine implemented - priveleged extension not implemented");
            //TODO: some form of no-op that makes sense (eg sends signal to top sheet)
        end

        FENCE:begin
            $error("out of order excecution not implemented");
            //TODO: some form of no-op that makes sense (eg sends signal to pipeline to be ignored)
        end 

        default: begin
            //$display("unrecognised opcode");
            reg_write_o = 0;
            data_read_o = 0;
            data_write_o = 0;
            pc_control_o = NEXT;
        end

    endcase
end

endmodule
