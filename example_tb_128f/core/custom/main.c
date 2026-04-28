#include <stdint.h>
#include <stdio.h>
#include "api.h"

// provide simple random number generator for SLH-DSA
void randombytes(uint8_t *out, size_t outlen) {
    for (size_t i = 0; i < outlen; i++) {
        out[i] = (uint8_t)(i ^ 0xAA); // simulate random number
    }
}

static inline uint64_t rdcycle64() {
    uint32_t hi, lo, hi2;
    do {
        asm volatile ("rdcycleh %0" : "=r"(hi));
        asm volatile ("rdcycle %0"  : "=r"(lo));
        asm volatile ("rdcycleh %0" : "=r"(hi2));
    } while (hi != hi2);
    return ((uint64_t)hi << 32) | lo;
}

int main() {
    uint8_t pk[CRYPTO_PUBLICKEYBYTES];
    uint8_t sk[CRYPTO_SECRETKEYBYTES];
    uint8_t msg[16] = "Hello SLH-DSA!";
    uint8_t sig[CRYPTO_BYTES];
    size_t siglen;
    uint64_t t0, t1, t2, t3;
    printf("=== Parameter Check ===\n");
    printf("PK Size: %d bytes\n", CRYPTO_PUBLICKEYBYTES);
    printf("SK Size: %d bytes\n", CRYPTO_SECRETKEYBYTES);
    printf("Signature Size: %d bytes\n", CRYPTO_BYTES);
    printf("=======================\n");
    

    asm volatile ("csrw mcountinhibit, zero");

    printf("Starting Keypair Generation...\n");
    t0 = rdcycle64();
    crypto_sign_keypair(pk, sk);
    t1 = rdcycle64();
    
    printf("Starting Signature Generation...\n");
    crypto_sign_signature(sig, &siglen, msg, 16, sk);
    t2 = rdcycle64();
    
    printf("Verifying Signature...\n");
    crypto_sign_verify(sig, siglen, msg, 16, pk);
    t3 = rdcycle64();

    volatile uint32_t keypair_cycles = (uint32_t)(t1 - t0);
    volatile uint32_t sign_cycles = (uint32_t)(t2 - t1);
    volatile uint32_t verify_cycles = (uint32_t)(t3 - t2);

    printf("Keypair Cycles: %u\n", keypair_cycles);
    printf("Sign Cycles: %u\n", sign_cycles);
    printf("Verify Cycles: %u\n", verify_cycles);

    return 0;
}