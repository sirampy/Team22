module strechmem #(
    ADRESS_WIDTH =32,
    DATA_WIDTH=32
)(
    input logic clk,
    input logic [ADRESS_WIDTH-1:0] addr,
    output logic [DATA_WDTH - 1:0] doubt);
logic [DATA_WDTH - 1:0] rom_array [2**ADRESS_WIDTH -1:0];

initial begin
    $("program.mem", rom_array);

end;
always_ff@(posedge clk)
    dout<= rom_array [addr];
endmodule
