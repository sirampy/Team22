module bytes_selector_wrapper (
    input [31:0 ]alu_i,
    input [31:0] mem_i,

    input load3_t load3_i,
    input data_read_i,

    output [31:0] read_o,
    output [31:0] alu_o
);

logic [31:0] bytes_sel_in;
logic [31:0] bytes_sel_out;

always_comb begin
    case(data_read_i)

        1: begin

            bytes_sel_in = alu_i;
            read_o = 'b0; // possibly redundant
            alu_o = bytes_sel_out;

        end
        
        0: begin

            bytes_sel_in = mem_i;
            read_o = bytes_sel_out;
            alu_o = 'b0 ; // possibly redundan

        end

    endcase
end

bytes_selector bytes_selector ( // verilator dosnt like this - only using 1 of these is funky.
    .load3_i(load3_i),
    .data_i(bytes_sel_in),

    .data_o(bytes_sel_out)
);

endmodule

