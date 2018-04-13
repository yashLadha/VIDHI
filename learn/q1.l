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
int { yylval.string = "int"; return INT; }
float { yylval.string = "float"; return FLOAT; }
void { yylval.string = "void"; return VOID; }
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
"&&" { yylval.string = "&&"; return AND; }
"||" { yylval.string = "||"; return OR; }
"==" { yylval.string = "=="; return EQ; }
"<=" { yylval.string = "<="; return LEQ; }
">=" { yylval.string = ">="; return GEQ; }
"<" { yylval.string = "<"; return LT; }
">" { yylval.string = ">"; return GT; }
"!=" { yylval.string = "!="; return NEQ; }
"+" { yylval.op = '+'; return ADD; }
"-" { yylval.op = '-'; return SUB; }
"*" { yylval.op = '*'; return MUL; }
"/" { yylval.op = '/'; return DIV; }
"%" { yylval.op = '%'; return MOD; }
{digit}+ { yylval.ivalue = atoi(yytext); return NUM; }
{alpha}+ { yylval.string = strdup(yytext); return ID; }
\".*\" { yylval.string = strdup(yytext); return STRING; }
#.* ;
\/\*(.*\n)*.*\*\/ ;
[ \n] { yylineno = yylineno + 1; };
. return yytext[0];
%%