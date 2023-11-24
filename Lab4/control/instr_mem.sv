modulle instr_mem (
    input   [31:0 ] addr,
    output  [31:0]  data
)

logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
        $display("loading rom.");
        $readmemh("../rom.mem", rom_array);
end;

always_ff @(posedge clk)
    dout <= rom_array[addr];

endmodule
