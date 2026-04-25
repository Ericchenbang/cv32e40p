# RVSLH macros

# load vector
.macro lv rd, addr
    .insn i 0x03, 0x7, \rd, \addr
.endm

# store vector
.macro sv rs, addr
    .insn s 0x23, 0x7, \rs, \addr
.endm
