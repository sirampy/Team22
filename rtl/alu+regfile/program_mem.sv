module sprogram_mem #(
    ADRESS_WIDTH =32,
    DATA_WIDTH=32
)(
    input logic clk_i,
    input logic [ADRESS_WIDTH-1:0] addr_i,
    output logic [DATA_WDTH - 1:0] doubt_o
);

logic [DATA_WDTH - 1:0] rom_array [2**ADRESS_WIDTH -1:0];

initial begin
    $("../rom_data/program.mem", rom_array);
end;

always_ff@(posedge clk)
    dout_o<= rom_array [addr_i];
endmodule
