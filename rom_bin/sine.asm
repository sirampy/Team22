
rom_bin/sine-reloc.out:     file format elf32-littleriscv


Disassembly of section .text:

bfc00000 <main> (File Offset: 0x1000):
main():
bfc00000:	0ff00313          	addi	t1,zero,255
bfc00004:	00000513          	addi	a0,zero,0

bfc00008 <mloop> (File Offset: 0x1008):
mloop():
bfc00008:	00000593          	addi	a1,zero,0

bfc0000c <iloop> (File Offset: 0x100c):
iloop():
bfc0000c:	0005c503          	lbu	a0,0(a1)
bfc00010:	00158593          	addi	a1,a1,1
bfc00014:	fe659ce3          	bne	a1,t1,bfc0000c <iloop> (File Offset: 0x100c)
bfc00018:	fe0318e3          	bne	t1,zero,bfc00008 <mloop> (File Offset: 0x1008)

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes> (File Offset: 0x101c):
   0:	1e41                	.2byte	0x1e41
   2:	0000                	.2byte	0x0
   4:	7200                	.2byte	0x7200
   6:	7369                	.2byte	0x7369
   8:	01007663          	bgeu	zero,a6,14 <main-0xbfbfffec> (File Offset: 0x1030)
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
