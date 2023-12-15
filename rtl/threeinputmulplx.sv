module threeinputmulplx#(
    parameter DATA_WIDTH = 32
)
(
    input logic [ 1 : 0] select,
    input logic [ DATA_WIDTH-1 : 0 ] choice00,
    input logic [ DATA_WIDTH-1 : 0 ] choice01,
    input logic [ DATA_WIDTH-1 : 0 ] choice10,
    output logic [ DATA_WIDTH-1 : 0 ] out
);
always_comb
    case (select)
    
    2'b00: out=choice00;
    2'b01: out=choice01;
    2'b10: out=choice10;
    //11 does not happen
   default:
    out=0;
    
    endcase
endmodule

