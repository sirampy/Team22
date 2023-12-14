import math
import string
f = open("rom_bin/data.mem","w")
data = open(f"test/pdf/triangle.mem","r")

# create 0x1000 offset
for i in range(0x10000):
    v = int(0) # initialise the memory to zeroes
    if (i+1)%16 == 0:
        s = "{hex:2X}\n"
    else:
        s = "{hex:2X} "
    f.write(s.format(hex=v))

lines = data.readlines()
for line in lines:
    f.write(line)

data.close()
f.close()