# F1 Program Implementation - Assembly Language
init:
    ADDI a1, zero, 0              #vbd flag value - trigger
    ADDI a2, zero, 11111111       # all lights are on
    ADDI a3, zero, 00001111       # THIS NEEDS DOING need to adjust to get 1s delay
    ADDI a4, zero, 0              # reset the count for light delay
    ADDI a5, zero, 0              # final output for turning on lights
main:
    BEQ a1, zero, main            # loop until s1 not equal 0 - ie vbdflag pressed
    JAL ra, lights_loop
    JAL ra, main
    
lights_loop:
    JAL ra, lightdelay            # 1s delay
    SLLI a5, a5, 1                # shifts t0 left
    ADDI a5, a5, 1                # adds 1 to t0
    BNE  a0, s2, lights_loop      # loops until all lights are on
    JAL ra, turn_off
    RET

lightdelay:
    ADDI  a4, a4, 1               # a4 acts as counter
    BNE   a1, a3, lightdelay
    ADDI  a1, zero, 0
    RET


turn_off:                        # wait some delay and turn off all lights
    JAL ra, lightdelay
    ADDI a5, zero, 0             # switch lights off
    RET