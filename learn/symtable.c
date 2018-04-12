#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtable.h"

#define MAX 200
#define INT_TYPE 0
#define CHAR_TYPE 1

symtable* insert(char *name, int type, int ival, char *cval) {
    symtable *node = (symtable *)malloc(sizeof(symtable));
    node->token_name = (char *)malloc(strlen(name) + 1);
    strcpy(node->token_name, name);
    node->sym_type = type;
    if (type == INT_TYPE) {
        node->int_val = ival;
    } else if (type == CHAR_TYPE) {
        node->char_val = (char *)malloc(strlen(cval) + 1);
        strcpy(node->char_val, cval);
    }
    node->next = (symtable *)table;
    table = node;
    return node;
}

symtable* get(char *token_name) {
    symtable *ptr;
    for (ptr = table; ptr != (symtable *)0; ptr = (symtable *)ptr->next) {
        if (strcmp(ptr->token_name, token_name) == 0)
            return ptr;
    }
    return 0;
}

symtable* update(char *token_name, int value, char *cvalue) {
    symtable *node = (symtable *)get(token_name);
    if (node != (symtable *)0) {
        if (node->sym_type == INT_TYPE) {
            node->int_val = value;
        } else if (node->sym_type == CHAR_TYPE) {
            node->char_val = (char *)malloc(strlen(cvalue) + 1);
            strcpy(node->char_val, cvalue);
        }
        return node;
    }
    return 0;
}
