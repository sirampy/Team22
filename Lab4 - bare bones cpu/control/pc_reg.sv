module pc_reg(
    input logic clk,
    input logic rst,
    input logic next_pc,
    output logic pc
);

always_ff @( posedge clk ) 
if (rst) pc<= 1'b0;
else pc<= next_pc;

endmodule
