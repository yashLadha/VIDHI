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

char *append(const char *s, char c) {
    int len = strlen(s);
    char buf[len+2];
    strcpy(buf, s);
    buf[len] = c;
    buf[len + 1] = 0;
    return strdup(buf);
}

symtable* change_val(symtable *dest, symtable *src) {
    if (dest->sym_type == INT_TYPE) {
        dest->int_val = src->int_val;
    } else if (dest->sym_type == CHAR_TYPE) {
        dest->char_val = src->char_val;
    }
}

symtable* insert_decl(char *type, char *list) {
    if (strcmp(type, "int") == 0) {
        int len = strlen(list);
        int idx = 0;
        char *temp_str = "";
        for (idx = 0; idx < len; ++idx) {
            if (list[idx] >= 'a' && list[idx] <= 'z') {
                temp_str = append(temp_str, list[idx]);
            } else if (list[idx] >= 'A' && list[idx] <= 'Z') {
                temp_str = append(temp_str, list[idx]);
            } else if (list[idx] == ',') {
                insert(temp_str, INT_TYPE, 0, "");
                strcpy(temp_str, "");
            }
        }
        if (strlen(temp_str) > 0) {
            insert(temp_str, INT_TYPE, 0, "");
        }
    } else if (strcmp(type, "char") == 0) {
        int len = strlen(list);
        int idx = 0;
        char *temp_str = "";
        for (idx = 0; idx < len; ++idx) {
            if (list[idx] >= 'a' && list[idx] <= 'z') {
                temp_str = append(temp_str, list[idx]);
            } else if (list[idx] >= 'A' && list[idx] <= 'Z') {
                temp_str = append(temp_str, list[idx]);
            } else if (list[idx] == ',') {
                insert(temp_str, CHAR_TYPE, 0, "");
                strcpy(temp_str, "");
            }
        }
        if (strlen(temp_str) > 0) {
            insert(temp_str, CHAR_TYPE, 0, "");
        }
    }
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
