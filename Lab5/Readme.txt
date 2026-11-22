To compile:
	bison -d parse.y
	flex tokens.l
	gcc main.c lex.yy.c parse.tab.c

To Run:

	a.out s27.v


