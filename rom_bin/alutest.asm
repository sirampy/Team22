
rom_bin/alutest-reloc.out:     file format elf32-littleriscv


Disassembly of section .text:

bfc00000 <__BSS_END__-0x101c> (File Offset: 0x1000):
bfc00000:	00100593          	addi	a1,zero,1
bfc00004:	00100613          	addi	a2,zero,1
bfc00008:	00c595b3          	sll	a1,a1,a2
bfc0000c:	00159593          	slli	a1,a1,0x1
bfc00010:	0015a503          	lw	a0,1(a1)
bfc00014:	00158503          	lb	a0,1(a1)
bfc00018:	00159503          	lh	a0,1(a1)

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes> (File Offset: 0x101c):
   0:	1e41                	.2byte	0x1e41
   2:	0000                	.2byte	0x0
   4:	7200                	.2byte	0x7200
   6:	7369                	.2byte	0x7369
   8:	01007663          	bgeu	zero,a6,14 <__BSS_END__-0xbfc01008> (File Offset: 0x1030)
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
