/*
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
*/

module data_mem #(
    parameter   ADDRESS_WIDTH = 32,
                DATA_WIDTH = 32,
                MEM_SIZE = 2 ** 6
)(
    input logic [ADDRESS_WIDTH-1:0] a,
    output logic [DATA_WIDTH-1:0]   rd
);

logic [DATA_WIDTH-1:0] rom_array [MEM_SIZE-1:0];

initial begin
        $display("loading rom.");
        $readmemh("../rom_bin/data.mem", rom_array);
end;

    rd = rom_array[a];

endmodule
