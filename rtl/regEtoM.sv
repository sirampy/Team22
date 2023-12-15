// reg from Exectute to store in memory

module regEtoM #(
        parameter 
              DATA_WIDTH = 32
)(
    input logic clk_i,
    //control inputs
     input logic       reg_wE_i, //reg write enable [1] - write enable
    input logic [ 1 : 0 ] result_srcE_i, // select write source: [00] - [01]-data mem ,[10]-
    input logic       mem_wE_i, //mem write enable [1] - write enable
    //other inputs
    input logic [ DATA_WIDTH-1 : 0 ]     alu_resultE_i, // alu result output (from execute)
    input logic [ DATA_WIDTH-1 : 0 ]     data_wE_i, // data mem write enable (from execute)
    input logic [ 11 : 7 ]               rdE_i,         // write register address (from execute)
    input logic [ DATA_WIDTH-1 : 0 ]  pc_plus4E_i,   //pc input if no jump - aka pc +4
    //control outputs
    output logic       reg_wM_o,   //reg write enable [1] - write enable
    output logic  [ 1 : 0 ] result_srcM_o,  // select write source: [00] - [01]-data mem ,[10]-
    output logic       mem_wM_o,  //mem write enable [1] - write enable
    //other outputs
    output logic [ DATA_WIDTH-1 : 0 ]    alu_resultM_o, // alu result output (for memory)
    output logic [ DATA_WIDTH-1 : 0 ]    data_wM_o, // data mem write enable (for memory)
    output logic [ 11 : 7 ]              rdM_o,         // write register address (for memory)
    output logic [ DATA_WIDTH-1 : 0 ] pc_plus4M_o    // pc input if no jump (for memory)
);
always_ff @(posedge clk_i)
    begin
        alu_resultM_o <= alu_resultE_i;
        data_wM_o <= data_wE_i;
        rdM_o         <= rdE_i;
        pc_plus4M_o   <= pc_plus4E_i;
        reg_wM_o  <= reg_wE_i;
        result_srcM_o <= result_srcE_i;
        mem_wM_o  <= mem_wE_i;
    end

endmodule
