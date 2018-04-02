alpha [a-zA-Z]
digit [0-9]

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
for return FOR;
"==" return EQ;
"<=" return LEQ;
">=" return GEQ;
"<" return LT;
">" return GT;
"!=" return NEQ;
"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"%" return MOD;
{digit}+ return NUM;
{alpha}+ return ID;
#.* ;
\/\*(.*\n)*.*\*\/ ;
[ \n] { yylineno = yylineno + 1;};
. return yytext[0];
%%