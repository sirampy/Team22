module regMtoS #(
    parameter 
              DATA_WIDTH = 32
)(
    input logic clk_i,
    //control inout
    input logic reg_wM_i, //reg write enable [1]-for enable
    input logic [ 1 : 0 ] result_srcM_i, // select write source: [00] - [01]-data mem ,[10]-


    //pther input
    input  logic [ DATA_WIDTH-1 : 0 ]    alu_resultM_i, // alu output result (from memory)
    input  logic [ DATA_WIDTH-1 : 0 ] read_dataM_i,  // read from data mem (from memory)
    input  logic [11:7]              rdM_i, 
    input  logic [DATA_WIDTH-1:0] pc_plus4M_i,
    //control output
    output logic       reg_wS_o,
    output logic [ 1 : 0 ] result_srcS_o,
    //other output
    output logic [DATA_WIDTH-1:0]    alu_resultS_o, // alu output result
    output logic [DATA_WIDTH-1:0] read_dataS_o,  // read from data mem 
    output logic [11:7]              rdS_o, 
    output logic [DATA_WIDTH-1:0] pc_plus4S_o
);
always_ff @(posedge clk_i)    
    begin
        alu_resultS_o <= alu_resultM_i;
        read_dataS_o  <= read_dataM_i;
        rdS_o         <= rdM_i;
        pc_plus4S_o   <= pc_plus4M_i;
        reg_wS_o  <= reg_wM_i;
        result_srcS_o <= result_srcM_i;
    end

endmodule
