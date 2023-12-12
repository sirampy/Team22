#test normal flow through
addi a1, a0, 1
addi a2, a0, 2
addi a3,a0,  3
addi a4, a0, 4
add a2, a1, a0
add a3, a1, a0
add a3, a1, a0
#test calling using nooop
addi a1, a0, 1
addi a2, a0, 2
add a0,a0,a0
add a2, a1, a0
addi a3,a0,  3
add a0,a0,a0
add a3, a1, a0
#test no noops 
addi a1, a0, 1
addi a2, a0, 2
add a2, a1, a0
addi a3,a0,  3
add a3, a1, a0
#branch testing
addi a1, a0, 0
addi a2, a0, 3
addloop:
    addi a1, a1, 1
    bne  a1, a2, addloop
subloop:
    addi a1, a1, -1
    bne  a1, a0, subloop