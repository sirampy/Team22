import math
import string
f = open("rom_bin/data.mem","w")
for i in range(256):
    v = int(0) # initialise the memory to zeroes
    if (i+1)%16 == 0:
        s = "{hex:2X}\n"
    else:
        s = "{hex:2X} "
    f.write(s.format(hex=v))

f.close()
