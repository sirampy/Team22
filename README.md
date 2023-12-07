# Lab 4 completed:

## What needed doing:

- Many compile-time bugs and incompatibilities across sheets needed fixing - bit mismatches across sheets, misspelled variable names etc;
- Logical errors needed fixing - Typos in case-switches copied from lecture slide tables, incorrect concatenations etc;
- Implemented BNE;
- Implemented I-type instructions;
- Fixed instruction register, making it byte addressed, not word addressed, and an issue with it being too large;

To run, enter Team22 directory and write:

`./run.sh Lab4 top alu+regfile control pc memory`

# Stretch goal complete

## What is observed

As expected, we have the sine wave read from memory. Since the sinerom is stored as bytes but we are reading words, and since we are using little endian, after every read we have the a0[7:0] be the current sine value, and the 24 remaining bits have extra readings (a potential optimisation to remove memory reads would be to read word, then logical shift right 3 times, meaning we only do 0.25x the reads). The code also never reads memory location 255, jumping back to main loop after reading 254 (which is a logical error in the provided code, not a hardware fault). When we are at the final memory locations we can see the undefined memory (in our case just 0's) fill the most significant bits of a0 (8 bits for 253, 16 bits for 254).