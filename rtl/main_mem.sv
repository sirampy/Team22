module main_mem # (
    
    parameter ACTUAL_ADDRESS_WIDTH = 20, // IF MODIFYING THIS, MODIFY convert_address FUNCTION BELOW
    parameter SET_WIDTH = 5, // this ought to be reasonably large as memory is byte adressed, and thus likely to be used 4 bytes at a time
    parameter SET_COUNT = 32

) (

    input  clock    i_clk,    // Clock
    input  data_val i_addr,   // Target address
    input  logic    i_wr_en,  // Write enable
    input  data_val i_wr_val, // Value to write
    input  l_s_sel  i_wr_type_sync,    // type of write (read conversion is done outside the memory itself)
    input  l_s_sel  i_wr_type_async,   // needs an async and sync version for async and sync logic (i know this is cursed)

    output data_val o_val     // Value at address

);

byte mem_bytes [ 2 ** ACTUAL_ADDRESS_WIDTH - 1 : 0 ];

// cache memory
logic [SET_COUNT-1:0] cache_valid;                  // valid bit of cache entries
logic [(ACTUAL_ADDRESS_WIDTH-1)-SET_WIDTH:0] cache_tag [SET_COUNT-1:0];   // tags of entries
byte cache_data [SET_COUNT-1:0];                    // data of cache entries

logic [ACTUAL_ADDRESS_WIDTH-1:0] addr;

assign addr = convert_address(i_addr);;

// cache bytes read (i know this is janky)
byte read_0;
byte read_1;
byte read_2;
byte read_3;

// The following is done to fix bit length errors
function logic [ ACTUAL_ADDRESS_WIDTH - 1 : 0 ] convert_address ( input data_val in );
    if(in == in)
        convert_address =  in [ 19 : 0 ]; // trick verilator into not complaining about unused address bits
endfunction

function logic [SET_WIDTH-1:0] set (input logic [(ACTUAL_ADDRESS_WIDTH-1):0] address);
    if (address==address) //trick verilator into allowing unused bits
        set = address [SET_WIDTH-1:0];
endfunction

function logic [(ACTUAL_ADDRESS_WIDTH-1)-SET_WIDTH:0] tag (input logic [(ACTUAL_ADDRESS_WIDTH-1):0] address);
    if (address==address)
        tag = address [(ACTUAL_ADDRESS_WIDTH-1)-SET_WIDTH:0];
endfunction

initial begin
    //TODO: remove read_x initialisation - its just there to stop verilator complaining when trying to compile incomplete code
    read_0 = 'b0;
    read_1 = 'b0;
    read_2 = 'b0;
    read_3 = 'b0;

    cache_valid = 'b0;
    $display( "Loading main memory" );
    $readmemh( "rom_bin/data.mem", mem_bytes ); // Choose correct .mem location here
end

// cache read logic - setup 
always_ff @(posedge i_clk)
// TODO: check read enable - dont want to update cache if not read / write instruction
    case ( i_wr_type_sync )
        L_S_BYTE, L_S_BYTE_U:
        begin
            if (cache_tag[set(addr)] == tag(addr) && cache_valid[set(addr)]) // hit
                read_0 <= cache_data[set(addr)];
            else begin 
                if (cache_valid[set(addr)]) // store cached value before overwriting
                    mem_bytes[{cache_tag[set(addr)], set(addr)}] <= cache_data[set(addr)]; // might cause issues as this is asynchronous
                cache_valid[set(addr)] <= 1;
                cache_data[set(addr)] <= mem_bytes[addr]; 
                cache_tag [set(addr)] <= tag(addr);
                read_0 <= mem_bytes[addr];         
            end
        end
        L_S_HALF, LS_HALF_U:; //TODO: implement above cache mechanism for other load instructions
        L_S_WORD:;
        L_S_HALF_U:;
        default: read_0 <= 0;
    endcase

always_comb begin
    case ( i_wr_type_async )
        L_S_BYTE:   o_val = { { 24 {read_0[ 7 ] } },read_0 };
        L_S_HALF:   o_val = { { 16 { read_1 [ 7 ] } }, read_1, read_0 };
        L_S_WORD:   o_val = {read_3,read_2,read_1,read_1};
        L_S_BYTE_U: o_val = { 24'h000000, read_0 };
        L_S_HALF_U: o_val = { 16'h0000, read_1, read_0 };
        default: o_val = 0;
    endcase
end

// TODO: write logic
always_ff @( posedge i_clk )
    if ( i_wr_en )
    begin
        case ( i_wr_type_sync) 
            L_S_BYTE:
            begin
                mem_bytes [ convert_address( i_addr ) ] <= i_wr_val [ 7 : 0 ];
            end
            L_S_HALF:
            begin
                mem_bytes [ convert_address( i_addr ) + 1 ] <= i_wr_val [ 15 : 8 ];
                mem_bytes [ convert_address( i_addr ) ] <= i_wr_val [ 7 : 0 ];
            end
            default: // covers L_S_WORD
            begin
                mem_bytes [ convert_address( i_addr ) + 3 ] <= i_wr_val [ 31 : 24 ]; // Little endian
                mem_bytes [ convert_address( i_addr ) + 2 ] <= i_wr_val [ 23 : 16 ];
                mem_bytes [ convert_address( i_addr ) + 1 ] <= i_wr_val [ 15 : 8 ];
                mem_bytes [ convert_address( i_addr ) ] <= i_wr_val [ 7 : 0 ];
            end
        endcase
    end

endmodule
