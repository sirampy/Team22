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


    //instantiating ALU
    alu alu(
        .aluOp1(rd1),   
        .aluOp2(aluOp2),   
        .aluCtrl(aluCtrl),  
        .sum(sum),     
        .eq(eq)          
    );

    //instantiating ALU MUX
    ALUmux ALUmux(
        .aluSrc(aluSrc),     
        .regOp2(rd2),    
        .ImmOp(ImmOp),       
        .aluOp2(aluOp2)      
    );

    //instantiating RegFile
    Reg_File #(.ADDR_WDTH(5), .DATA_WDTH(32)) reg_file(
        .clk(clk),
        .AD1(ad1),
        .AD2(ad2),
        .AD3(ad3),
        .WE3(we3),
        .WD3(wd3),
        .RD1(rd1),
        .RD2(rd2)
    );

    //instantiating PC multiplexer
    pcmultiplx pcMUX(
        .branch_PC(branch_PC), 
        .PCsrc(PCsrc),        
        .inc_PC(inc_PC),       
        .next_PC(next_PC)      
        
    );

    //instantiating PC register
    PCreg PCreg(
        .clk(clk),
        .rst(rst),
        .next_PC(next_PC),
        .pc(pc)               
    );

endmodule

