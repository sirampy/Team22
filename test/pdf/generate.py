import math
import string

signal = input('''please chose 1 of:
(1) sine
(2) triangle
(3) gaussian
(4) noise\n''')

signal_filename = ""

match signal:
    case "1": signal_filename = "sine.mem"
    case "2": signal_filename = "triangle.mem"
    case "3": signal_filename = "gaussian.mem"
    case "4": signal_filename = "noise.mem"
    case _: exit("ERROR: invalid optoin")

f = open("rom_bin/data.mem","w")
data = open(f"test/pdf/{signal_filename}","r")

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