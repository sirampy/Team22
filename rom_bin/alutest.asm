
rom_bin/alutest-reloc.out:     file format elf32-littleriscv


Disassembly of section .text:

bfc00000 <__BSS_END__-0x102c> (File Offset: 0x1000):
bfc00000:	00a00593          	addi	a1,zero,10
bfc00004:	00500613          	addi	a2,zero,5
bfc00008:	111115b7          	lui	a1,0x11111
bfc0000c:	00a585b3          	add	a1,a1,a0
bfc00010:	000ff637          	lui	a2,0xff
bfc00014:	00100593          	addi	a1,zero,1
bfc00018:	567805b7          	lui	a1,0x56780
bfc0001c:	0015a503          	lw	a0,1(a1) # 56780001 <__BSS_END__-0x6948102b> (File Offset: 0xffffffff96b81001)
bfc00020:	00258603          	lb	a2,2(a1)
bfc00024:	00359583          	lh	a1,3(a1)
bfc00028:	00a5a223          	sw	a0,4(a1)

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes> (File Offset: 0x102c):
   0:	1e41                	.2byte	0x1e41
   2:	0000                	.2byte	0x0
   4:	7200                	.2byte	0x7200
   6:	7369                	.2byte	0x7369
   8:	01007663          	bgeu	zero,a6,14 <__BSS_END__-0xbfc01018> (File Offset: 0x1040)
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
