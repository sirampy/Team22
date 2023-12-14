// pipelining register 1 -> delays from fetch to decode
module pipe_fetch #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input  logic                clk_i,       
    input  pipeline_control_t   pipeline_control_i,

    // data
    input logic [31:0]  instr_i,
    input logic [31:0]  pc_inced_i,

    output logic [31:0]  pc_inced_o,
    output logic [31:0] instr_o
);

always_ff @(posedge clk_i)
    begin
        case(pipeline_control_i)
            CONTINUE: begin 
                instr_o <= instr_i;
                pc_inced_o <= pc_inced_i;
            end
            STALL: begin 
                instr_o <= instr_o;
            end
            FLUSH: begin 
                instr_o <= 'h00000013; // NOP instruction
            end
        endcase
    end

endmodule
