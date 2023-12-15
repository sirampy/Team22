
rom_bin/alutest-reloc.out:     file format elf32-littleriscv


Disassembly of section .text:

bfc00000 <__BSS_END__-0x1038> (File Offset: 0x1000):
bfc00000:	00a00593          	addi	a1,zero,10
bfc00004:	00b58633          	add	a2,a1,a1
bfc00008:	00259513          	slli	a0,a1,0x2
bfc0000c:	40b605b3          	sub	a1,a2,a1
bfc00010:	00a5e5b3          	or	a1,a1,a0
bfc00014:	001005b7          	lui	a1,0x100
bfc00018:	00158593          	addi	a1,a1,1 # 100001 <__BSS_END__-0xbfb01037> (File Offset: 0xffffffff40501001)
bfc0001c:	00b5a023          	sw	a1,0(a1)
bfc00020:	0005a503          	lw	a0,0(a1)
bfc00024:	00a00593          	addi	a1,zero,10
bfc00028:	0005a503          	lw	a0,0(a1)
bfc0002c:	00b58023          	sb	a1,0(a1)
bfc00030:	0005a503          	lw	a0,0(a1)
bfc00034:	0005c503          	lbu	a0,0(a1)

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes> (File Offset: 0x1038):
   0:	1e41                	.2byte	0x1e41
   2:	0000                	.2byte	0x0
   4:	7200                	.2byte	0x7200
   6:	7369                	.2byte	0x7369
   8:	01007663          	bgeu	zero,a6,14 <__BSS_END__-0xbfc01024> (File Offset: 0x104c)
   c:	0014                	.2byte	0x14
   e:	0000                	.2byte	0x0
  10:	7205                	.2byte	0x7205
  12:	3376                	.2byte	0x3376
  14:	6932                	.2byte	0x6932
  16:	7032                	.2byte	0x7032
  18:	5f30                	.2byte	0x5f30
  1a:	326d                	.2byte	0x326d
  1c:	3070                	.2byte	0x3070
	...
