// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vssp_test2.h for the primary calling header

#include "Vssp_test2__pch.h"

void Vssp_test2___024root___ctor_var_reset(Vssp_test2___024root* vlSelf);

Vssp_test2___024root::Vssp_test2___024root(Vssp_test2__Syms* symsp, const char* namep)
    : __VdlySched{*symsp->_vm_contextp__}
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vssp_test2___024root___ctor_var_reset(this);
}

Vssp_test2___024root::~Vssp_test2___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
