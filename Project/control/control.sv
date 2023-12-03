module controlunit(
    input logic         eq_i,
    input logic [31:0]  instr_i
    output logic        mem_write_o,
    output logic        alu_src_o,
    output logic        reg_write_o,
    output logic [2:0]  alu_control_o,
    output logic [2:0]  imm_src_o,
    output logic        result_src_o
    output logic        pc_src
);

logic [2:0]   funct3_i;
logic         funct7_i;
logic [6:0]   op_i;
logic [1:0]   alu_op;

assign op = instr_i[6:0];
assign funct3_i = instr_i[14:12];
assign logic funct7 = instr[30];
assign logic alu_op[1:0];

always_comb begin
    casez(alu_op)
    2'b00: assign alu_control = 000;  //add for sw,lw
    2'b01: assign alu_control = 001;  //subtract for beq
        2'b10:
            case(funct3)
              3'b000:
                if ((op == 0110011 funct7 == 1) assign alu_control = 001;  //subtract for sub
                else alu_control=000;  //add for add
              3'b010: alu_control=101;  //set less than for slt
              3'b110: alu_control=011;  //or for or
              3'b111: alu_control=010;  //and for and
            endcase

    endcase



