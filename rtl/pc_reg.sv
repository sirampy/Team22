module pc_reg #(
    parameter PC_WIDTH = 32
)(
    input  logic         clk_i,
    input  logic         rst_i,
    input  logic [PC_WIDTH-1:0]  next_pc_i,
    output logic [PC_WIDTH-1:0]  pc_o
);

always_ff @ (posedge clk_i, posedge rst_i) begin
    if (rst_i) pc_o<= {PC_WIDTH{1'b0}};
    else pc_o <= next_pc_i;
end

endmodule
