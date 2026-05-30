#include <stdio.h>
#include "../rvslh_shake256.h"

#define MLEN 256
#define OUTLEN 16

int main() {
    uint32_t s = 0x32e40;
    uint8_t buf[MLEN];
    for(int i=0; i<MLEN; ++i) {
        buf[i] = (uint8_t)s;
        s ^= s<<13;
        s ^= s>>17;
        s ^= s<<5;
    }

    uint8_t out1[2*OUTLEN] = {0};
    uint8_t *out2=&out1[OUTLEN];
    uint64_t start, end;
    asm volatile ("csrw 0x320, zero");

    printf("Start\n");
    asm volatile ("rdcycle %0" : "=r"(start));
    shake256(out1, OUTLEN, buf, MLEN);
    asm volatile ("rdcycle %0" : "=r"(end));
    uint32_t base = (uint32_t)(end - start);
    printf("Baseline cycles: %d\n", base);
    
    asm volatile ("rdcycle %0" : "=r"(start));
    rvslh_shake256(out2, OUTLEN, buf, MLEN);
    asm volatile ("rdcycle %0" : "=r"(end));
    uint32_t hwacc = (uint32_t)(end - start);
    printf("Hwaccel cycles: %d\n", hwacc);

    for (int i=0; i<OUTLEN; i++) if (out1[i]!=out2[i]) {
        printf("get   : ");
        for (int j=0; j<OUTLEN; j++) printf("%02x ", out2[j]);
        printf("\n");
        printf("expect: ");
        for (int j=0; j<OUTLEN; j++) printf("%02x ", out1[j]);
        printf("\n");
        return;
    }
    printf("AC\n");

    return 0;
}
