# RVSLH macros

# load vector
.macro lv rd, addr
    .insn i 0x03, 0x7, \rd, \addr
.endm

# store vector
.macro sv rs, addr
    .insn s 0x23, 0x7, \rs, \addr
.endm

# xor 3 slh regsterfile and store to rd
.macro xor3v rd, rs1, rs2, rs3
    .insn r4 0x1b, 0, 0, \rd, \rs1, \rs2, \rs3
.endm
