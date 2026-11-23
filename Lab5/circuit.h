#ifndef CIRCUIT_H
#define CIRCUIT_H

#define T_INPUT 0
#define T_AND 1
#define T_NAND 2
#define T_OR 3
#define T_NOR 4
#define T_XOR 5
#define T_XNOR 6
#define T_BUF 7
#define T_NOT 8
#define T_DFF 9

struct gate {
    char *name;
    int type;

    struct gate **fanin;
    int nfanin;
    char **fanin_name;

    struct gate **fanout;
    int nfanout;

    struct gate *next;

    int level;
    int output;
    int id;
};

void name_add(char *s);
void name_clear(void);
void decl_inputs(void);
void decl_outputs(void);
void decl_gate(int type, char *instance);

#endif
