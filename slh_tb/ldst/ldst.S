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
    lw      t1, 0(s1)
    sw      t1, 0(s1)
    sv      x0, 40(s1)
    sw      t1, 0(s1)
    lv      x5, 8(s1)
    sv      x5, 80(s1)
    lv      x12, 16(s1)
    sv      x12, 120(s1)
    
    lui     t1, 0x20000
    sw      x0, 4(t1)

loop:
    j       loop