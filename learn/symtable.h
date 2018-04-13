#ifndef SYMTABLE_H
#define SYMTABLE_H

typedef struct symtable symtable;

struct symtable {
    int sym_type;
    char *token_name;
    int int_val;
    float fl_val;
    char *char_val;
    struct symtable *next;
} *table;

symtable* insert(char *name, int type, int ival, float fval, char *cval);
symtable* get(char *toke_name);
symtable* update(char *token_name, int value, float fval, char *cvalue);
symtable* insert_decl(char *type, char *list);
symtable* change_val(symtable* dest, symtable *src);

#endif