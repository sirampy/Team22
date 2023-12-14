module main_cache_memory # (
    parameter ACTUAL_ADDRESS_WIDTH = 16,
    parameter DATA_WIDTH = 60 // data + tag + valid bit
) (
    input  logic    i_clk,    // Clock
    input  logic    i_wr_en,  // Write enable
    input  logic [31:0] i_addr,   // Target address
    input  logic [31:0] i_wr_val, // Value to write

    output logic [31:0] o_val     // Value at address
);

    byte mem_bytes [ 2 ** ACTUAL_ADDRESS_WIDTH - 1 : 0 ];

    logic hit;
    logic tag;
    logic valid;
    logic [DATA_WIDTH-1:0] cache [7:0]; 

    
    function logic [ACTUAL_ADDRESS_WIDTH - 1 : 0 ] convert_address ( input logic [31:0] in );
        convert_address = in [ 31 : 16 ] + in [ 15 : 0 ];
    endfunction

    
    initial begin
        $display( "Loading main memory" );
        $readmemh( "test2.mem", mem_bytes );
    end

    
    always_comb begin
        tag = (i_addr[31:5] == cache[i_addr[4:2]][58:32]);
        valid = cache[i_addr[4:2]][59];
        hit = (tag & valid);
        if (hit)
            o_val = cache[i_addr[4:2]][31:0];
        else
            o_val = { mem_bytes [ convert_address( i_addr ) + 3 ],
                      mem_bytes [ convert_address( i_addr ) + 2 ],
                      mem_bytes [ convert_address( i_addr ) + 1 ],
                      mem_bytes [ convert_address( i_addr ) ] };
    end

    //update cache and main memory
    always_ff @(posedge i_clk) begin
        if (i_wr_en) begin
            //update main memory
            mem_bytes [ convert_address( i_addr ) + 3 ] <= i_wr_val [ 31 : 24 ];
            mem_bytes [ convert_address( i_addr ) + 2 ] <= i_wr_val [ 23 : 16 ];
            mem_bytes [ convert_address( i_addr ) + 1 ] <= i_wr_val [ 15 : 8 ];
            mem_bytes [ convert_address( i_addr ) ] <= i_wr_val [ 7 : 0 ];

            //update cache array
            if (!hit) begin
                cache[i_addr[4:2]][59] <= 1'b1;
                cache[i_addr[4:2]][31:0] <= i_wr_val;
                cache[i_addr[4:2]][58:32] <= i_addr[31:5];
            end
        end
    end

endmodule
