#ifndef RVSLH_SHAKE256_H_
#define RVSLH_SHAKE256_H_
#include "fips202.h"

void rvslh_shake256(uint8_t *output, size_t outlen,
                    const uint8_t *input, size_t inlen);
#endif