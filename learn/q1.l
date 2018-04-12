alpha [a-zA-Z]
digit [0-9]

%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "symtable.h"
%}

%%
[ \t] ;
def return DEF;
main return MAIN;
int return INT;
float return FLOAT;
void return VOID;
continue return CONTINUE;
break return BREAK;
return return RETURN;
input return INPUT;
print return PRINT;
true return TRUE;
false return FALSE;
for return FOR;
if return IF;
else return ELSE;
elif return ELSE_IF;
"&&" return AND;
"||" return OR;
"!" return NOT;
"==" return EQ;
"<=" return LEQ;
">=" return GEQ;
"<" return LT;
">" return GT;
"!=" return NEQ;
"+" { yylval.op = '+'; return ADD; }
"-" { yylval.op = '-'; return SUB; }
"*" { yylval.op = '*'; return MUL; }
"/" { yylval.op = '/'; return DIV; }
"%" { yylval.op = '%'; return MOD; }
{digit}+ { yylval.ivalue = atoi(yytext); return NUM; }
{alpha}+ { yylval.string = strdup(yytext); return ID; }
#.* ;
\/\*(.*\n)*.*\*\/ ;
[ \n] { yylineno = yylineno + 1;};
. return yytext[0];
%%