main:
    addi    t1, zero, 0xff
    addi    a0, zero, 0x0

mloop:
    addi    a1, zero, 0x0
    nop
    nop
    nop
    nop

iloop:
    addi    a0, a1, 0
    addi    a1, a1, 1
    bne     a1, t1, iloop
    bne     t1, zero, mloop
    