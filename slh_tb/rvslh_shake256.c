#include "rvslh_shake256.h"

static void rvslh_keccak_absorb(const uint8_t *m,
                          size_t mlen, uint8_t p) {
    size_t i;
    uint8_t t[160]={0};

    asm volatile (
        ".insn r4 0x1b, 0  , 0  , x0 , x16, x16, x16\n\t"
        ".insn r4 0x1b, 0  , 0  , x1 , x16, x16, x16\n\t"
        ".insn r4 0x1b, 0  , 0  , x2 , x16, x16, x16\n\t"
        ".insn r4 0x1b, 0  , 0  , x3 , x16, x16, x16\n\t"
        ".insn r4 0x1b, 0  , 0  , x4 , x16, x16, x16\n\t"
        :
        :
        :
    );

    while (mlen >= SHAKE256_RATE) {
        for (i = 120; i < SHAKE256_RATE; ++i) {
            t[i] = m[i];
        }
        asm volatile (
            ".insn i  0x03, 0x7, x15, 0(%0)\n\t"
            ".insn r4 0x1b, 0  , 0  , x0 , x0, x15, x16\n\t"
            ".insn i  0x03, 0x7, x15, 40(%0)\n\t"
            ".insn r4 0x1b, 0  , 0  , x1 , x1, x15, x16\n\t"
            ".insn i  0x03, 0x7, x15, 80(%0)\n\t"
            ".insn r4 0x1b, 0  , 0  , x2 , x2, x15, x16\n\t"
            ".insn i  0x03, 0x7, x15, 120(%1)\n\t"
            ".insn r4 0x1b, 0  , 0  , x3 , x3, x15, x16\n\t"
            :
            : "r"(m), "r"(t)
            : "memory"
        );

        for (int round = 0; round < NROUNDS; round++) {
            asm volatile (
                ".insn r4 0x1b, 0  , 0  , x5 , x0, x1, x2\n\t"
                ".insn r4 0x1b, 0  , 0  , x5 , x5, x3, x4\n\t"
                ".insn i  0x1b, 0x1,      x5 , x5, 0     \n\t"
                ".insn r4 0x1b, 0  , 0x1, x6 , x0, x5, x0\n\t"
                ".insn r4 0x1b, 0  , 0x1, x7 , x1, x5, x1\n\t"
                ".insn r4 0x1b, 0  , 0x1, x8 , x2, x5, x2\n\t"
                ".insn r4 0x1b, 0  , 0x1, x9 , x3, x5, x3\n\t"
                ".insn r4 0x1b, 0  , 0x1, x10, x4, x5, x4\n\t"
                
                ".insn r4 0x1b, 0  , 0  , x0 , x16, x16, x16\n\t"
                ".insn i  0x03, 0x7,      x16, 0(%0)\n\t"
                "nop\n\t"
                ".insn r4 0x1b, 0  , 0x2, x11, x7, x8, x6\n\t"
                ".insn r4 0x1b, 0  , 0  , x16, x11, x0, x16\n\t"
                ".insn r4 0x1b, 0  , 0x2, x17, x8, x9, x7\n\t"
                ".insn r4 0x1b, 0  , 0x2, x18, x9, x10, x8\n\t"
                ".insn r4 0x1b, 0  , 0x2, x19, x10, x6, x9\n\t"
                ".insn r4 0x1b, 0  , 0x2, x20, x6, x7, x10\n\t"
                :
                : "r"(&KeccakF_RoundConstants[round])
                : "memory"
            );
        }
        mlen -= SHAKE256_RATE;
        m += SHAKE256_RATE;
    }
    
    for (i = 0; i < mlen; ++i) {
        t[i] = m[i];
    }
    t[i] = p;
    for (++i; i < 160; ++i) {
        t[i] = 0;
    }
    t[SHAKE256_RATE - 1] |= 128;
    asm volatile (
        ".insn i  0x03, 0x7, x15, 0(%0)\n\t"
        ".insn r4 0x1b, 0  , 0  , x0 , x0, x15, x16\n\t"
        ".insn i  0x03, 0x7, x15, 40(%0)\n\t"
        ".insn r4 0x1b, 0  , 0  , x1 , x1, x15, x16\n\t"
        ".insn i  0x03, 0x7, x15, 80(%0)\n\t"
        ".insn r4 0x1b, 0  , 0  , x2 , x2, x15, x16\n\t"
        ".insn i  0x03, 0x7, x15, 120(%0)\n\t"
        ".insn r4 0x1b, 0  , 0  , x3 , x3, x15, x16\n\t"
        :
        : "r"(t)
        : "memory"
    );
}

static void rvslh_keccak_squeezeblocks(uint8_t *h, size_t nblocks) {
    while (nblocks > 0) {
        for (int round = 0; round < NROUNDS; round++) {
            asm volatile (
                ".insn r4 0x1b, 0  , 0  , x5 , x0, x1, x2\n\t"
                ".insn r4 0x1b, 0  , 0  , x5 , x5, x3, x4\n\t"
                ".insn i  0x1b, 0x1,      x5 , x5, 0     \n\t"
                ".insn r4 0x1b, 0  , 0x1, x6 , x0, x5, x0\n\t"
                ".insn r4 0x1b, 0  , 0x1, x7 , x1, x5, x1\n\t"
                ".insn r4 0x1b, 0  , 0x1, x8 , x2, x5, x2\n\t"
                ".insn r4 0x1b, 0  , 0x1, x9 , x3, x5, x3\n\t"
                ".insn r4 0x1b, 0  , 0x1, x10, x4, x5, x4\n\t"
                
                ".insn r4 0x1b, 0  , 0  , x0 , x16, x16, x16\n\t"
                ".insn i  0x03, 0x7,      x16, 0(%0)\n\t"
                "nop\n\t"
                ".insn r4 0x1b, 0  , 0x2, x11, x7, x8, x6\n\t"
                ".insn r4 0x1b, 0  , 0  , x16, x11, x0, x16\n\t"
                ".insn r4 0x1b, 0  , 0x2, x17, x8, x9, x7\n\t"
                ".insn r4 0x1b, 0  , 0x2, x18, x9, x10, x8\n\t"
                ".insn r4 0x1b, 0  , 0x2, x19, x10, x6, x9\n\t"
                ".insn r4 0x1b, 0  , 0x2, x20, x6, x7, x10\n\t"
                :
                : "r"(&KeccakF_RoundConstants[round])
                : "memory"
            );
        }
        asm volatile (
            ".insn s 0x23, 0x7, x3, 0(%0)\n\t"
            :
            : "r"(h)
            : "memory"
        );
        for(int i=0; i<24; ++i) h[120+i]=h[i];
        asm volatile (
            ".insn s 0x23, 0x7, x0, 0(%0)\n\t"
            ".insn s 0x23, 0x7, x1, 40(%0)\n\t"
            ".insn s 0x23, 0x7, x2, 80(%0)\n\t"
            :
            : "r"(h)
            : "memory"
        );
        h += SHAKE256_RATE;
        nblocks--;
    }
}

void rvslh_shake256(uint8_t *output, size_t outlen,
                    const uint8_t *input, size_t inlen) {
    size_t nblocks = outlen / SHAKE256_RATE;
    uint8_t t[SHAKE256_RATE];
    uint64_t s[25];

    rvslh_keccak_absorb(input, inlen, 0x1F);
    rvslh_keccak_squeezeblocks(output, nblocks);

    output += nblocks * SHAKE256_RATE;
    outlen -= nblocks * SHAKE256_RATE;

    if (outlen>0) {
        rvslh_keccak_squeezeblocks(t, 1);
        for (size_t i = 0; i < outlen; ++i) {
            output[i] = t[i];
        }
    }
}
