/*
 * circuit.h  --  ECSE 318 Lab 5
 *
 * Data record for one gate (Figure P2) and the functions that the
 * parser (parse.y) calls while it reads the circuit description.
 */
#ifndef CIRCUIT_H
#define CIRCUIT_H

/* Integer code for every gate type (printed in the "GateType" column) */
#define T_INPUT  0      /* primary input                  */
#define T_AND    1
#define T_NAND   2
#define T_OR     3
#define T_NOR    4
#define T_XOR    5
#define T_XNOR   6
#define T_BUF    7      /* also used for the fanout BUFs   */
#define T_NOT    8
#define T_DFF    9      /* D flip-flop (pseudo input)      */

/* Figure P2: data record of one gate */
struct gate {
    char *name;               /* Gate name (name of its output line)   */
    int   type;               /* Gate type (T_xxx code above)          */

    struct gate **fanin;      /* List of pointers to fanin gates       */
    int   nfanin;
    char **fanin_name;        /* fanin names as read (resolved later)  */

    struct gate **fanout;     /* List of pointers to fanout gates      */
    int   nfanout;

    struct gate *next;        /* Pointer to the next gate              */

    int   level;              /* gate level  (-1 = not assigned yet)   */
    int   output;             /* 1 if this gate drives a primary output */
    int   id;                 /* integer number used in the listing    */
};

/* called from parse.y */
void name_add(char *s);
void name_clear(void);
void decl_inputs(void);
void decl_outputs(void);
void decl_gate(int type, char *instance);

#endif
