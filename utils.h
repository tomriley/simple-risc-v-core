#ifndef __UTILS_H__
#define __UTILS_H__

#include <stdint.h>

const char* as_binary_str(uint32_t value, int len);

// static inline unsigned short bswap_16(unsigned short x) {
//     return (x>>8) | (x<<8);
// }

// static inline unsigned int bswap_32(unsigned int x) {
//     return (bswap_16(x&0xffff)<<16) | (bswap_16(x>>16));
// }

// Decoding and sign extending macros
#define BITS(value, start, end) \
    ((uint32_t) ((value >> start) & ((0x1 << (end - start + 1)) - 1)))

static inline int32_t sign_extend(uint32_t value, const int width) {
    if (value & (0x1 << (width - 1))) {
        return value | (INT32_MIN >> (32 - width));
    } else {
        return value;
    }
}

#define RESET   "\033[0m"
#define BLACK   "\033[30m"      /* Black */
#define RED     "\033[31m"      /* Red */
#define GREEN   "\033[32m"      /* Green */
#define YELLOW  "\033[33m"      /* Yellow */
#define BLUE    "\033[34m"      /* Blue */
#define MAGENTA "\033[35m"      /* Magenta */
#define CYAN    "\033[36m"      /* Cyan */
#define WHITE   "\033[37m"      /* White */
#define BOLDBLACK   "\033[1m\033[30m"      /* Bold Black */
#define BOLDRED     "\033[1m\033[31m"      /* Bold Red */
#define BOLDGREEN   "\033[1m\033[32m"      /* Bold Green */
#define BOLDYELLOW  "\033[1m\033[33m"      /* Bold Yellow */
#define BOLDBLUE    "\033[1m\033[34m"      /* Bold Blue */
#define BOLDMAGENTA "\033[1m\033[35m"      /* Bold Magenta */
#define BOLDCYAN    "\033[1m\033[36m"      /* Bold Cyan */
#define BOLDWHITE   "\033[1m\033[37m"      /* Bold White */

#endif
