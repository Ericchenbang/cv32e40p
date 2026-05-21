    .section .text
    .globl KeccakF1600_rvslh
    .type KeccakF1600_rvslh, @function

# ============================================================
# void KeccakF1600_rvslh(uint64_t *state)
# a0 = state pointer
# ============================================================

KeccakF1600_rvslh:

    # --------------------------------------------------------
    # 1. Prologue (保存 callee-saved registers)
    # --------------------------------------------------------
    addi sp, sp, -64
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)

    # --------------------------------------------------------
    # 2. Load state (custom instruction)
    # --------------------------------------------------------
    .insn i 0x03, 0x7, x0, 0(a0)
    .insn i 0x03, 0x7, x1, 40(a0)
    .insn i 0x03, 0x7, x2, 80(a0)
    .insn i 0x03, 0x7, x3, 120(a0)
    .insn i 0x03, 0x7, x4, 160(a0)

    # --------------------------------------------------------
    # 3. round loop (24 rounds)
    # t0 = round counter
    # --------------------------------------------------------
    li t0, 24

.Lloop:

    # --- theta / custom ---
    .insn r4 0x1b, 0, 0, x5, x0, x1, x2
    .insn r4 0x1b, 0, 0, x5, x5, x3, x4
    .insn i  0x1b, 0x1, x5, x5, 0

    .insn r4 0x1b, 0, 0x1, x6, x0, x5, x0
    .insn r4 0x1b, 0, 0x1, x7, x1, x5, x1
    .insn r4 0x1b, 0, 0x1, x8, x2, x5, x2
    .insn r4 0x1b, 0, 0x1, x9, x3, x5, x3
    .insn r4 0x1b, 0, 0x1, x10, x4, x5, x4

    # pipeline break / nop
    .insn r4 0x1b, 0, 0, x0, x16, x16, x16
    nop

    # chi
    .insn r4 0x1b, 0, 0x2, x11, x7, x8, x6
    .insn r4 0x1b, 0, 0, x16, x11, x0, x16
    .insn r4 0x1b, 0, 0x2, x17, x8, x9, x7
    .insn r4 0x1b, 0, 0x2, x18, x9, x10, x8
    .insn r4 0x1b, 0, 0x2, x19, x10, x6, x9
    .insn r4 0x1b, 0, 0x2, x20, x6, x7, x10

    # round--
    addi t0, t0, -1
    bnez t0, .Lloop

    # --------------------------------------------------------
    # 4. Store state
    # --------------------------------------------------------
    .insn s 0x23, 0x7, x0, 0(a0)
    .insn s 0x23, 0x7, x1, 40(a0)
    .insn s 0x23, 0x7, x2, 80(a0)
    .insn s 0x23, 0x7, x3, 120(a0)
    .insn s 0x23, 0x7, x4, 160(a0)

    # --------------------------------------------------------
    # 5. Epilogue (restore registers)
    # --------------------------------------------------------
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    addi sp, sp, 64

    ret