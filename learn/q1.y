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

%token INT FLOAT VOID
%token CONTINUE BREAK
%token INPUT PRINT
%token <ivalue> NUM
%token <string> ID
%token RETURN FOR WHILE
%token EQ LEQ GEQ GT LT NEQ
%left <op> ADD SUB
%token <op> MUL DIV MOD
%token DEF MAIN
%token IF
%token ELSE
%token ELSE_IF
%token AND
%token OR
%token NOT
%token TRUE
%token FALSE

%type <ivalue> arithmectic_expression
%type <op> operator

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

data_type: INT
    | VOID
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
    | PRINT '(' NUM ')'              //printing value of identifier
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

assignment_stmt: ID '=' ID
    | ID '=' NUM {
            if (get($1) == 0)
                insert($1, 0, $3, NULL);
            else
                update($1, $3, NULL);
        }
    ;

decl_stmt: data_type identifiers ;

identifiers: identifiers ',' identifiers
    | ID '=' arithmectic_expression
    | ID '=' ID
    | ID '=' NUM
    | ID
    ;

condition_stmt: IF '(' condition_expr ')' '{' block '}' elif_stmt else_stmt
    ;

elif_stmt: ELSE_IF '(' condition_expr ')' '{' block '}' else_stmt
    |
   ;

else_stmt: ELSE '{' block '}'
    |
    ;

condition_expr: condition_expr AND condition_expr
   | condition_expr OR condition_expr
   | NOT condition_expr
   | TRUE
   | FALSE
   | comparison_statement
   | '(' condition_expr ')'
   ;

comparison_statement: ID conditional_operator ID
    | ID conditional_operator arithmectic_expression
    ;

conditional_operator: EQ
    | LEQ
    | GEQ
    | NEQ
    | LT
    | GT
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
    fprintf(stderr, "Error: %s / %s / %d\n", s, yytext, yylineno);
    return 0;
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
