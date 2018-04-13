#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtable.h"

#define MAX 200
#define INT_TYPE 0
#define CHAR_TYPE 1
#define FLOAT_TYPE 2

/**
 * Inserts the token into the symbol table.
 * param:
 *      name: Name of the token
 *      type: Type of the token
 *      ival: Integer value of the token (If available)
 *      fval: Floating point value of the token (If available)
 *      cval: String value of the token (If available)
 * returns:
 *      Pointer pointing to the inserted node
*/
symtable* insert(char *name, int type, int ival, float fval, char *cval) {
    symtable *node = (symtable *)malloc(sizeof(symtable));
    node->token_name = (char *)malloc(strlen(name) + 1);
    strcpy(node->token_name, name);
    node->sym_type = type;
    if (type == INT_TYPE) {
        node->int_val = ival;
    } else if (type == CHAR_TYPE) {
        node->char_val = (char *)malloc(strlen(cval) + 1);
        strcpy(node->char_val, cval);
    } else if (type == FLOAT_TYPE) {
        node->fl_val = fval;
    }
    node->next = (symtable *)table;
    table = node;
    return node;
}

/**
 * Fetches the node with the passed token name
 * param:
 *      token_name: string having the token name
 * returns:
 *      If node founded them the pointer to the finded node.
 *      If node not founded them returning 0.
*/
symtable* get(char *token_name) {
    symtable *ptr;
    for (ptr = table; ptr != (symtable *)0; ptr = (symtable *)ptr->next) {
        if (strcmp(ptr->token_name, token_name) == 0)
            return ptr;
    }
    return 0;
}

/**
 * Appending char to the char ptr
 * param:
 *      s : Character pointer (string)
 *      c : character to append to string.
 * returns:
 *      string having character appended
*/
char *append(const char *s, char c) {
    int len = strlen(s);
    char buf[len+2];
    strcpy(buf, s);
    buf[len] = c;
    buf[len + 1] = 0;
    return strdup(buf);
}

/**
 * Module to assign value of one node to another node
 * param:
 *      dest : Destination node to receive value
 *      src : Source node to receive value
 * return:
 *      Updated destination node
*/
symtable* change_val(symtable *dest, symtable *src) {
    if (dest->sym_type == INT_TYPE) {
        dest->int_val = src->int_val;
    } else if (dest->sym_type == CHAR_TYPE) {
        dest->char_val = src->char_val;
    } else if (dest->sym_type == FLOAT_TYPE) {
        dest->fl_val = src->fl_val;
    }
    return dest;
}

/**
 * Initializes nodes from the declaration list
 * param:
 *      type: type of the declarations
 *      list: string containing characters which needs to be initalised
*/
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
                if (get(temp_str) == 0)
                    insert(temp_str, INT_TYPE, 0, 0.0, "");
                else
                    return 0;
                strcpy(temp_str, "");
            }
        }
        if (strlen(temp_str) > 0) {
            insert(temp_str, INT_TYPE, 0, 0.0, "");
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
                insert(temp_str, CHAR_TYPE, 0, 0.0, "");
                strcpy(temp_str, "");
            }
        }
        if (strlen(temp_str) > 0) {
            insert(temp_str, CHAR_TYPE, 0, 0.0, "");
        }
    } else if (strcmp(type, "float") == 0) {
        int len = strlen(list);
        int idx = 0;
        char *temp_str = "";
        for (idx = 0; idx < len; ++idx) {
            if (list[idx] >= 'a' && list[idx] <= 'z') {
                temp_str = append(temp_str, list[idx]);
            } else if (list[idx] >= 'A' && list[idx] <= 'Z') {
                temp_str = append(temp_str, list[idx]);
            } else if (list[idx] == ',') {
                insert(temp_str, FLOAT_TYPE, 0, 0.0, "");
                strcpy(temp_str, "");
            }
        }
        if (strlen(temp_str) > 0) {
            insert(temp_str, FLOAT_TYPE, 0, 0.0, "");
        }
    }
}

/**
 * Updates the given node value to passed type value
 * param:
 *      token_name: name of the token
 *      value : integer value (If passed)
 *      f_val: floating value (If passed)
 *      cvalue: string value (If passed)
 * return:
 *      Updated node with the passed token_name
*/
symtable* update(char *token_name, int value, float f_val, char *cvalue) {
    symtable *node = (symtable *)get(token_name);
    if (node != (symtable *)0) {
        if (node->sym_type == INT_TYPE) {
            node->int_val = value;
        } else if (node->sym_type == CHAR_TYPE) {
            node->char_val = (char *)malloc(strlen(cvalue) + 1);
            strcpy(node->char_val, cvalue);
        } else if (node->sym_type == FLOAT_TYPE) {
            node->fl_val = f_val;
        }
        return node;
    }
    return 0;
}
