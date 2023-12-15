module pc_reg #(
    parameter PC_WIDTH = 32;
)(
    input  logic         clk,
    input  logic         rst,
    input  logic [PC_WIDTH-1:0]  next_pc,
    output logic [PC_WIDTH-1:0]  pc
);

always_ff @ (posedge clk, posedge rst) begin
    if (rst) pc<= {PC_WIDTH{1'b0}};
    else pc<= next_pc;
end

endmodule
