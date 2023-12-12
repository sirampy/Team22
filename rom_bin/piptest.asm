
rom_bin/piptest-reloc.out:     file format elf32-littleriscv


Disassembly of section .text:

bfc00000 <addloop-0x40> (File Offset: 0x1000):
bfc00000:	00150593          	addi	a1,a0,1
bfc00004:	00250613          	addi	a2,a0,2
bfc00008:	00350693          	addi	a3,a0,3
bfc0000c:	00450713          	addi	a4,a0,4
bfc00010:	00a58633          	add	a2,a1,a0
bfc00014:	00a586b3          	add	a3,a1,a0
bfc00018:	00a586b3          	add	a3,a1,a0
bfc0001c:	00150593          	addi	a1,a0,1
bfc00020:	00250613          	addi	a2,a0,2
bfc00024:	00a50533          	add	a0,a0,a0
bfc00028:	00a58633          	add	a2,a1,a0
bfc0002c:	00350693          	addi	a3,a0,3
bfc00030:	00a50533          	add	a0,a0,a0
bfc00034:	00a586b3          	add	a3,a1,a0
bfc00038:	00050593          	addi	a1,a0,0
bfc0003c:	00350613          	addi	a2,a0,3

bfc00040 <addloop> (File Offset: 0x1040):
addloop():
bfc00040:	00158593          	addi	a1,a1,1
bfc00044:	fec59ee3          	bne	a1,a2,bfc00040 <addloop> (File Offset: 0x1040)

bfc00048 <subloop> (File Offset: 0x1048):
subloop():
bfc00048:	fff58593          	addi	a1,a1,-1
bfc0004c:	fea59ee3          	bne	a1,a0,bfc00048 <subloop> (File Offset: 0x1048)

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes> (File Offset: 0x1050):
   0:	1e41                	.2byte	0x1e41
   2:	0000                	.2byte	0x0
   4:	7200                	.2byte	0x7200
   6:	7369                	.2byte	0x7369
   8:	01007663          	bgeu	zero,a6,14 <addloop-0xbfc0002c> (File Offset: 0x1064)
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
