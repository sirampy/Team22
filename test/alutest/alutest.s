# testing a few instructions
 ADDI a1, zero, 10
 ADD a2, a1, a1
 SLLI a0, a1, 2
 SUB a1, a2, a1
 OR a1, a1, a0

 LUI a1, 0x00100
 ADDI a1, a1, 0x1
 SW a1, 0(a1)
 LW a0, 0(a1)

 ADDI a1, zero, 0xA
 LW a0, 0(a1)
 SB a1, 0(a1)
 LW a0, 0(a1)
 LBU a0, 0(a1)