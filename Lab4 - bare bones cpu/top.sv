module top(
    parameter ADDR_WDTH = 32,
              DATA_WDTH = 32
)(
    input logic         clk,
    input logic         rst,
    input logic     aluSrc,    
    output logic [ADDRESS_WIDTH-1:0] a0,
    output logic we3,
    output logic eq,
    output logic aluSrc,
    output logic[2:0] aluCtrl,
);  
    logic [4:0] ad1; //rs1
    logic [4:0] ad2,//rs2
    logic [4:0] ad3, //ad3
    logic we3;
    logic [31:0] wd3;
    logic eq;
    logic PCsrc;
    logic pc;
    logic next_PC;
    logic [7:0] branch_PC; 
    logic [7:0]inc_PC;



    alu_top alutop(
        .clk(clk),
        .rs1(ad1),
        .rs2(ad2),
        .rd(ad3),
        .reg_write(we3),
        .imm_op(ImmOp),
        .alu_src(aluSrc),
        .alu_ctrl(aluCtrl),
        .eq(eq)
    );
  
    pc_top pctop(
        .clk(clk),
        .imm_op(ImmOp),
        .rst(rst),
        .pc_src(pc_src),
        .pc(pc)
    );


endmodule
