%{

#include 	<stdio.h>


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

/* Directives */

%%

module: 
      	MoDULE _NAME  '(' port_list ')' ';'  module_items ENDMoDULE	
	;

port_list: port_ref				
	| port_list ',' port_ref	
	;

port_ref: _NAME				
	;

module_items: module_item
	| module_items module_item
	;

module_item: input_declaration		
	| output_declaration		/* Done */
	| net_declaration		/* Done */
	| gate_instantiation		/* Done */
        | error ';'
	;

input_declaration: INPUT  NAME_list ';' { printf("\n Input List");}
	;

output_declaration: OUTPUT  NAME_list ';' { printf("\n Output List");}
	;

NAME_list: _NAME	
	| NAME_list ',' _NAME
	;

net_declaration: 
          net_type NAME_list ';'	
	;

net_type: WIRE 					{ printf("\n WIRES ");}
	;

gate_instantiation:
	  gate_type   _NAME '(' port_list ')' ';'
	;

gate_type: AND 					{ printf("\n AND");}
	| NAND 					{ printf("\n AND");}
	| OR 					{ printf("\n OR");}
	| NOR 					{ printf("\n NOR");}
	| XOR 					{ printf("\n XOR");}
	| XNOR					{ printf("\n XNOR");}
	| BUF 					{ printf("\n BUF");}
	| NOT 					{ printf("\n NOT");}
	| DFF					{ printf("\n DFF");}
	;


%%

extern char *yytext;

int yyerror(const char*s){


        printf("line %d: '%s'  near '%s' \n",yylineno,s, yytext);
        return 0;
}

