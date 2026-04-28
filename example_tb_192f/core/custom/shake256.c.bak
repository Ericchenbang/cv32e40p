#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#define NROUNDS 24
#define ROL(a, offset) (((a) << (offset)) ^ ((a) >> (64 - (offset))))

#define SHAKE256_RATE 136   // 1088 bits / 8
void shake256(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen);

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
    uint8_t message[200];
    for (size_t i = 0; i < 200; i = i + 1) message[i] = i;
    uint8_t hash_out[400] = {0};
    //uint8_t ans[400] = {0x4E, 0xE1, 0xCA, 0x03, 0x27, 0x2B, 0x05, 0xD3, 0xBF, 0xB1, 0xE1, 0xC7, 0x9A, 0x96, 0x7F, 0x82, 0x3B, 0x9F, 0xC5, 0xE4, 0xBB, 0x39, 0x87, 0xB1, 0xBA, 0x9E, 0x9C, 0xB5, 0xAF, 0xB0, 0x7A, 0x5E, 0xE3, 0xA0, 0x7F, 0xBD, 0x45, 0x7A, 0x94, 0x36, 0x49, 0x64, 0xA8, 0x41, 0xE7, 0xF4, 0x66, 0xE5, 0xA0, 0x22, 0xE2, 0x1A, 0xB7, 0xF6, 0x73, 0xC1, 0x8B, 0xA9, 0x8C, 0xDB, 0x1D, 0x5A, 0xEC, 0xFA, 0xE6, 0x22, 0x68, 0xB0, 0x68, 0xF1, 0xE4, 0xBF, 0x9E, 0xE9, 0x85, 0x3B, 0xCC, 0xE0, 0x8D, 0xCD, 0x49, 0x1C, 0x62, 0x9A, 0xA2, 0x18, 0xB6, 0x0D, 0x3D, 0x45, 0x3E, 0x83, 0xA5, 0x54, 0xEB, 0x17, 0x6C, 0xFE, 0xF9, 0x72, 0x9E, 0x99, 0xFF, 0x3A, 0x81, 0x27, 0xC4, 0x9E, 0x3C, 0x3C, 0xF1, 0x9A, 0xD2, 0x60, 0x18, 0xED, 0x79, 0x6F, 0xED, 0xCE, 0x98, 0xC5, 0xF8, 0x67, 0xEC, 0x2B, 0xAC, 0xBD, 0xB8, 0x01, 0x2C, 0xC5, 0x2B, 0x76, 0xE6, 0xD2, 0x4A, 0x80, 0xFA, 0x36, 0x92, 0xD0, 0x2A, 0x03, 0x63, 0x4B, 0x34, 0xB2, 0xFB, 0x33, 0x62, 0x32, 0xE4, 0xC0, 0x27, 0xDC, 0xA0, 0xCC, 0x4B, 0xD0, 0x3A, 0x01, 0xF1, 0xCE, 0xC8, 0xC3, 0x5A, 0xD0, 0xE5, 0x16, 0x87, 0xFA, 0xD4, 0xE1, 0x8E, 0xBC, 0x23, 0xA7, 0x58, 0x51, 0xD4, 0x66, 0x97, 0x9D, 0x59, 0xDB, 0x73, 0x91, 0xB6, 0x17, 0x02, 0xA7, 0xFC, 0x85, 0xA1, 0x16, 0x2B, 0xDB, 0xAA, 0xEA, 0xB6, 0x99, 0x49, 0x91, 0x62, 0xF5, 0x51, 0xDA, 0x8B, 0x0C, 0x83, 0x9F, 0x88, 0xFF, 0x96, 0xB8, 0xDD, 0x79, 0x01, 0x56, 0x06, 0x52, 0x6A, 0xB7, 0x8F, 0xD1, 0xC1, 0x01, 0x66, 0x0D, 0xE8, 0x56, 0x53, 0x34, 0x0F, 0x3D, 0x1D, 0xAC, 0x2A, 0x22, 0xBC, 0xF1, 0xA2, 0xBE, 0xF8, 0x8D, 0x74, 0x2D, 0xE9, 0x00, 0x6C, 0x2D, 0x5B, 0x6D, 0x8A, 0xCD, 0x58, 0x6B, 0x6B, 0xEE, 0x76, 0xF8, 0x5C, 0xCC, 0xBF, 0x94, 0xE3, 0x87, 0xC5, 0x3C, 0x23, 0xE7, 0x16, 0xC6, 0x70, 0xC4, 0xDB, 0x23, 0xC6, 0x79, 0x01, 0x35, 0x8A, 0xE6, 0x4F, 0x3F, 0x0C, 0xCE, 0xDF, 0xA0, 0x5B, 0x29, 0xE8, 0x4E, 0x1A, 0x11, 0xA6, 0x35, 0xBF, 0xE7, 0x9E, 0x4B, 0xD6, 0x53, 0xC2, 0x88, 0x84, 0xEC, 0x40, 0x34, 0xED, 0x55, 0x16, 0x94, 0x7D, 0x4D, 0xC5, 0x44, 0x90, 0x32, 0xD6, 0x09, 0x1D, 0xFD, 0x6E, 0x5A, 0x57, 0x3B, 0x32, 0x3F, 0x26, 0x24, 0xFF, 0x12, 0x89, 0x8B, 0xB7, 0xA1, 0x2D, 0x8C, 0xDD, 0x48, 0x9C, 0xD1, 0xF8, 0x96, 0x5B, 0x6C, 0xA2, 0x2D, 0xE7, 0x89, 0xBB, 0x91, 0x29, 0x2D, 0x03, 0x0C, 0x27, 0x7F, 0x27, 0x16, 0xA3, 0x7B, 0x3F, 0x46, 0xF0, 0xF2, 0x73, 0x54, 0xE3, 0xC9, 0x1C, 0x45, 0x6D, 0x08, 0x6F, 0xE0, 0x66, 0x89, 0x6A, 0xD6, 0xC6, 0xEE, 0x2B, 0x71, 0x68, 0x35, 0x74, 0x32, 0xA6, 0x03, 0xB2, 0x14, 0x2F, 0x74, 0xDA, 0xDD, 0x2B, 0x5A};
    
    uint64_t start, end;
    volatile uint64_t result;

    // enable counter
    asm volatile ("csrw mcountinhibit, zero");
    // start Performance Counter
    start = rdcycle64();

    shake256(hash_out, 400, message, 200);

    end = rdcycle64();

    // end - start = Baseline Cycle Count
    result = end - start;
    
    volatile uint8_t dummy = hash_out[0];

    // for (size_t i = 0; i < 400; i = i + 1){
    //     if (ans[i] != hash_out[i]){
    //         printf("Wrong!\n");
    //         return 0;
    //     }
    // }
    // printf("Correct!\n");

    printf("SHAKE256 (32B -> 32B) Cycles: %llu\n", (unsigned long long)result);
    return 0;
}



// Load 8 bytes into uint64_t in little-endian order
static uint64_t load64(const uint8_t x[8]) {
    uint64_t r = 0;
    for (size_t i = 0; i < 8; i = i + 1) {
        r |= (uint64_t)x[i] << 8 * i;
    }
    return r;
}

// Store a 64-bit integer to a byte array in little-endian order
static void store64(uint8_t x[8], uint64_t u) {
    for (size_t i = 0; i < 8; i = i + 1) {
        x[i] = (uint8_t) (u >> 8 * i);
    }
}

static void KeccakF1600_StatePermute(uint64_t *);

static void keccak_absorb(uint64_t *s, uint32_t r, const uint8_t *m,
                          size_t mlen, uint8_t p) {
    size_t i;
    uint8_t t[200];

    /* Zero state */
    for (i = 0; i < 25; i = i + 1) {
        s[i] = 0;
    }

    while (mlen >= r) {
        for (i = 0; i < r / 8; i = i + 1) {
            s[i] ^= load64(m + 8 * i);
        }

        KeccakF1600_StatePermute(s);
        mlen -= r;
        m += r;
    }

    for (i = 0; i < r; i = i + 1) {
        t[i] = 0;
    }
    for (i = 0; i < mlen; i = i + 1) {
        t[i] = m[i];
    }
    t[i] = p;       // Domain seperation byte
    t[r - 1] |= 128;    // Padding ending
    for (i = 0; i < r / 8; i = i + 1) {
        s[i] ^= load64(t + 8 * i);
    }
}

static void keccak_squeezeblocks(uint8_t *h, size_t nblocks,
                                 uint64_t *s, uint32_t r) {
    while (nblocks > 0) {
        KeccakF1600_StatePermute(s);
        for (size_t i = 0; i < (r >> 3); i++) {
            store64(h + 8 * i, s[i]);
        }
        h += r;
        nblocks--;
    }
}


void shake256(uint8_t *out, size_t outlen,
              const uint8_t *in, size_t inlen) {
    size_t nblocks = outlen / SHAKE256_RATE;
    uint8_t t[SHAKE256_RATE];
    uint64_t s[25];

    keccak_absorb(s, SHAKE256_RATE, in, inlen, 0x1F);
    keccak_squeezeblocks(out, nblocks, s, SHAKE256_RATE);

    out = out + nblocks * SHAKE256_RATE;
    outlen = outlen - nblocks * SHAKE256_RATE;

    if (outlen) {
        KeccakF1600_StatePermute(s);
        for (size_t i = 0; i < SHAKE256_RATE / 8; ++i) {
            store64(t + 8 * i, s[i]);
        }
        for (size_t i = 0; i < outlen; ++i) {
            out[i] = t[i];
        }
    }
}



static const uint64_t KeccakF_RoundConstants[NROUNDS] = {
    0x0000000000000001ULL, 0x0000000000008082ULL,
    0x800000000000808aULL, 0x8000000080008000ULL,
    0x000000000000808bULL, 0x0000000080000001ULL,
    0x8000000080008081ULL, 0x8000000000008009ULL,
    0x000000000000008aULL, 0x0000000000000088ULL,
    0x0000000080008009ULL, 0x000000008000000aULL,
    0x000000008000808bULL, 0x800000000000008bULL,
    0x8000000000008089ULL, 0x8000000000008003ULL,
    0x8000000000008002ULL, 0x8000000000000080ULL,
    0x000000000000800aULL, 0x800000008000000aULL,
    0x8000000080008081ULL, 0x8000000000008080ULL,
    0x0000000080000001ULL, 0x8000000080008008ULL
};

static void KeccakF1600_StatePermute(uint64_t *state) {
    int round;

    uint64_t Aba, Abe, Abi, Abo, Abu;
    uint64_t Aga, Age, Agi, Ago, Agu;
    uint64_t Aka, Ake, Aki, Ako, Aku;
    uint64_t Ama, Ame, Ami, Amo, Amu;
    uint64_t Asa, Ase, Asi, Aso, Asu;
    uint64_t BCa, BCe, BCi, BCo, BCu;
    uint64_t Da, De, Di, Do, Du;
    uint64_t Eba, Ebe, Ebi, Ebo, Ebu;
    uint64_t Ega, Ege, Egi, Ego, Egu;
    uint64_t Eka, Eke, Eki, Eko, Eku;
    uint64_t Ema, Eme, Emi, Emo, Emu;
    uint64_t Esa, Ese, Esi, Eso, Esu;

    // copyFromState(A, state)
    Aba = state[0];
    Abe = state[1];
    Abi = state[2];
    Abo = state[3];
    Abu = state[4];
    Aga = state[5];
    Age = state[6];
    Agi = state[7];
    Ago = state[8];
    Agu = state[9];
    Aka = state[10];
    Ake = state[11];
    Aki = state[12];
    Ako = state[13];
    Aku = state[14];
    Ama = state[15];
    Ame = state[16];
    Ami = state[17];
    Amo = state[18];
    Amu = state[19];
    Asa = state[20];
    Ase = state[21];
    Asi = state[22];
    Aso = state[23];
    Asu = state[24];

    for (round = 0; round < NROUNDS; round += 2) {
        //    prepareTheta
        BCa = Aba ^ Aga ^ Aka ^ Ama ^ Asa;
        BCe = Abe ^ Age ^ Ake ^ Ame ^ Ase;
        BCi = Abi ^ Agi ^ Aki ^ Ami ^ Asi;
        BCo = Abo ^ Ago ^ Ako ^ Amo ^ Aso;
        BCu = Abu ^ Agu ^ Aku ^ Amu ^ Asu;

        // thetaRhoPiChiIotaPrepareTheta(round  , A, E)
        Da = BCu ^ ROL(BCe, 1);
        De = BCa ^ ROL(BCi, 1);
        Di = BCe ^ ROL(BCo, 1);
        Do = BCi ^ ROL(BCu, 1);
        Du = BCo ^ ROL(BCa, 1);

        Aba ^= Da;
        BCa = Aba;
        Age ^= De;
        BCe = ROL(Age, 44);
        Aki ^= Di;
        BCi = ROL(Aki, 43);
        Amo ^= Do;
        BCo = ROL(Amo, 21);
        Asu ^= Du;
        BCu = ROL(Asu, 14);
        Eba = BCa ^ ((~BCe) & BCi);
        Eba ^= KeccakF_RoundConstants[round];
        Ebe = BCe ^ ((~BCi) & BCo);
        Ebi = BCi ^ ((~BCo) & BCu);
        Ebo = BCo ^ ((~BCu) & BCa);
        Ebu = BCu ^ ((~BCa) & BCe);

        Abo ^= Do;
        BCa = ROL(Abo, 28);
        Agu ^= Du;
        BCe = ROL(Agu, 20);
        Aka ^= Da;
        BCi = ROL(Aka, 3);
        Ame ^= De;
        BCo = ROL(Ame, 45);
        Asi ^= Di;
        BCu = ROL(Asi, 61);
        Ega = BCa ^ ((~BCe) & BCi);
        Ege = BCe ^ ((~BCi) & BCo);
        Egi = BCi ^ ((~BCo) & BCu);
        Ego = BCo ^ ((~BCu) & BCa);
        Egu = BCu ^ ((~BCa) & BCe);

        Abe ^= De;
        BCa = ROL(Abe, 1);
        Agi ^= Di;
        BCe = ROL(Agi, 6);
        Ako ^= Do;
        BCi = ROL(Ako, 25);
        Amu ^= Du;
        BCo = ROL(Amu, 8);
        Asa ^= Da;
        BCu = ROL(Asa, 18);
        Eka = BCa ^ ((~BCe) & BCi);
        Eke = BCe ^ ((~BCi) & BCo);
        Eki = BCi ^ ((~BCo) & BCu);
        Eko = BCo ^ ((~BCu) & BCa);
        Eku = BCu ^ ((~BCa) & BCe);

        Abu ^= Du;
        BCa = ROL(Abu, 27);
        Aga ^= Da;
        BCe = ROL(Aga, 36);
        Ake ^= De;
        BCi = ROL(Ake, 10);
        Ami ^= Di;
        BCo = ROL(Ami, 15);
        Aso ^= Do;
        BCu = ROL(Aso, 56);
        Ema = BCa ^ ((~BCe) & BCi);
        Eme = BCe ^ ((~BCi) & BCo);
        Emi = BCi ^ ((~BCo) & BCu);
        Emo = BCo ^ ((~BCu) & BCa);
        Emu = BCu ^ ((~BCa) & BCe);

        Abi ^= Di;
        BCa = ROL(Abi, 62);
        Ago ^= Do;
        BCe = ROL(Ago, 55);
        Aku ^= Du;
        BCi = ROL(Aku, 39);
        Ama ^= Da;
        BCo = ROL(Ama, 41);
        Ase ^= De;
        BCu = ROL(Ase, 2);
        Esa = BCa ^ ((~BCe) & BCi);
        Ese = BCe ^ ((~BCi) & BCo);
        Esi = BCi ^ ((~BCo) & BCu);
        Eso = BCo ^ ((~BCu) & BCa);
        Esu = BCu ^ ((~BCa) & BCe);

        //    prepareTheta
        BCa = Eba ^ Ega ^ Eka ^ Ema ^ Esa;
        BCe = Ebe ^ Ege ^ Eke ^ Eme ^ Ese;
        BCi = Ebi ^ Egi ^ Eki ^ Emi ^ Esi;
        BCo = Ebo ^ Ego ^ Eko ^ Emo ^ Eso;
        BCu = Ebu ^ Egu ^ Eku ^ Emu ^ Esu;

        // thetaRhoPiChiIotaPrepareTheta(round+1, E, A)
        Da = BCu ^ ROL(BCe, 1);
        De = BCa ^ ROL(BCi, 1);
        Di = BCe ^ ROL(BCo, 1);
        Do = BCi ^ ROL(BCu, 1);
        Du = BCo ^ ROL(BCa, 1);

        Eba ^= Da;
        BCa = Eba;
        Ege ^= De;
        BCe = ROL(Ege, 44);
        Eki ^= Di;
        BCi = ROL(Eki, 43);
        Emo ^= Do;
        BCo = ROL(Emo, 21);
        Esu ^= Du;
        BCu = ROL(Esu, 14);
        Aba = BCa ^ ((~BCe) & BCi);
        Aba ^= KeccakF_RoundConstants[round + 1];
        Abe = BCe ^ ((~BCi) & BCo);
        Abi = BCi ^ ((~BCo) & BCu);
        Abo = BCo ^ ((~BCu) & BCa);
        Abu = BCu ^ ((~BCa) & BCe);

        Ebo ^= Do;
        BCa = ROL(Ebo, 28);
        Egu ^= Du;
        BCe = ROL(Egu, 20);
        Eka ^= Da;
        BCi = ROL(Eka, 3);
        Eme ^= De;
        BCo = ROL(Eme, 45);
        Esi ^= Di;
        BCu = ROL(Esi, 61);
        Aga = BCa ^ ((~BCe) & BCi);
        Age = BCe ^ ((~BCi) & BCo);
        Agi = BCi ^ ((~BCo) & BCu);
        Ago = BCo ^ ((~BCu) & BCa);
        Agu = BCu ^ ((~BCa) & BCe);

        Ebe ^= De;
        BCa = ROL(Ebe, 1);
        Egi ^= Di;
        BCe = ROL(Egi, 6);
        Eko ^= Do;
        BCi = ROL(Eko, 25);
        Emu ^= Du;
        BCo = ROL(Emu, 8);
        Esa ^= Da;
        BCu = ROL(Esa, 18);
        Aka = BCa ^ ((~BCe) & BCi);
        Ake = BCe ^ ((~BCi) & BCo);
        Aki = BCi ^ ((~BCo) & BCu);
        Ako = BCo ^ ((~BCu) & BCa);
        Aku = BCu ^ ((~BCa) & BCe);

        Ebu ^= Du;
        BCa = ROL(Ebu, 27);
        Ega ^= Da;
        BCe = ROL(Ega, 36);
        Eke ^= De;
        BCi = ROL(Eke, 10);
        Emi ^= Di;
        BCo = ROL(Emi, 15);
        Eso ^= Do;
        BCu = ROL(Eso, 56);
        Ama = BCa ^ ((~BCe) & BCi);
        Ame = BCe ^ ((~BCi) & BCo);
        Ami = BCi ^ ((~BCo) & BCu);
        Amo = BCo ^ ((~BCu) & BCa);
        Amu = BCu ^ ((~BCa) & BCe);

        Ebi ^= Di;
        BCa = ROL(Ebi, 62);
        Ego ^= Do;
        BCe = ROL(Ego, 55);
        Eku ^= Du;
        BCi = ROL(Eku, 39);
        Ema ^= Da;
        BCo = ROL(Ema, 41);
        Ese ^= De;
        BCu = ROL(Ese, 2);
        Asa = BCa ^ ((~BCe) & BCi);
        Ase = BCe ^ ((~BCi) & BCo);
        Asi = BCi ^ ((~BCo) & BCu);
        Aso = BCo ^ ((~BCu) & BCa);
        Asu = BCu ^ ((~BCa) & BCe);
    }

    // copyToState(state, A)
    state[0] = Aba;
    state[1] = Abe;
    state[2] = Abi;
    state[3] = Abo;
    state[4] = Abu;
    state[5] = Aga;
    state[6] = Age;
    state[7] = Agi;
    state[8] = Ago;
    state[9] = Agu;
    state[10] = Aka;
    state[11] = Ake;
    state[12] = Aki;
    state[13] = Ako;
    state[14] = Aku;
    state[15] = Ama;
    state[16] = Ame;
    state[17] = Ami;
    state[18] = Amo;
    state[19] = Amu;
    state[20] = Asa;
    state[21] = Ase;
    state[22] = Asi;
    state[23] = Aso;
    state[24] = Asu;
}
