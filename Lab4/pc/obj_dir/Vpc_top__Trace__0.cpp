// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vpc_top__Syms.h"


void Vpc_top___024root__trace_chg_sub_0(Vpc_top___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vpc_top___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root__trace_chg_top_0\n"); );
    // Init
    Vpc_top___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vpc_top___024root*>(voidSelf);
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vpc_top___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void Vpc_top___024root__trace_chg_sub_0(Vpc_top___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    bufp->chgIData(oldp+0,(vlSelf->imm_op),32);
    bufp->chgBit(oldp+1,(vlSelf->clk));
    bufp->chgBit(oldp+2,(vlSelf->rst));
    bufp->chgBit(oldp+3,(vlSelf->pc_src));
    bufp->chgSData(oldp+4,(vlSelf->pc),16);
    bufp->chgSData(oldp+5,((0xffffU & ((IData)(vlSelf->pc_src)
                                        ? ((IData)(vlSelf->pc) 
                                           + vlSelf->imm_op)
                                        : ((IData)(4U) 
                                           + (IData)(vlSelf->pc))))),16);
}

void Vpc_top___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root__trace_cleanup\n"); );
    // Init
    Vpc_top___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vpc_top___024root*>(voidSelf);
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VlUnpacked<CData/*0:0*/, 1> __Vm_traceActivity;
    // Body
    vlSymsp->__Vm_activity = false;
    __Vm_traceActivity[0U] = 0U;
}
