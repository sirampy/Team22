 ADDI a1, zero, 1
 ADDI a2, zero, 1
 SLL a1, a1, a2
 SLLI a1, a1, 1
 LW   a0, 0x1(a1)
 LB   a2, 0x1(a1)
 LH   a3, 0x1(a1)