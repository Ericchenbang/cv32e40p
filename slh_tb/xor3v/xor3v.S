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

    xor3v   x3, x0, x1, x2
    xor3v   x4, x0, x1, x3
    
    lui     t1, 0x20000
    sw      x0, 4(t1)

loop:
    j       loop