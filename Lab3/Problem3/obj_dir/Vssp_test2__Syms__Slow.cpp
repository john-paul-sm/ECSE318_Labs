// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vssp_test2__pch.h"

Vssp_test2__Syms::Vssp_test2__Syms(VerilatedContext* contextp, const char* namep, Vssp_test2* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    , __Vm_didInit{modelp->m_didInit}
    // Setup top module instance
    , TOP{this, namep}
{
    // Check resources
    Verilated::stackCheck(21);
    // Setup sub module instances
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-12);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
}

Vssp_test2__Syms::~Vssp_test2__Syms() {
    // Tear down scopes
    // Tear down sub module instances
}
