// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vpc_top.h for the primary calling header

#include "verilated.h"

#include "Vpc_top__Syms.h"
#include "Vpc_top___024root.h"

void Vpc_top___024root___ctor_var_reset(Vpc_top___024root* vlSelf);

Vpc_top___024root::Vpc_top___024root(Vpc_top__Syms* symsp, const char* name)
    : VerilatedModule{name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vpc_top___024root___ctor_var_reset(this);
}

void Vpc_top___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vpc_top___024root::~Vpc_top___024root() {
}
