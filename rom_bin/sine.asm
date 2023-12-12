
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
   0:	1e41                	c.addi	t3,-16
   2:	0000                	c.unimp
   4:	7200                	c.flw	fs0,32(a2)
   6:	7369                	c.lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <main-0xbfbfffec> (File Offset: 0x1030)
   c:	0014                	0x14
   e:	0000                	c.unimp
  10:	7205                	c.lui	tp,0xfffe1
  12:	3376                	c.fldsp	ft6,376(sp)
  14:	6932                	c.flwsp	fs2,12(sp)
  16:	7032                	c.flwsp	ft0,44(sp)
  18:	5f30                	c.lw	a2,120(a4)
  1a:	326d                	c.jal	fffff9c4 <__global_pointer$+0x403fe1a8> (File Offset: 0x9e0)
  1c:	3070                	c.fld	fa2,224(s0)
	...
