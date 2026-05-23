#ifndef KECCAKF_H_
#define KECCAKF_H_
#include <stdint.h>
#include <stddef.h>
#include "keccakf.h"

#define NROUNDS 24
#define ROL(a, offset) (((a) << (offset)) ^ ((a) >> (64 - (offset))))

uint64_t load64(const uint8_t *x);
void store64(uint8_t *x, uint64_t u);
void KeccakF1600_StatePermute(uint64_t *state);
void rvslh_KeccakF1600_StatePermute(uint64_t *state);
#endif
