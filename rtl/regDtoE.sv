//reg for decode to execute
module regDtoE#(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input logic clk_i,
    // control unit inputs
    input logic           reg_wD_i,     // register wright enable [1]-enable
    input logic [ 1 : 0 ] result_srcD_i,  // select write source: [00] - [01]-data mem ,[10]-
    input logic            mem_wD_i,      // mem wright enable [1]-enable
    input logic [ 3 : 0 ]    alu_ctrlD_i,  // ALU operation select (to ALU)
    input logic               alu_srcD_i,     // [0] - Use register as ALU input, [1] - Use immediate value as ALU input
    input logic pc_srcD_i,

    //hazard inputs
    input logic flush_i,  //fliush reg


    //reg inputs
    input  logic [ DATA_WIDTH-1 : 0 ]    rd1D_i,      // read register 1 (from deocde)
    input  logic [ DATA_WIDTH-1 : 0 ]    rd2D_i,      // read register 2 (from deocde)
    input  logic [ 19 : 15 ]             rs1D_i,      // read reg 1 address (from deocde)
    input  logic [ 24 : 20 ]             rs2D_i,      // read reg 2 address (from deocde)
    input  logic  [ADDRESS_WIDTH-1 : 0 ] pcD_i,       // pc (from deocde)
    input  logic [ 11 : 7 ]              rdD_i,       // write register address (from deocde)
    input  logic [ DATA_WIDTH-1 : 0 ]    ext_immD_i,  // imm extend (from deocde)
    input  logic [ ADDRESS_WIDTH-1 : 0 ] pc_plus4D_i, // pc+4 (from deocde)

//control outputs

     output logic       reg_wE_o,      
    output logic [ 1 : 0 ] result_srcE_o, 
    output logic       mem_wrE_o,       
    output logic [ 3 : 0 ] alu_ctrlE_o,  
    output logic pc_srcE_o, 
    output logic       alu_srcE_o  

// reg outputs
  output logic [ DATA_WIDTH-1 : 0 ]    rd1E_o, // read register 1 (for execute)
  output logic [ DATA_WIDTH-1 : 0]     rd2E_o, // read register 2 (for execute)
   output logic [ 19 : 15 ]             rs1E_o, // read reg 1 address  (for execute)
   output logic [ 24 : 20 ]             rs2E_o, // read reg 2 address (for execute)
   output logic [ ADDRESS_WIDTH-1 : 0 ] pcE_o, // pc (for execute)
   output logic [ 11 : 7 ]              rdE_o,  // write register address (for execute)
    output logic [ DATA_WIDTH-1 : 0 ]    ext_immE_o,  // imm extend  (for execute)
    output logic [ ADDRESS_WIDTH-1 : 0 ] pc_plus4E_o,  // pc+4  (for execute)
);
always_ff @(posedge clk_i)
    begin
        if (flush_i) begin
            rd1E_o      <= {DATA_WIDTH{1'b0}};
            rd2E_o      <= {DATA_WIDTH{1'b0}};
            pcE_o       <= {ADDRESS_WIDTH{1'b0}};
            rdE_o       <= 5'b0;
            ext_immE_o  <= {DATA_WIDTH{1'b0}};
            pc_plus4E_o <= {ADDRESS_WIDTH{1'b0}};
            reg_wE_o  <= 1'b0;
            result_srcE_o <= 2'b00;
            mem_wrE_o  <= 1'b0;
            alu_ctrlE_o   <= 4'b0000;
            alu_srcE_o    <= 1'b0;
            pc_srcE_o    <= 1'b0;
        end
        else begin
            rd1E_o      <= rd1D_i;
            rd2E_o      <= rd2D_i;
            rs1E_o      <= rs1D_i;
            rs2E_o      <= rs2D_i;
            pcE_o       <=  pcD_i;
            rdE_o       <= rdD_i;
            ext_immE_o  <= ext_immD_i;
            pc_plus4E_o <= pc_plus4D_i;
            reg_wE_o    <= reg_wD_i;
            result_srcE_o <= result_srcD_i;
            mem_wrE_o  <= mem_wD_i;
            alu_ctrlE_o   <= alu_ctrlD_i;
            alu_srcE_o    <= alu_srcD_i;
            alu_srcE_o    <= pc_srcD_i;

        end
    end
    endmodule
