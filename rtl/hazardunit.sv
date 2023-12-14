module hazardunit #(
    parameter ADDR_WIDTH = 5
)
(
    //INPUTS
    input  logic [ 19 : 15 ]          rs1E_i,       // register 1 address (from exekute)
    input  logic [ 24 : 20 ]          rs2E_i,        // resister 2 address (from exekute)
    input  logic [ ADDR_WIDTH-1 : 0 ]  rdE_i,        // address for reg wright (from exekute)
    input  logic [ ADDR_WIDTH-1 : 0]  rdM_i,        // address for reg wright (from memory)
    input  logic [ ADDR_WIDTH-1 : 0 ] rdS_i,        // address for reg wright (from store)
    input  logic                  reg_wrM_i,       // wright enable (from memmory)
    input  logic                  reg_wS_i,    // wright enable (from store)
    input  logic                  result_srcE_i,
    input  logic [ 19 :  15 ]          rs1D_i,       // check for load word instruction
    input  logic [ 24 : 20 ]          rs2D_i,       // check for load word instruction
    input  logic                  pc_srcE_i,    // check if branch instruction
    //OUPUTS
    output logic [ 1 : 0 ] forward_alua_E_o //used to select a forwarding input for alu input a: [00]-no forwarding, from pipeline reg [01]- take from store stage ,[10]- takes result straight from ALU output
    output logic [1 : 0 ] forward_alub_E_o //"" input b ""
    output logic flushFtoD_o //enable flush for FtoD pipeline ref
    output logic stallFtoD_o //enable stall for FtoD pipeline reg
    output logic flushDtoE_o  //enable flush for DtoE piplein reg
    output logic  stalllPC_o  //enable stall for PC reg

);
always_comb
//if executestage RS1 or 2 matches mem stage Rd --> forward from memstage
// else if execute Rs1 or Rs2 matches strore stage Rd -->  forward from store stage
//else do normal

//FOR forward_alua_E_o 
    if ( (rs1E_i== rdM_i) && reg_wrM_i && !(rs1E_i)) forward_alua_E_o=2'b10;
    else if ((rs1E_i == rdS_i) && read_dataM_i && !(rs1E_i)) forward_alua_E_o=2'b01;
    else forward_alua_E_o=2'b00;
//FOR forward_alub_E_o 
    if ( (rs2E_i== rdM_i) && reg_wrM_i && !(rs2E_i)) forward_alub_E_o=2'b10;
    else if ((rs2E_i == rdS_i) && read_dataM_i && !(rs2E_i)) forward_alub_E_o=2'b01;
    else forward_alub_E_o=2'b00;
