// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vssp_test2__pch.h"

//============================================================
// Constructors

Vssp_test2::Vssp_test2(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vssp_test2__Syms(contextp(), _vcname__, this)}
    , m_evalLoop{*this, /*convergeLimit:*/ 10000}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vssp_test2::Vssp_test2(const char* _vcname__)
    : Vssp_test2(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vssp_test2::~Vssp_test2() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vssp_test2___024root___eval_debug_assertions(Vssp_test2___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vssp_test2___024root___eval_static(Vssp_test2___024root* vlSelf);
void Vssp_test2___024root___eval_initial(Vssp_test2___024root* vlSelf);
VL_ATTR_COLD bool Vssp_test2___024root___eval_stl(Vssp_test2___024root* vlSelf, CData/*0:0*/ firstIteration);
void Vssp_test2___024root___eval_sample(Vssp_test2___024root* vlSelf);
bool Vssp_test2___024root___eval_ico(Vssp_test2___024root* vlSelf, CData/*0:0*/ firstIteration);
bool Vssp_test2___024root___eval_act(Vssp_test2___024root* vlSelf);
bool Vssp_test2___024root___eval_inact(Vssp_test2___024root* vlSelf);
bool Vssp_test2___024root___eval_nba(Vssp_test2___024root* vlSelf);
bool Vssp_test2___024root___eval_obs(Vssp_test2___024root* vlSelf);
bool Vssp_test2___024root___eval_react(Vssp_test2___024root* vlSelf);
void Vssp_test2___024root___eval_postponed(Vssp_test2___024root* vlSelf);
VL_ATTR_COLD void Vssp_test2___024root___eval_final(Vssp_test2___024root* vlSelf);
VL_ATTR_COLD void Vssp_test2___024root___eval_dump_triggers__stl(Vssp_test2___024root* vlSelf);
VL_ATTR_COLD void Vssp_test2___024root___eval_dump_triggers__ico(Vssp_test2___024root* vlSelf);
VL_ATTR_COLD void Vssp_test2___024root___eval_dump_triggers__act(Vssp_test2___024root* vlSelf);
VL_ATTR_COLD void Vssp_test2___024root___eval_dump_triggers__nba(Vssp_test2___024root* vlSelf);
VL_ATTR_COLD void Vssp_test2___024root___eval_dump_triggers__obs(Vssp_test2___024root* vlSelf);
VL_ATTR_COLD void Vssp_test2___024root___eval_dump_triggers__react(Vssp_test2___024root* vlSelf);

void Vssp_test2::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vssp_test2::eval_step\n"); );
    m_evalLoop.eval();
}

void Vssp_test2::evalBegin() {
#ifdef VL_DEBUG
    // Debug assertions
    Vssp_test2___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
}

void Vssp_test2::evalEnd() {
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
    vlSymsp->TOP.__VdlySched.cleanupForevered();
}

void Vssp_test2::evalStatic() {
    Vssp_test2___024root___eval_static(&(vlSymsp->TOP));
}

void Vssp_test2::evalInitial() {
    Vssp_test2___024root___eval_initial(&(vlSymsp->TOP));
}

bool Vssp_test2::evalStl(bool firstIteration) {
    return Vssp_test2___024root___eval_stl(&(vlSymsp->TOP), firstIteration);
}

void Vssp_test2::evalSample() {
    Vssp_test2___024root___eval_sample(&(vlSymsp->TOP));
}

bool Vssp_test2::evalIco(bool firstIteration) {
    return Vssp_test2___024root___eval_ico(&(vlSymsp->TOP), firstIteration);
}

bool Vssp_test2::evalAct() {
    return Vssp_test2___024root___eval_act(&(vlSymsp->TOP));
}

bool Vssp_test2::evalInact() {
    return Vssp_test2___024root___eval_inact(&(vlSymsp->TOP));
}

bool Vssp_test2::evalNba() {
    return Vssp_test2___024root___eval_nba(&(vlSymsp->TOP));
}

bool Vssp_test2::evalObs() {
    return Vssp_test2___024root___eval_obs(&(vlSymsp->TOP));
}

bool Vssp_test2::evalReact() {
    return Vssp_test2___024root___eval_react(&(vlSymsp->TOP));
}

void Vssp_test2::evalPostponed() {
    Vssp_test2___024root___eval_postponed(&(vlSymsp->TOP));
}

void Vssp_test2::evalFinal() {
    Vssp_test2___024root___eval_final(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vssp_test2::dumpTriggersStl() {
    Vssp_test2___024root___eval_dump_triggers__stl(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vssp_test2::dumpTriggersIco() {
    Vssp_test2___024root___eval_dump_triggers__ico(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vssp_test2::dumpTriggersAct() {
    Vssp_test2___024root___eval_dump_triggers__act(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vssp_test2::dumpTriggersNba() {
    Vssp_test2___024root___eval_dump_triggers__nba(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vssp_test2::dumpTriggersObs() {
    Vssp_test2___024root___eval_dump_triggers__obs(&(vlSymsp->TOP));
}

VL_ATTR_COLD void Vssp_test2::dumpTriggersReact() {
    Vssp_test2___024root___eval_dump_triggers__react(&(vlSymsp->TOP));
}

//============================================================
// Events and timing
bool Vssp_test2::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty() && !contextp()->gotFinish(); }

uint64_t Vssp_test2::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vssp_test2::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

VL_ATTR_COLD void Vssp_test2::final() {
    contextp()->executingFinal(true);
    evalFinal();
    contextp()->executingFinal(false);
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vssp_test2::hierName() const { return vlSymsp->name(); }
const char* Vssp_test2::modelName() const { return "Vssp_test2"; }
unsigned Vssp_test2::threads() const { return 1; }
void Vssp_test2::prepareClone() const { contextp()->prepareClone(); }
void Vssp_test2::atClone() const {
    contextp()->threadPoolpOnClone();
}
