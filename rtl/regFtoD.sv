//reg for fetch to decode
module regFtoD #(
    parameter 
              DATA_WIDTH = 32
)(
   input logic  clk_i,
   input logic flush, //fliush reg - [1] flushes
    input logic stall, // stallreg - [1] stalls
    input  logic [ DATA_WIDTH-1 : 0 ]    rd_i,        // rd from instruction memmemory
    input  logic [ DATA_WIDTH-1 : 0 ] pcF_i,       // pc (from fetch)
    input  logic [ DATA_WIDTH-1 : 0]  pc_plus4F_i,  // pc+4 (from fetch)
    

     output logic [ DATA_WIDTH-1 : 0]     instrD_o,    // instructions (for decode)
    output logic [ DATA_WIDTH-1 : 0 ] pcD_o,       // pc (for decode)
    output logic [ DATA_WIDTH-1 : 0 ] pc_plus4D_o  // pc+4 (for decode)
);

always_ff @(posedge clk_i)
    begin
        if (flush) begin   //if flushing
            instrD_o    <= {DATA_WIDTH{1'b0}};
            pcD_o       <= {DATA_WIDTH{1'b0}};
            pc_plus4D_o <= {DATA_WIDTH{1'b0}};;
        end
        else if (!stall) begin   //if not stalling
            instrD_o    <= rd_i;
            pcD_o       <= pcF_i;
            pc_plus4D_o <= pc_plus4F_i;
        end
    end

endmodule
