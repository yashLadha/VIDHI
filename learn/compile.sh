lex q1.l
yacc q1.y
gcc -o test y.tab.c symtable.c -ll -ly