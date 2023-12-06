// F1 Program Implementation - Assembly Language
init:
    li s1, 0x0 // vbd flag value
    li s2, 0xFF // all lights are on
    li s3, 0x10 // need to adjust to get 1s delay

main:
    beq s1, zero, main // loop until s1 not equal 0 - ie vbdflag pressed
    jal ra, lights_loop
    jal ra, main
    
lights_loop:
    jal ra, lightdelay // 1s delay
    slli a0, a0, 0x1 // shifts t0 left
    addi a0, a0, 0x1 // adds 1 to t0
    bne  a0, s2, lights_loop // loops until all lights are on
    jal ra, turn_off
    ret

lightdelay:
    addi  a1, a1, 0x1 // a1 acts as counter
    bne   a1, s3, lightdelay
    addi  a1, zero, 0x0

turn_off: // wait some delay and turn off all lights
    jal ra, lightdelay
    li a0, 0x0
    ret
