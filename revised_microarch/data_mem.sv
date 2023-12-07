module data_mem #(
    parameter   ADDRESS_WIDTH = 8,
                DATA_WIDTH = 8
)(
    input logic [ADDRESS_WIDTH-1:0] a_i,
    input logic [(DATA_WIDTH*4)-1:0]    wd_i,
    input logic                     wen_i,
    
    output logic [(DATA_WIDTH*4)-1:0]   rd_o
);

logic [ADDRESS_WIDTH-1:0] a_resized;
assign a_resized= a_i[ADDRESS_WIDTH-1:0];

logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
        $display("loading rom.");
        $readmemh("rom_bin/data.mem", rom_array);
end;

always_latch begin

    if (wen_i) begin

        for( int i = 0; i < 4; i++) begin
            rom_array[a_resized + i [7:0]] = wd_i [(DATA_WIDTH*(i+1))-1:(DATA_WIDTH*i)-1];
        end
    
    end

    rd_o = {rom_array[a_resized+3],
        rom_array[a_resized+2],
        rom_array[a_resized+1],
        rom_array[a_resized]};
end

endmodule
