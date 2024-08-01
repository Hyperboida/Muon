#pragma once
#include "extlib/map.h"
#include "defs.h"
typedef enum {
    ADD = 0x0001,
    SUB,
    MUL,
    DIV,
    ADDF,
    SUBF,
    MULF,
    DIVF,
    ADDI,
    MULI,
    DIVI,
    INC,
    DEC,
    POW,
    CMP,
    JMP,
    JEQ,
    JNQ,
    JG,
    JL,
    JGE,
    JLE,
    AND,
    OR,
    XOR,
    NOT,
    LSH,
    RSH,
    MOV,
    MOVF,
    CALL,
    PUSH,
    POP,
    LEA,
}Instr;


byte get_op(ext_string op){
    static ext_map* instr_map = ext_map_new(0, hash, compare);

}

