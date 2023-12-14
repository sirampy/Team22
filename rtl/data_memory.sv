module data_memory #(
    parameter ADDRESS_WIDTH = 32, // needs to be 17 bit wide, look at memory map of final project for reasoning
    //memory addresses reserved from data memory is 0x00001000 to 0x00001FFF, so 12 bit address width, so 4096 referencable mem locations.
    DATA_WIDTH = 32, // 32 bit value stored in mem location of RAM - since it's byte addressed we store data in 4 addresses - confirm with GTA
    BYTE_WIDTH = 8
)(
    input logic clk_i,
    input logic write_enable_i, //write enable
    input logic [1:0] mem_type_i, //input signal, where 00: word, 01: byte, 10: half word
    input logic mem_sign_i,
    input logic [ADDRESS_WIDTH-1:0] address_i, // address, to be taken from output of ALU, 12 bit address so that we can address all mem locations in data mem
    input logic [DATA_WIDTH-1:0] write_data_i, // write input, to be taken from rd2
    output logic [DATA_WIDTH-1:0] read_value_o // read output
);

    logic [BYTE_WIDTH-1:0] ram_array [17'h1FFFF:17'h100]; //each mem location of array stores a byte-width so 8 bits
    logic [7:0] byteAssign;
    logic [15:0] halfwordAssign;
    //logic [7:0] ram_array_val = ram_array[17'h1EE];

    initial begin
        $display("Loading ram.");
        $readmemh("./rom_bin/data.mem", ram_array, 17'h10000);
        $display("Ram successfully loaded.");
    end;

    //Include signal to differentiate word: 0, byte: 1

    //read_value_o is output and is 32 bits so 4 8-bits combined:
    always_comb begin
        case (mem_type_i)
            2'b00: begin //00 then use word
                assign read_value_o = {ram_array[address_i+3], ram_array[address_i+2], ram_array[address_i+1], ram_array[address_i]}; 
            end 
            2'b01: begin //01 then use byte unsigned - changed accordingly in ALU control
                byteAssign = ram_array[address_i];
                assign read_value_o = {{24{1'b0}}, byteAssign};
            end
            2'b10: begin //10 then use half word unsigned - changed accordingly in ALU control
                halfwordAssign = {ram_array[address_i+1], ram_array[address_i]};
                assign read_value_o = {{16{1'b0}}, halfwordAssign};
            end
            default: $display("No dataType selected. Please choose word, byte or halfword.");
        endcase
    end

    always_ff @(posedge clk_i) begin
        if (write_enable_i) begin// synchronous write
            if (mem_type_i == 0 && mem_sign_i == 1) begin
        //last 2 bytes (16 bits) of address is same but filling a word as each mem location only holds 8 bits we split:
                ram_array[address_i] <= write_data_i[7:0]; //LS Byte
                ram_array[address_i+1] <= write_data_i[15:8];
                ram_array[address_i+2] <= write_data_i[23:16];
                ram_array[address_i+3] <= write_data_i[31:24]; //MS Byte
            end
            else begin //so writing a byte
                ram_array[address_i] <= write_data_i[7:0];
            end
        end
    end

endmodule
// please ask the GTA if this implementation is correct, it is taken from the memory map so it should be fine. The only issue is the input address is 32 bits wide.
