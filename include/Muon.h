#pragma once
#include <stdbool.h>
#include "defs.h"
#include "extlib/vector.h"
typedef enum{
    LITERAL,
    REGISTER,
    ARGUMENT,
    FREGISTER,
    POINTER,
}ArgType;

typedef struct{
    ArgType type;
    size_t operand;
    bool is_negative;
}Arg;
typedef enum{
    ADD,
    SUB,
    MUL,
    DIV,
    ADDF,
    SUBF,
    MULF,
    DIVF
}InstructionType;

typedef struct{
    InstructionType opcode;
    byte mod;
    byte size;
    Arg args[3];
    int arg_len;
}Instruction;

//typedef struct{
//   const char* (*func)(Instruction, SymbolTable*);
//}Converter;

Instruction* parse(byte* bytes, size_t length);

