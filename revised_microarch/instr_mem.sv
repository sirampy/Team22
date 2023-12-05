module instr_mem #(
    parameter   USED_ADDRESS_WIDTH = 8,
                DATA_WIDTH = 32
)(
    input logic [USED_ADDRESS_WIDTH-1:0] a_i,
    output logic [DATA_WIDTH-1:0]   rd_o

);

logic [USED_ADDRESS_WIDTH-1:0] a_resized;
assign a_resized= a_i[USED_ADDRESS_WIDTH-1:0];

logic [DATA_WIDTH-1:0] rom_array [2**USED_ADDRESS_WIDTH-1:0];

initial begin
        $display("loading rom.");
        $readmemh("../../rom_bin/program.mem", rom_array);
end;

always_comb begin
    rd_o = rom_array[a_resized];
end

endmodule
