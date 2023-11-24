import math
import string
myfile=open("sinerom.mem,"w")
for i in range (1024):
    v=int(math.cos(2*3.14159*i/1024)*127+127)
    if (i+1)%32 ==0:
        s="{hex:2X}\n"
    else:
        s="{hex:2X} "
    myfile.write(s.format(hex=v))

myfile.close()

         
            