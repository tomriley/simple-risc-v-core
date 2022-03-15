#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include "utils.h"

// reuses a single buffer so be careful
const char* as_binary_str(uint32_t value, int len) {
    static char bits[33];
    bits[len] = '\0';
    for (int i = 0; i < len; i++) {
        bits[len - 1 - i] = (value & 0x1) ? '1' : '0';
        value = value >> 1;
    }
    return bits;
}
