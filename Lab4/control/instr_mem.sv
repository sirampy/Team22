module instr_mem #(
    parameter   ADDRESS_WIDTH = 32,
                DATA_WIDTH = 32
)(
    input logic [ADDRESS_WIDTH-1:0] a,
    output logic [DATA_WIDTH-1:0]   rd

);

// It seems Verilator has an upper limit on register size?
// We just split the address into 16 bit in this sheet, as we won't need more in this lab.
// Still keeping the input as 32 bit to align with the PC and other sheets
// For full register, replace "16" below with "ADDRESS_WIDTH"
logic [DATA_WIDTH-1:0] rom_array [((2**16)/4)-1:0];

initial begin
        $display("loading rom.");
        $readmemh("control/program.mem", rom_array);
end;

// We split PC into 16 bit because of smaller rom, and we have to remember to divide by 4
assign rd = rom_array[(a[31:16] + a[15:0]) / 4]; 

endmodule
