import control_types::* ;


module bytes_selector (
    input load3_t load3_i,
    input [31:0] data_i,

    output [31:0] data_o
)

case (load3_i)
    BYTE: data_o = {24{data_i[7]}, data_i[7:0]};
    HALF: data_o = {16{data_i[15]}, data_i[15:0]};
    WORD: data_o = data_i;
    U_BYTE: data_o = {24'b0, data_i[7:0]};
    U_HALF: data_o = {16'b0, data_i[15:0]};
    default: data_o = 'b0; // cant put an error case here as this module will recive garbage inputs at times
endcase

endmodule
