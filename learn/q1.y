%{
    #include <stdio.h>
    #include <stdlib.h>

    extern FILE *fp;
%}

%token INT FLOAT VOID
%token CONTINUE BREAK
%token ID NUM INPUT PRINT
%token RETURN FOR WHILE
%token EQ LEQ GEQ GT LT NEQ
%left ADD SUB
%token MUL DIV MOD
%token DEF MAIN

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
    | FLOAT
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

expr_stmt: function_param
    | return_stmt
    | input_stmt
    | loop_stmt
    | decl_stmt
    | function_call_stmt
    | assignment_stmt
    | skip_stmt
    | break_stmt
    | arithmetic_stmt
    | output_stmt
    ;

output_stmt: PRINT'(' ID ')'
    | PRINT '(' NUM ')'
    ;

arithmetic_stmt: ID '=' arithmectic_expression
    ;

break_stmt: BREAK
    ;

skip_stmt: CONTINUE
    ;

assignment_stmt: ID '=' ID
    | ID '=' NUM
    ;

decl_stmt: data_type ID temp_assignment
    | data_type ID temp_assignment',' identifiers
    ;

identifiers: ID temp_assignment ',' identifiers
    | ID temp_assignment
    ;

temp_assignment: '=' arithmectic_expression
    | '=' ID
    | '=' NUM
    |
    ;

arithmectic_expression: arithmectic_expression operator arithmectic_expression
    | ID
    | '('arithmectic_expression')'
    ;

operator: ADD
    | MUL
    | SUB
    | DIV
    | MOD
    ;

function_call_stmt: ID '(' param ')'
    ;

input_stmt: INPUT'('ID')'
    ;

loop_stmt: FOR '('initialize_loop';' loop_invariant ';' loop_increment ')' '{' block '}'
    ;

initialize_loop:
    ;

loop_invariant:
    ;

loop_increment:
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