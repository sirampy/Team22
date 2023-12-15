
rom_bin/f1-reloc.out:     file format elf32-littleriscv


Disassembly of section .text:

bfc00000 <init> (File Offset: 0x1000):
init():
bfc00000:	00000593          	addi	a1,zero,0
bfc00004:	0ff00613          	addi	a2,zero,255
bfc00008:	01400693          	addi	a3,zero,20
bfc0000c:	00000713          	addi	a4,zero,0
bfc00010:	00000793          	addi	a5,zero,0

bfc00014 <main> (File Offset: 0x1014):
main():
bfc00014:	00c000ef          	jal	ra,bfc00020 <lights_loop> (File Offset: 0x1020)
bfc00018:	02c000ef          	jal	ra,bfc00044 <turn_off> (File Offset: 0x1044)
bfc0001c:	fe0002e3          	beq	zero,zero,bfc00000 <init> (File Offset: 0x1000)

bfc00020 <lights_loop> (File Offset: 0x1020):
lights_loop():
bfc00020:	014000ef          	jal	ra,bfc00034 <lightdelay> (File Offset: 0x1034)
bfc00024:	00179793          	slli	a5,a5,0x1
bfc00028:	00178793          	addi	a5,a5,1
bfc0002c:	fec79ae3          	bne	a5,a2,bfc00020 <lights_loop> (File Offset: 0x1020)
bfc00030:	00008067          	jalr	zero,0(ra)

bfc00034 <lightdelay> (File Offset: 0x1034):
lightdelay():
bfc00034:	00170713          	addi	a4,a4,1
bfc00038:	fed71ee3          	bne	a4,a3,bfc00034 <lightdelay> (File Offset: 0x1034)
bfc0003c:	00050713          	addi	a4,a0,0
bfc00040:	00008067          	jalr	zero,0(ra)

bfc00044 <turn_off> (File Offset: 0x1044):
turn_off():
bfc00044:	00050793          	addi	a5,a0,0
bfc00048:	fedff0ef          	jal	ra,bfc00034 <lightdelay> (File Offset: 0x1034)
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
