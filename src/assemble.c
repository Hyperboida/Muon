#include "assemble.h"
#include "defs.h"
#include <stdio.h>
#include "extlib/string.h"
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include "instr.h"
#include <ctype.h>
#include "extlib/map.h"
#include "extlib/vector.h"
typedef struct{
    const char* str;
    size_t cursor;
    ext_map* sym;
}Scanner;



bool has_next(Scanner* scanner){
    return scanner->str[scanner->cursor+1] != '\0';
}
char consume(Scanner* scanner){
    if(!has_next(scanner)){
        fprintf(stderr, "Error: Unexpected EOF while parsing.");
        exit(1);
    }
    return scanner->str[scanner->cursor++];
}
byte peek(Scanner* scanner){
    return scanner->str[scanner->cursor + 1];
}

byte get_op(ext_string op){
    if(ext_str_compare("mov", op)){
        return MOV;
    }
    return 0;
}


void expr(Scanner* scanner, ext_vector(byte) bin){
    if(isalpha(peek(scanner))){
        ext_string id = "";
        byte curr = 0;
        while(isalnum((curr = consume(scanner)))){
            ext_str_append_fmt(&id, "%c", tolower(curr));
        }
        if(peek(scanner) == ':'){
            consume(scanner);
            ext_map_put(scanner->sym, id);
            ext_str_free(id);
            return;
        }
        get_op(id);
    } 
}

byte* assemble(const char* str, size_t length){
    Scanner* scanner = malloc(sizeof(Scanner));
    scanner->str = str;
    scanner->cursor = 0;
    scanner->sym = ext_map_new(0, hash, compare);
    ext_vector(byte) out = NULL;
    while(has_next(scanner)){
       expr(scanner, out);
    }
    return out;


}
