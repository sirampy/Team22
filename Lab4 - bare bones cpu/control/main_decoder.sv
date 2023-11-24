module control #(
    param DATA_WIDTH = 32;
)(
    input  logic          eq,           // equal/zero flag
    input  logic [6:0]    op,           // opcode
    input  logic [2:0]    funct3,
    input  logic          funct7,       // funct7 bit 5
    output logic          pc_src,       // select pc next
    output logic          result_src,   // select write input
    output logic          mem_write,    // memory write enable
    output logic [2:0]    alu_control,  // select alu operation
    output logic          alu_src,      // select rd2 or imm
    output logic [1:0]    imm_src,      // imm select
    output logic          reg_write     // register write enable
);

logic [1:0] alu_op; 

always_comb
    case (op)
        7'b0000011: begin // load
            reg_write = 1'b1;
            imm_src = 2'b00;
            alu_src = 1'b1;
            mem_write = 1'b0;
            result_src = 1'b1;
            branch = 1'b0;
            alu_op = 2'b00;
        end
        7'b0010011: begin // arithmetic operations
            reg_write = 1'b1;
            alu_src = 1'b0;
            mem_write = 1'b0;
            result_src = 1'b0;
            branch = 1'b0;
            alu_op = 2'b10;
        end
        7'b0100011: begin // store
            reg_write = 1'b0;
            imm_src = 2'b01;
            alu_src = 1'b1;
            mem_write = 1'b1;
            branch = 1'b0;
            alu_op = 2'b00;
        end
        7'b1100011: begin // branch
            reg_write = 1'b0;
            imm_src = 2'b10;
            alu_src = 1'b0;
            mem_write = 1'b0;
            branch = 1'b0;
            alu_op = 2'b01;
        end
        default: begin
            reg_write = 1'b0;
            imm_src = 2'b00;
            alu_src = 1'b0;
            mem_write = 1'b0;
            result_src = 1'b0;
            branch = 1'b0;
            alu_op = 2'b00;
        end
    endcase

endmodule
