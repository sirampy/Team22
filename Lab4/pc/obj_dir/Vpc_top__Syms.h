// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VPC_TOP__SYMS_H_
#define VERILATED_VPC_TOP__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vpc_top.h"

// INCLUDE MODULE CLASSES
#include "Vpc_top___024root.h"

// SYMS CLASS (contains all model state)
class Vpc_top__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vpc_top* const __Vm_modelp;
    bool __Vm_activity = false;  ///< Used by trace routines to determine change occurred
    uint32_t __Vm_baseCode = 0;  ///< Used by trace routines when tracing multiple models
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vpc_top___024root              TOP;

    // CONSTRUCTORS
    Vpc_top__Syms(VerilatedContext* contextp, const char* namep, Vpc_top* modelp);
    ~Vpc_top__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
