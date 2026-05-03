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

# xor rs1, rs2 than rotate and rearrange according the table and store to rd
.macro rxorv rd, rs1, rs2, imm
    .insn r4 0x1b, 0, 0x1, \rd, \rs1, \rs2, \imm
.endm

# rd = rs1 xor ((not rs2) and rs3)
.macro xornav rd, rs1, rs2, rs3
    .insn r4 0x1b, 0, 0x2, \rd, \rs1, \rs2, \rs3
.endm

# right rotate once for each 64bits elements in slh regsterfile and store to rd
.macro xorrv rd, rs
    .insn i 0x1b, 0x1, \rd, \rs, 0
.endm
