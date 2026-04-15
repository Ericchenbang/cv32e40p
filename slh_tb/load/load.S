.section .text.start
.global _start
.type _start, @function

_start:
    addi    t0, zero, 0x10
    addi    s0, zero, 0x200
    sw      t0, 0(s0) 
    addi    s0, s0, 0x1
    addi    t0, t0, 0x1
    sw      t0, 0(s0) 
    addi    s0, s0, 0x1
    addi    t0, t0, 0x1
    sw      t0, 0(s0) 
    addi    s0, s0, 0x1
    addi    t0, t0, 0x1
    sw      t0, 0(s0) 
    addi    s0, s0, 0x1
    addi    t0, t0, 0x1
    sw      t0, 0(s0) 
    addi    s0, zero, 0x200


loop:
    j       loop