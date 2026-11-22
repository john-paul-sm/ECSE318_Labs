%{

#include 	<stdio.h>
#include	"circuit.h"


extern int yyerror();
extern int yyparse();
extern int yylex();
extern int    yylineno ;
int    nbits ;
char	*iname;

#define YYDEBUG 1
%}

%start  module

%union {
        char *id;
	unsigned long	ln;
}


/* Keywords */

%token NAND WIRE AND OR NOR XOR XNOR BUF NOT DFF OUTPUT INPUT MoDULE ENDMoDULE

/* string or number or name */
%token <id> _NAME _STRING
%token <ln> _NUMBER
%token <ln> _BASENUMBER

/* gate_type returns the integer gate code (T_AND, T_OR, ...) */
%type  <ln> gate_type

/* Directives */

%%

module:
      	MoDULE _NAME  '(' port_list ')' ';'  { name_clear(); }	/* module ports not needed */
	module_items ENDMoDULE
	;

port_list: port_ref
	| port_list ',' port_ref
	;

port_ref: _NAME				{ name_add($1); }
	;

module_items: module_item
	| module_items module_item
	;

module_item: input_declaration
	| output_declaration		/* Done */
	| net_declaration		/* Done */
	| gate_instantiation		/* Done */
        | error ';'			{ name_clear(); yyerrok; }
	;

input_declaration: INPUT  NAME_list ';'		{ decl_inputs(); }
	;

output_declaration: OUTPUT  NAME_list ';'	{ decl_outputs(); }
	;

NAME_list: _NAME			{ name_add($1); }
	| NAME_list ',' _NAME		{ name_add($3); }
	;

net_declaration:
          net_type NAME_list ';'	{ name_clear(); }	/* wires are just connections */
	;

net_type: WIRE
	;

gate_instantiation:
	  gate_type   _NAME '(' port_list ')' ';'	{ decl_gate($1, $2); }
	;

gate_type: AND 					{ $$ = T_AND;  }
	| NAND 					{ $$ = T_NAND; }
	| OR 					{ $$ = T_OR;   }
	| NOR 					{ $$ = T_NOR;  }
	| XOR 					{ $$ = T_XOR;  }
	| XNOR					{ $$ = T_XNOR; }
	| BUF 					{ $$ = T_BUF;  }
	| NOT 					{ $$ = T_NOT;  }
	| DFF					{ $$ = T_DFF;  }
	;


%%

extern char *yytext;

int yyerror(const char*s){


        printf("line %d: '%s'  near '%s' \n",yylineno,s, yytext);
        return 0;
}

