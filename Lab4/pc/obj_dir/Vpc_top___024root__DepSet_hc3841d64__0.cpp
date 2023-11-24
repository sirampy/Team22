// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vpc_top.h for the primary calling header

#include "verilated.h"

#include "Vpc_top___024root.h"

VL_INLINE_OPT void Vpc_top___024root___sequent__TOP__0(Vpc_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root___sequent__TOP__0\n"); );
    // Body
    vlSelf->pc = ((IData)(vlSelf->rst) ? 0U : (IData)(vlSelf->pc_top__DOT__next_pc));
}

VL_INLINE_OPT void Vpc_top___024root___combo__TOP__0(Vpc_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root___combo__TOP__0\n"); );
    // Body
    vlSelf->pc_top__DOT__next_pc = (0xffffU & ((IData)(vlSelf->pc_src)
                                                ? ((IData)(vlSelf->pc) 
                                                   + vlSelf->imm_op)
                                                : ((IData)(4U) 
                                                   + (IData)(vlSelf->pc))));
}

void Vpc_top___024root___eval(Vpc_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root___eval\n"); );
    // Body
    if ((((IData)(vlSelf->clk) & (~ (IData)(vlSelf->__Vclklast__TOP__clk))) 
         | ((IData)(vlSelf->rst) & (~ (IData)(vlSelf->__Vclklast__TOP__rst))))) {
        Vpc_top___024root___sequent__TOP__0(vlSelf);
    }
    Vpc_top___024root___combo__TOP__0(vlSelf);
    // Final
    vlSelf->__Vclklast__TOP__clk = vlSelf->clk;
    vlSelf->__Vclklast__TOP__rst = vlSelf->rst;
}

#ifdef VL_DEBUG
void Vpc_top___024root___eval_debug_assertions(Vpc_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vpc_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpc_top___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
    if (VL_UNLIKELY((vlSelf->pc_src & 0xfeU))) {
        Verilated::overWidthError("pc_src");}
}
#endif  // VL_DEBUG
