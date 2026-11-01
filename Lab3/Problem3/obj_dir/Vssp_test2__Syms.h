// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VSSP_TEST2__SYMS_H_
#define VERILATED_VSSP_TEST2__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vssp_test2.h"

// INCLUDE MODULE CLASSES
#include "Vssp_test2___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES) Vssp_test2__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vssp_test2* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool& __Vm_didInit;

    // MODULE INSTANCE STATE
    Vssp_test2___024root           TOP;

    // CONSTRUCTORS
    Vssp_test2__Syms(VerilatedContext* contextp, const char* namep, Vssp_test2* modelp);
    ~Vssp_test2__Syms();

    // METHODS
    const char* name() const { return TOP.vlNamep; }
};

#endif  // guard
