%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "symtable.h"

    extern FILE *fp;
%}

%union {
    int ivalue;
    char *string;
    char op;
}

%token <string> INT FLOAT VOID
%token CONTINUE BREAK
%token INPUT PRINT
%token <ivalue> NUM
%token <string> ID
%token RETURN FOR WHILE
%token <string> EQ LEQ GEQ GT LT NEQ
%left <op> ADD SUB
%token <op> MUL DIV MOD
%token DEF MAIN
%token IF
%token ELSE
%token ELSE_IF
%token AND
%token OR
%token TRUE
%token <string> STRING
%token FALSE

%type <ivalue> arithmectic_expression comparison_statement condition_expr
%type <op> operator
%type <string> conditional_operator identifiers data_type

%%
start: DEF MAIN '(' param ')' ':' data_type '=' '{'block'}'
    | function start
    ;

function: DEF ID '(' param ')' ':' data_type '=' '{' block '}'
    ;

param: function_param
    |
    ;

function_param: data_type ID
    ;

data_type: INT { $$ = $1; }
    | VOID { $$ = $1; }
    ;

block: expressions
    |
    ;

return_stmt: RETURN ID
    | RETURN NUM
    | RETURN
    | RETURN arithmectic_expression
    ;

expressions: expressions expr_stmt
    | expr_stmt
    ;

expr_stmt: return_stmt
    | input_stmt
    | loop_stmt
    | decl_stmt
    | function_call_stmt
    | assignment_stmt
    | skip_stmt
    | break_stmt
    | arithmetic_stmt
    | output_stmt
    | condition_stmt
    ;

output_stmt: PRINT'(' ID ')' {
    symtable *node = (symtable *)get($3);
    if (node != 0) {
        if (node->sym_type == 0) {
            printf("%d\n", node->int_val);
        } else if (node->sym_type == 1) {
            printf("%s\n", node->char_val);
        }
    } else {
        yyerror("No variable exists");
    }
}
    | PRINT '(' NUM ')' {
        printf("%d\n", $3);
    }
    | PRINT '(' STRING ')' {
        printf("%s\n", $3);
    }
    ;

arithmetic_stmt: ID '=' arithmectic_expression {
    if (get($1) == 0) {
        yyerror("Variable undefined");
    } else {
        update($1, $3, NULL);
    }
} ;

break_stmt: BREAK
    ;

skip_stmt: CONTINUE
    ;

assignment_stmt: ID '=' ID {
    if (get($1) == 0 || get($3) == 0) {
        yyerror("Variable undefined");
    } else if (get($1)->sym_type != get($3)->sym_type) {
        yyerror("Mismatch types");
    } else {
        change_val(get($1), get($3));
    }
}
    | ID '=' NUM {
            if (get($1) == 0)
                insert($1, 0, $3, NULL);
            else
                update($1, $3, NULL);
        }
    ;

decl_stmt: data_type identifiers { insert_decl($1, $2); }

identifiers: identifiers ',' identifiers {
    $$ = $1;
    strcat($$, ",");
    strcat($$, $3);
}
    | ID { $$ = $1; }
    ;

condition_stmt: IF '(' condition_expr ')' '{' block '}' elif_stmt else_stmt
    ;

elif_stmt: ELSE_IF '(' condition_expr ')' '{' block '}' else_stmt
    |
   ;

else_stmt: ELSE '{' block '}'
    |
    ;

condition_expr: condition_expr AND condition_expr {
    if ($1 == 1 && $3 == 1) {
        $$ = 1;
    } else {
        $$ = 0;
    }
}
   | condition_expr OR condition_expr {
       if ($1 == 1 || $3 == 1) {
           $$ = 1;
       } else {
           $$ = 0;
       }
   }
   | TRUE { $$ = 1; }
   | FALSE { $$ = 0; }
   | comparison_statement { $$ = $1; }
   | '(' condition_expr ')' { $$ = $2; }
   ;

comparison_statement: ID conditional_operator ID {
        if (strcmp($2, "==") == 0) {
            if (get($1)->int_val == get($3)->int_val) {
                $$ = 1;
            } else {
                $$ = 0;
            }
        } else if (strcmp($2, ">") == 0) {
            if (get($1)->int_val > get($3)->int_val){
                $$ = 1;
            } else {
                $$ = 0;
            }
        } else if (strcmp($2, "<") == 0) {
            if (get($1)->int_val < get($3)->int_val){
                $$ = 1;
            } else {
                $$ = 0;
            }
        } else if (strcmp($2, ">=") == 0) {
            if (get($1)->int_val >= get($3)->int_val) {
                $$ = 1;
            } else {
                $$ = 0;
            }
        } else if (strcmp($2, "<=") == 0) {
            if (get($1)->int_val <= get($3)->int_val) {
                $$ = 1;
            } else {
                $$ = 0;
            }
        } else if (strcmp($2, "!=") == 0) {
            if (get($1)->int_val != get($3)->int_val) {
                $$ = 1;
            } else {
                $$ = 0;
            }
        }
    }
    | ID conditional_operator arithmectic_expression {
        if (get($1)->sym_type != 0) {
            yyerror("Incompatible data types");
        }
        if (strcmp($2, "==") == 0) {
            if (get($1)->int_val == $3) {
                $$ = 1;
            } else {
                $$ = 0;
            }
        } else if (strcmp($2, ">") == 0) {
            if (get($1)->int_val > $3) {
                $$ = 1;
            } else {
                $$ = 0;
            }
        } else if (strcmp($2, "<") == 0) {
            if (get($1)->int_val < $3) {
                $$ = 1;
            } else {
                $$ = 0;
            }
        } else if (strcmp($2, ">=") == 0) {
            if (get($1)->int_val >= $3) {
                $$ = 1;
            } else {
                $$ = 0;
            }
        } else if (strcmp($2, "<=") == 0) {
            if (get($1)->int_val <= $3) {
                $$ = 1;
            } else {
                $$ = 0;
            }
        } else if (strcmp($2, "!=") == 0) {
            if (get($1)->int_val != $3) {
                $$ = 1;
            } else {
                $$ = 0;
            }
        }
    }
    ;

conditional_operator: EQ { $$ = $1; }
    | LEQ { $$ = $1; }
    | GEQ { $$ = $1; }
    | NEQ { $$ = $1; }
    | LT { $$ = $1; }
    | GT { $$ = $1; }
    ;

arithmectic_expression: arithmectic_expression operator arithmectic_expression {
    if ($2 == '+') {
        $$ = $1 + $3;
    } else if ($2 == '-') {
        $$ = $1 - $3;
    } else if ($2 == '*') {
        $$ = $1 * $3;
    } else if ($2 == '/') {
        if ($3 == 0) {
            yyerror("Divide by zero not allowed");
        } else {
            $$ = $1 / $3;
        }
    } else if ($2 == '%') {
        if ($3 == 0) {
            yyerror("Divide by zero not allowed");
        } else {
            $$ = $1 % $3;
        }
    }
}
    | ID { $$ = get($1)->int_val; }
    | NUM { $$ = $1; }
    | '('arithmectic_expression')' { $$ = $2; }
    ;

operator: ADD { $$ = $1; }
    | MUL { $$ = $1; }
    | SUB { $$ = $1; }
    | DIV { $$ = $1; }
    | MOD { $$ = $1; }
    ;

function_call_stmt: ID '(' param ')'
    ;

input_stmt: INPUT'('ID')'
    ;

loop_stmt: FOR '('initialize_loop';' loop_invariant ';' loop_increment ')' '{' block '}'  //empty parameters
    ;

initialize_loop: assignment_stmt
    | decl_stmt
    |
    ;

loop_invariant: comparison_statement
    |
    ;

loop_increment: ID '=' arithmectic_expression
    |
    ;

%%
#include "lex.yy.c"
#include <ctype.h>

int yyerror(char *s) {
    fprintf(stderr, "Error: %s / %s / %d\n", s, yytext, yylineno+1);
    exit(1);
}

int main(int argc, char **argv) {
    yyin = fopen(argv[1], "r");

    if (!yyparse()) {
        printf("Parsing completed\n");
    } else {
        printf("Parsing failed\n");
    }
    fclose(yyin);
    return 0;
}
