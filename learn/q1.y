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
%token IF
%token ELSE
%token ELSE_IF
%token AND
%token OR
%token NOT
%token TRUE
%token FALSE

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
    | condition_stmt
    ;

output_stmt: PRINT'(' ID ')'
    | PRINT '(' NUM ')'              //printing value of identifier
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

condition_stmt: IF '(' condition_expr ')' '{' block '}' elif_stmt else_stmt
       ;

elif_stmt: ELSE_IF '(' condition_expr ')' '{' block '}' else_stmt
    |
   ;

else_stmt: ELSE '{' block '}'
     |
     ;

condition_expr: condition_expr AND condition_expr      //brackets necessary
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