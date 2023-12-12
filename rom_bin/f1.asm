
rom_bin/f1-reloc.out:     file format elf32-littleriscv


Disassembly of section .text:

bfc00000 <init> (File Offset: 0x1000):
init():
bfc00000:	00050593          	addi	a1,a0,0
bfc00004:	0ff50613          	addi	a2,a0,255
bfc00008:	00550693          	addi	a3,a0,5
bfc0000c:	00050713          	addi	a4,a0,0
bfc00010:	00050793          	addi	a5,a0,0

bfc00014 <main> (File Offset: 0x1014):
main():
bfc00014:	008000ef          	jal	ra,bfc0001c <lights_loop> (File Offset: 0x101c)
bfc00018:	fea504e3          	beq	a0,a0,bfc00000 <init> (File Offset: 0x1000)

bfc0001c <lights_loop> (File Offset: 0x101c):
lights_loop():
bfc0001c:	018000ef          	jal	ra,bfc00034 <lightdelay> (File Offset: 0x1034)
bfc00020:	00179793          	slli	a5,a5,0x1
bfc00024:	00178793          	addi	a5,a5,1
bfc00028:	fec79ae3          	bne	a5,a2,bfc0001c <lights_loop> (File Offset: 0x101c)
bfc0002c:	018000ef          	jal	ra,bfc00044 <turn_off> (File Offset: 0x1044)
bfc00030:	00008067          	jalr	zero,0(ra)

bfc00034 <lightdelay> (File Offset: 0x1034):
lightdelay():
bfc00034:	00170713          	addi	a4,a4,1
bfc00038:	fed59ee3          	bne	a1,a3,bfc00034 <lightdelay> (File Offset: 0x1034)
bfc0003c:	00050593          	addi	a1,a0,0
bfc00040:	00008067          	jalr	zero,0(ra)

bfc00044 <turn_off> (File Offset: 0x1044):
turn_off():
bfc00044:	ff1ff0ef          	jal	ra,bfc00034 <lightdelay> (File Offset: 0x1034)
bfc00048:	00050793          	addi	a5,a0,0
bfc0004c:	00008067          	jalr	zero,0(ra)

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes> (File Offset: 0x1050):
   0:	1e41                	.2byte	0x1e41
   2:	0000                	.2byte	0x0
   4:	7200                	.2byte	0x7200
   6:	7369                	.2byte	0x7369
   8:	01007663          	bgeu	zero,a6,14 <init-0xbfbfffec> (File Offset: 0x1064)
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
