module instr_mem #(
    parameter   ADDRESS_WIDTH = 8,
                DATA_WIDTH = 8
)(
    input logic [ADDRESS_WIDTH-1:0] a_i,
    output logic [31:0]   rd_o

);;

logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
        $display("loading instruction rom");
        $readmemh("rom_bin/program.mem", rom_array);
        $display("%h",rom_array[2]);
end;

assign rd_o = {rom_array[a_i+3],
        rom_array[a_i+2],
        rom_array[a_i+1],
        rom_array[a_i]};

endmodule
