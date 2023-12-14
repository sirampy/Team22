 ADDI a1, zero, 10
 ADDI a1, zero, 0
 LUI a1, 0x00100
 SB      zero, x10000(a1)  #     mem[base_pdf+a1) = 0
 ADDI a2, zero, 5
 LUI  a1, 0x00000
 LBU  a0, x10000(a1)
 LUI  a1, 0x11111
 ADD a1, a1, a0
 LUI  a2, 255             # a2 = max index of pdf array
 ADDI a1, zero, 1
 LUI  a1, 0x56780
 LW   a0, 0x1(a1)
 LB   a2, 0x2(a1)
 LH   a1, 0x3(a1)
 SW   a0, 0x4(a1)