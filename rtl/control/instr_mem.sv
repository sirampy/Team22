module instr_mem #(
    parameter   ADDRESS_WIDTH = 8,
                DATA_WIDTH = 32
)(
    input logic [ADDRESS_WIDTH-1:0] a,
    output logic [DATA_WIDTH-1:0]   rd

);

logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
        $display("loading rom.");
        $readmemh("../control/program.mem", rom_array);
end;

always_comb begin
    rd = rom_array[a];
end

endmodule
