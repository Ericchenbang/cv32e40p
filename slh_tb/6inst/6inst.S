.section .text.start
.global _start
.type _start, @function

.include "../macros.inc"

_start:
    addi    t0, zero, 0x10
    lui     s0, 0x200
    lui     s1, 0x200
    sw      t0, 0(s0) 
    addi    s0, s0, 0x4
    addi    t0, t0, 0x4
    sw      t0, 0(s0) 
    addi    s0, s0, 0x4
    addi    t0, t0, 0x4
    sw      t0, 0(s0) 
    addi    s0, s0, 0x4
    addi    t0, t0, 0x4
    sw      t0, 0(s0) 
    addi    s0, s0, 0x4
    addi    t0, t0, 0x4
    sw      t0, 0(s0)
    addi    s0, s0, 0x4
    addi    t0, t0, 0x4
    sw      t0, 0(s0) 
    addi    s0, s0, 0x4
    addi    t0, t0, 0x4
    sw      t0, 0(s0) 
    addi    s0, s0, 0x4
    addi    t0, t0, 0x4
    sw      t0, 0(s0) 
    addi    s0, s0, 0x4
    addi    t0, t0, 0x4
    sw      t0, 0(s0)
    addi    s0, s0, 0x4
    addi    t0, t0, 0x4
    sw      t0, 0(s0)

    lv      x0, 0(s1)
    sv      x0, 40(s1)
    lv      x1, 8(s1)
    sv      x1, 48(s1)
    lv      x2, 16(s1)

    xor3v   x5, x0, x1, x2
    xor3v   x6, x0, x1, x5
    xorrv   x7, x6
    rxorv   x8, x0, x1, x1
    rxorv   x9, x0, x1, x5
    rxorv   x10, x0, x1, x6
    xornav  x11, x8, x9, x10
    xor3v   x17, x0, x1, x2
    
    lui     t1, 0x20000
    sw      x0, 4(t1)

loop:
    j       loop