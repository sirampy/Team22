module data_memory #(
    parameter ADDRESS_WIDTH = 32,
    DATA_WIDTH = 32,
    STORE_WIDTH = 8
) (
    input  logic                     clk_i,
    input  logic                     write_enable_i,
    input  logic [ADDRESS_WIDTH-1:0] address_i,
    input  logic [   DATA_WIDTH-1:0] write_data_i,
    
    input logic [ 1 : 0 ]                 mem_type_i,       // [0] - word, [1] - byte, [2] - half
    input logic                           mem_sign_i,       // [0] - unsigned, [1] - signed
    output logic [STORE_WIDTH-1:0] temp1,
    output logic [STORE_WIDTH-1:0] temp2,
    output logic [STORE_WIDTH-1:0] temp3,
    output logic [STORE_WIDTH-1:0] temp4,
    output logic [   DATA_WIDTH-1:0] read_value_o
);

  logic [STORE_WIDTH-1:0] dataMemory_array[2**17-1:0];

  initial begin
    $display("Loading DataMemory.");
    $readmemh("./rom_bin/data.mem", dataMemory_array, 17'h10000, 17'h1FFFF);
  end


  always_ff @ * //load
    begin
    if (mem_type_i == 2'b01 && mem_sign_i == 1'b1)  //for byte addressing
      read_value_o = {24'b0, dataMemory_array[address_i]};
    else  //for word addressing 
      read_value_o = {
        dataMemory_array[address_i+3], dataMemory_array[address_i+2], dataMemory_array[address_i+1], dataMemory_array[address_i]
      };
  end

  assign temp1 = dataMemory_array[address_i];
  assign temp2 = dataMemory_array[address_i+1];
  assign temp3 = dataMemory_array[address_i+2];
  assign temp4 = dataMemory_array[address_i+3];

  always_ff @(posedge clk_i) //store
    begin
    if (mem_type_i == 2'b01 && write_enable_i == 1'b1) begin
      //for byte addressing
      dataMemory_array[address_i] <= write_data_i[7:0];
    end else if (mem_type_i == 2'b00 && write_enable_i == 1'b1) begin
      dataMemory_array[address_i]   <= write_data_i[7:0];
      dataMemory_array[address_i+1] <= write_data_i[15:8];
      dataMemory_array[address_i+2] <= write_data_i[23:16];
      dataMemory_array[address_i+3] <= write_data_i[31:24];
    end
  end

/*
  logic a;

  always_ff @(posedge clk_i) begin
    if (dataMemory_array[{17'h10001}] == 0) begin
      a <= 1;

    end
    if (a == 1) $finish;

    //$display ("%h", dataMemory_array[{17'h10001}]);

  end
*/

endmodule
