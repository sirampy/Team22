// pipelining register 1 -> delays from fetch to decode
module decode_fetch #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input  logic                clk_i,       
    input  pipeline_control_t   pipeline_control_i,

    // data
    input logic [4:0] alu_src_1_i,
    input logic [4:0] alu_src_2_i,
    input alu3_t alu3_i,
    input alu7_t alu7_i,

    input funct3_t funct3_i,
    input next_pc_t pc_control_i,

    input logic [31:0] reg_data_2_i

    output logic [31:0] reg_data_2_o

    output logic [4:0] alu_src_1_o,
    output logic [4:0] alu_src_2_o,
    output alu3_t alu3_o,
    output alu7_t alu7_o,

    output funct3_t funct3_o,
    output next_pc_t pc_control_o
);

always_ff @(posedge clk_i)
    begin
        case(pipeline_control_i):
            CONTINUE:begin 
                alu_src_1_o <= alu_src_1_i;
                alu_src_2_o <= alu_src_2_i;
                alu3_o <= alu3_i;
                alu7_o <= alu7_i;

                fucnt3_o <= funct3_i;  
                pc_control_o <= pc_control_i;

                reg_data_2_o <= reg_data_2_i;

            end

            STALL: begin 
                
            end

            FLUSH: begin // likely only need to flush return control signals (reg_write and such)
                alu_src_1_o <= 0;
                alu_src_2_o <= 0;
                alu3_o <= ADD;
                alu7_o <= I_STD;

                fucnt3_o <= alu.I_STD;  
                pc_control_o <= NEXT_PC;
                reg_data_2_o <= 'b0;
            end

            default: display("fetch: unknown pipeline control signal");
        endcase
    end

endmodule
