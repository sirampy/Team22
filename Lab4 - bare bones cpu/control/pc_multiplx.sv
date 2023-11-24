module pc_multiplx(
    input logic branch_PC,
    input logic PCsrc,
    input logic inc_PC,
    output logic next_PC
);

assign next_PC = PCsrc ? branch_PC:inc_PC;

endmodule
