lex vidhi.l
yacc vidhi.y
gcc -o vidhi y.tab.c symtable.c -ll -ly
