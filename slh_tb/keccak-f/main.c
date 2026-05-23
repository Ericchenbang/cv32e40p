#include <stdio.h>
#include "../keccakf.h"

int main() {
    uint64_t s[25] = {0};
    uint64_t start, end;
    asm volatile ("csrw 0x320, zero");
    // start Performance Counter
    printf("baseline:\n");
    asm volatile ("rdcycle %0" : "=r"(start));
    KeccakF1600_StatePermute(s);
    asm volatile ("rdcycle %0" : "=r"(end));
    volatile uint32_t base = (uint32_t)(end - start);
    printf("Cycles: %d\n\n", base);

    uint64_t s2[25] = {0};
    printf("hwacc:\n");
    asm volatile ("rdcycle %0" : "=r"(start));
    rvslh_KeccakF1600_StatePermute(s2);
    asm volatile ("rdcycle %0" : "=r"(end));
    volatile uint32_t hwacc = (uint32_t)(end - start);
    printf("Cycles: %d\n\n", hwacc);

    for (int i=0; i<25; i++) if (s[i]!=s2[i]) {
        printf("s[%d]: get %llu, expect %llu\n", i, s2[i], s[i]);
        return;
    }
    printf("AC\n");

    return 0;
}
