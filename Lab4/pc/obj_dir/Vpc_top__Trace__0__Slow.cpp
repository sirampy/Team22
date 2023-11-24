// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vpc_top__Syms.h"


VL_ATTR_COLD void Vpc_top___024root__trace_init_sub__TOP__0(Vpc_top___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBus(c+1,"imm_op", false,-1, 31,0);
    tracep->declBit(c+2,"clk", false,-1);
    tracep->declBit(c+3,"rst", false,-1);
    tracep->declBit(c+4,"pc_src", false,-1);
    tracep->declBus(c+5,"pc", false,-1, 15,0);
    tracep->pushNamePrefix("pc_top ");
    tracep->declBus(c+7,"PC_WIDTH", false,-1, 31,0);
    tracep->declBus(c+1,"imm_op", false,-1, 31,0);
    tracep->declBit(c+2,"clk", false,-1);
    tracep->declBit(c+3,"rst", false,-1);
    tracep->declBit(c+4,"pc_src", false,-1);
    tracep->declBus(c+5,"pc", false,-1, 15,0);
    tracep->declBus(c+6,"next_pc", false,-1, 15,0);
    tracep->pushNamePrefix("pc_reg ");
    tracep->declBus(c+7,"PC_WIDTH", false,-1, 31,0);
    tracep->declBit(c+2,"clk", false,-1);
    tracep->declBit(c+3,"rst", false,-1);
    tracep->declBus(c+6,"next_pc", false,-1, 15,0);
    tracep->declBus(c+5,"pc", false,-1, 15,0);
    tracep->popNamePrefix(2);
}

VL_ATTR_COLD void Vpc_top___024root__trace_init_top(Vpc_top___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root__trace_init_top\n"); );
    // Body
    Vpc_top___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vpc_top___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vpc_top___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vpc_top___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vpc_top___024root__trace_register(Vpc_top___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&Vpc_top___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&Vpc_top___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&Vpc_top___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vpc_top___024root__trace_full_sub_0(Vpc_top___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vpc_top___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root__trace_full_top_0\n"); );
    // Init
    Vpc_top___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vpc_top___024root*>(voidSelf);
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vpc_top___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vpc_top___024root__trace_full_sub_0(Vpc_top___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+1,(vlSelf->imm_op),32);
    bufp->fullBit(oldp+2,(vlSelf->clk));
    bufp->fullBit(oldp+3,(vlSelf->rst));
    bufp->fullBit(oldp+4,(vlSelf->pc_src));
    bufp->fullSData(oldp+5,(vlSelf->pc),16);
    bufp->fullSData(oldp+6,((0xffffU & ((IData)(vlSelf->pc_src)
                                         ? ((IData)(vlSelf->pc) 
                                            + vlSelf->imm_op)
                                         : ((IData)(4U) 
                                            + (IData)(vlSelf->pc))))),16);
    bufp->fullIData(oldp+7,(0x10U),32);
}
