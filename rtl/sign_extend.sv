module sign_extend #(

    parameter IMM_WIDTH = 32

) (

    input logic [ 31 : 7 ]             instr31_7_i, // Instruction [ 31 : 7 ], to use for immediate values
    input logic [ 2 : 0 ]              imm_src_i,   // Immediate value type

    output logic [ IMM_WIDTH - 1 : 0 ] imm_ext_o    // Immediate value

);

always_comb
    casez ( imm_src_i )
        3'b000: imm_ext_o = { { 20 { instr31_7_i [ 31 ] } }, // I-type
                            instr31_7_i [ 31 : 20 ] };
        3'b001: imm_ext_o = { { 20 { instr31_7_i [ 31 ] } }, // S-type
                            instr31_7_i [ 31 : 25 ],
                            instr31_7_i [ 11 : 7 ] };
        3'b010: imm_ext_o = { { 20 { instr31_7_i [ 31 ] } }, // B-type
                            instr31_7_i [ 7 ],
                            instr31_7_i [ 30 : 25 ],
                            instr31_7_i [ 11 : 8 ],
                            1'b0 };
        3'b011: imm_ext_o = { { 12{ instr31_7_i [ 31 ] } },  // J-type
                            instr31_7_i [ 19 : 12 ],
                            instr31_7_i [ 20 ],
                            instr31_7_i [ 30 : 21 ],
                            1'b0 };
        3'b100: imm_ext_o = { instr31_7_i [ 31 : 12 ],       // U-type
                            {12{1'b0}}}; // fixed - lui and auipc use upper 20 bit IMM
        default: imm_ext_o = { IMM_WIDTH{ 1'b? } };
    endcase

endmodule 
