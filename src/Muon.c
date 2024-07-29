#include <stdio.h>

#include "Muon.h"

const char* HEADER = "MUON";

mint_t take(byte* data, mint_t num){
    uint32_t out = 0;
    for(int i = num; i >= 0; --i){
        out <<= 8;
        out |= (mint_t)data[i];
    }
    return out;
}

Instruction* parse(byte* data, size_t length){
    if(length < sizeof(HEADER) || data == NULL){
        fprintf(stderr, "Bad formating");
        exit(1);
    }
    mint_t cursor = 0;
    for( ;cursor < sizeof(HEADER); cursor++){
        if(data[cursor] != HEADER[cursor]){
            fprintf(stderr, "Incorrect header format.");
            exit(1);
        }
    }
    mint_t data_section = take(data + cursor, 8);
    cursor += 8;
    mint_t code_section = take(data + cursor, 8);
    cursor += 8;
    
     
    


}
