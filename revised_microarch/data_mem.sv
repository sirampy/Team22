module data_mem #(
    parameter   ADDRESS_WIDTH = 8,
                DATA_WIDTH = 8
)(
    input logic [ADDRESS_WIDTH-1:0]     a_i,
    input logic [(DATA_WIDTH*4)-1:0]    wd_i,

    input load3_t   load3_i,
    input logic     wen_i,
    
    output logic [(DATA_WIDTH*4)-1:0]   rd_o
);

logic [ADDRESS_WIDTH-1:0] a_resized;
logic [31:0] rd_wrd;

assign a_resized = a_i[ADDRESS_WIDTH-1:0];

reg [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
        $display("loading rom.");
        $readmemh("rom_bin/data.mem", rom_array);
end;

always_latch begin

    if (wen_i) begin
        case(load3_i)
            BYTE: rom_array[a_resized] = wd_i[7:0];
            HALF: {rom_array[a_resized+1],rom_array[a_resized]} = wd_i[15:0];
            WORD: {rom_array[a_resized+3],rom_array[a_resized+2],rom_array[a_resized+1],rom_array[a_resized]} = wd_i;
        
            default: $display("trying to write with invalid write opc");
        endcase
    end

    // load operation
    rd_wrd = {rom_array[a_resized+3],
        rom_array[a_resized+2],
        rom_array[a_resized+1],
        rom_array[a_resized]}; // TODO: is this the right way round? 
    
    case (load3_i)
        BYTE: rd_o = {{24{rd_wrd[7]}}, rd_wrd[7:0]};
        HALF: rd_o = {{16{rd_wrd[15]}}, rd_wrd[15:0]};
        WORD: rd_o = rd_wrd;
        U_BYTE: rd_o = {24'b0, rd_wrd[7:0]};
        U_HALF: rd_o = {16'b0, rd_wrd[15:0]};
        default: rd_o = 'b0; 
    endcase

end

endmodule
