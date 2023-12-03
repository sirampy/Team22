// pipelining flip flop 0 -> for fetch stalls
module flip_flop1 #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input  logic                     clk_i,       // clock
    input  logic      en,        // stall f enable
    input  logic [ADDRESS_WIDTH-1:0] pcF_i,       // pc input

    output logic [ADDRESS_WIDTH-1:0] pcF_o,       // pc output
);

always_ff @(posedge clk)
    begin
        if (!en) pcF_o <= pcF_i;
    end

endmodule
