// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vssp_test2.h for the primary calling header

#ifndef VERILATED_VSSP_TEST2___024ROOT_H_
#define VERILATED_VSSP_TEST2___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vssp_test2__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vssp_test2___024root final {
  public:

    // DESIGN-SPECIFIC STATE
    CData/*0:0*/ ssp_test2__DOT__clock;
    CData/*0:0*/ __Vtrigprevexpr___TOP__ssp_test2__DOT__clock__0;
    IData/*31:0*/ __Vi;
    VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VicoTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggeredAcc;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
    VlTriggerScheduler __VtrigSched_h743077f1__0;
    VlDelayScheduler __VdlySched;

    // INTERNAL VARIABLES
    Vssp_test2__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vssp_test2___024root(Vssp_test2__Syms* symsp, const char* namep);
    ~Vssp_test2___024root();
    VL_UNCOPYABLE(Vssp_test2___024root);

    // INTERNAL METHODS
};


#endif  // guard
