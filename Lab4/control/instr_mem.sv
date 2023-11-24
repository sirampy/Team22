module instr_mem #(
    parameter   ADDRESS_WIDTH = 32,
                DATA_WIDTH = 32
)(
    input logic [ADDRESS_WIDTH-1:0] a,
    output logic [DATA_WIDTH-1:0]   rd
);

logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
        $display("loading rom.");
        $readmemh("../rom_bin/program.mem", rom_array);
end;

    rd = rom_array[a];

endmodule