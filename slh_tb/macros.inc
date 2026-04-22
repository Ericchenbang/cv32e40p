# RVSLH macros

# load vector
.macro lv rd, addr
    .insn i 0x03, 0x7, \rd, \addr
.endm
