// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vssp_test2.h for the primary calling header

#include "Vssp_test2__pch.h"

VlCoroutine Vssp_test2___024root___eval_initial__TOP__Vtiming__0(Vssp_test2___024root* vlSelf);
VlCoroutine Vssp_test2___024root___eval_initial__TOP__Vtiming__1(Vssp_test2___024root* vlSelf);

void Vssp_test2___024root___eval_initial(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_initial\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vssp_test2___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Vssp_test2___024root___eval_initial__TOP__Vtiming__1(vlSelf);
}

void Vssp_test2___024root___eval_sample(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_sample\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vssp_test2___024root___dump_triggers__ico(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vssp_test2___024root___eval_ico(Vssp_test2___024root* vlSelf, CData/*0:0*/ firstIteration) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_ico\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VicoTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VicoTriggered[0U]) 
                                     | (IData)((IData)(firstIteration)));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vssp_test2___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
    }
#endif
    return (0U);
}

void Vssp_test2___024root___timing_ready(Vssp_test2___024root* vlSelf);
void Vssp_test2___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vssp_test2___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
bool Vssp_test2___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);
void Vssp_test2___024root___timing_resume(Vssp_test2___024root* vlSelf);

bool Vssp_test2___024root___eval_act(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_act\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VactExecute;
    // Body
    {
        // Inlined CFunc: _eval_triggers_vec__act
        vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                        ((vlSelfRef.__VdlySched.awaitingCurrentTime() 
                                                          << 1U) 
                                                         | ((IData)(vlSelfRef.ssp_test2__DOT__clock) 
                                                            & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__ssp_test2__DOT__clock__0))))));
        vlSelfRef.__Vtrigprevexpr___TOP__ssp_test2__DOT__clock__0 
            = vlSelfRef.ssp_test2__DOT__clock;
    }
    Vssp_test2___024root___timing_ready(vlSelf);
    Vssp_test2___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VactTriggered, vlSelfRef.__VactTriggeredAcc);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vssp_test2___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vssp_test2___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    __VactExecute = Vssp_test2___024root___trigger_anySet__act(vlSelfRef.__VactTriggered);
    if (__VactExecute) {
        vlSelfRef.__VactTriggeredAcc.fill(0ULL);
        Vssp_test2___024root___timing_resume(vlSelf);
    }
    return (__VactExecute);
}

bool Vssp_test2___024root___eval_inact(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_inact\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VinactExecute;
    // Body
    __VinactExecute = vlSelfRef.__VdlySched.awaitingZeroDelay();
    if (__VinactExecute) {
        VL_FATAL_MT("ssptest.v", 47, "", "ZERODLY: Design Verilated with '--no-sched-zero-delay', but #0 delay executed at runtime");
    }
    return (__VinactExecute);
}

void Vssp_test2___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out);

bool Vssp_test2___024root___eval_nba(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_nba\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vssp_test2___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        Vssp_test2___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

bool Vssp_test2___024root___eval_obs(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_obs\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    return (0U);
}

bool Vssp_test2___024root___eval_react(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_react\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    return (0U);
}

void Vssp_test2___024root___eval_postponed(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_postponed\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vssp_test2___024root____VbeforeTrig_h743077f1__0(Vssp_test2___024root* vlSelf, const char* __VeventDescription);

VlCoroutine Vssp_test2___024root___eval_initial__TOP__Vtiming__0(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_initial__TOP__Vtiming__0\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.ssp_test2__DOT__clock = 0U;
    Vssp_test2___024root____VbeforeTrig_h743077f1__0(vlSelf, 
                                                     "@(posedge ssp_test2.clock)");
    co_await vlSelfRef.__VtrigSched_h743077f1__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge ssp_test2.clock)", 
                                                         "ssptest.v", 
                                                         59);
    co_await vlSelfRef.__VdlySched.delay(1ULL, nullptr, 
                                         "ssptest.v", 
                                         60);
    Vssp_test2___024root____VbeforeTrig_h743077f1__0(vlSelf, 
                                                     "@(posedge ssp_test2.clock)");
    co_await vlSelfRef.__VtrigSched_h743077f1__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge ssp_test2.clock)", 
                                                         "ssptest.v", 
                                                         61);
    co_await vlSelfRef.__VdlySched.delay(1ULL, nullptr, 
                                         "ssptest.v", 
                                         63);
    co_await vlSelfRef.__VdlySched.delay(0x000000000000000fULL, 
                                         nullptr, "ssptest.v", 
                                         65);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000028ULL, 
                                         nullptr, "ssptest.v", 
                                         67);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000028ULL, 
                                         nullptr, "ssptest.v", 
                                         68);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000028ULL, 
                                         nullptr, "ssptest.v", 
                                         69);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000028ULL, 
                                         nullptr, "ssptest.v", 
                                         70);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000028ULL, 
                                         nullptr, "ssptest.v", 
                                         71);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000028ULL, 
                                         nullptr, "ssptest.v", 
                                         72);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000028ULL, 
                                         nullptr, "ssptest.v", 
                                         73);
    co_await vlSelfRef.__VdlySched.delay(0x000000000000001eULL, 
                                         nullptr, "ssptest.v", 
                                         74);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000366ULL, 
                                         nullptr, "ssptest.v", 
                                         75);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000050ULL, 
                                         nullptr, "ssptest.v", 
                                         77);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000028ULL, 
                                         nullptr, "ssptest.v", 
                                         78);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000e10ULL, 
                                         nullptr, "ssptest.v", 
                                         79);
    co_await vlSelfRef.__VdlySched.delay(0x0000000000000028ULL, 
                                         nullptr, "ssptest.v", 
                                         81);
    VL_FINISH_MT("ssptest.v", 81, "");
    co_return;
}

VlCoroutine Vssp_test2___024root___eval_initial__TOP__Vtiming__1(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_initial__TOP__Vtiming__1\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    while (VL_LIKELY(!vlSymsp->_vm_contextp__->gotFinish())) {
        co_await vlSelfRef.__VdlySched.delay(0x0000000000000014ULL, 
                                             nullptr, 
                                             "ssptest.v", 
                                             85);
        vlSelfRef.ssp_test2__DOT__clock = (1U & (~ (IData)(vlSelfRef.ssp_test2__DOT__clock)));
    }
    co_return;
}

bool Vssp_test2___024root___trigger_anySet__ico(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___trigger_anySet__ico\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

bool Vssp_test2___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___trigger_anySet__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vssp_test2___024root___timing_ready(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___timing_ready\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VtrigSched_h743077f1__0.ready("@(posedge ssp_test2.clock)");
    }
}

void Vssp_test2___024root___timing_resume(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___timing_resume\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VtrigSched_h743077f1__0.moveToResumeQueue(
                                                          "@(posedge ssp_test2.clock)");
    vlSelfRef.__VtrigSched_h743077f1__0.resume("@(posedge ssp_test2.clock)");
    if ((2ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VdlySched.resume();
    }
}

void Vssp_test2___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

void Vssp_test2___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

void Vssp_test2___024root____VbeforeTrig_h743077f1__0(Vssp_test2___024root* vlSelf, const char* __VeventDescription) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root____VbeforeTrig_h743077f1__0\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlUnpacked<QData/*63:0*/, 1> __VTmp;
    // Body
    __VTmp[0U] = (QData)((IData)(((IData)(vlSelfRef.ssp_test2__DOT__clock) 
                                  & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__ssp_test2__DOT__clock__0)))));
    vlSelfRef.__Vtrigprevexpr___TOP__ssp_test2__DOT__clock__0 
        = vlSelfRef.ssp_test2__DOT__clock;
    if ((1ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h743077f1__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h743077f1__0.ready(__VeventDescription);
    }
    vlSelfRef.__VactTriggeredAcc[0U] = (vlSelfRef.__VactTriggeredAcc[0U] 
                                        | __VTmp[0U]);
}

#ifdef VL_DEBUG
void Vssp_test2___024root___eval_debug_assertions(Vssp_test2___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vssp_test2___024root___eval_debug_assertions\n"); );
    Vssp_test2__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
