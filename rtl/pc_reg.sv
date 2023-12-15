module pc_reg #(
    parameter PC_WIDTH = 32
)(
    input  logic         clk_i,
    input  logic         en_i, // stall enable for lw hazards
    input  logic [PC_WIDTH-1:0]  next_pc_i,
    output logic [PC_WIDTH-1:0]  pc_o
);

always_ff @ (posedge clk_i) begin
    if (!en_i) pc_o <= next_pc_i;  
end

endmodule
