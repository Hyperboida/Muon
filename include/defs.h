#pragma once
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "extlib/map.h"
typedef unsigned char byte;
typedef uint64_t mint_t;
static bool compare(const void* entry1, const void* entry2) {
    const char *e1 = entry1, *e2 = entry2;
    return strcmp(e1, e2) == 0;
}
static uint32_t hash(const void* entry) {
    const char* e = entry;
    return ext_map_hash_bytes(e, strlen(e));
}


