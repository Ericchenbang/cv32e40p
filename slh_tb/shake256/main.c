#include <stdio.h>
#include "../fips202.h"
#include "../rvslh_shake256.h"

#define SPX_N 16
#define SPX_ADDR_BYTES 32

int main() {
    unsigned char buf[2*SPX_N + SPX_ADDR_BYTES] = {0};
    unsigned char out1[2*SPX_N] = {0};
    unsigned char*out2=&out1[SPX_N];
    uint64_t start, end;
    asm volatile ("csrw 0x320, zero");

    asm volatile ("rdcycle %0" : "=r"(start));
    shake256(out1, SPX_N, buf, 2*SPX_N + SPX_ADDR_BYTES);
    asm volatile ("rdcycle %0" : "=r"(end));
    uint32_t base = (uint32_t)(end - start);
    printf("Baseline cycles: %d\n", base);
    
    asm volatile ("rdcycle %0" : "=r"(start));
    rvslh_shake256(out2, SPX_N, buf, 2*SPX_N + SPX_ADDR_BYTES);
    asm volatile ("rdcycle %0" : "=r"(end));
    uint32_t hwacc = (uint32_t)(end - start);
    printf("Hwaccel cycles: %d\n", hwacc);

    for (int i=0; i<SPX_N; i++) if (out1[i]!=out2[i]) {
        printf("get   : ");
        for (int j=0; j<SPX_N; j++) printf("%x", out2[j]);
        printf("\n");
        printf("expect: ");
        for (int j=0; j<SPX_N; j++) printf("%x", out1[j]);
        printf("\n");
        return;
    }
    printf("AC\n");

    return 0;
}
