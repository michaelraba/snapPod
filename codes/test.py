#!/usr/bin/env python3

from pathlib import Path
import sys

# openfile
#
tt=str(1)
cc=str(1)
#for tt in range(0,500): # Loop open file
#    for cc in range(1,2): # Loop open file
    # paradigm: snap_cs_001_ts_0000.dat

    #    myPath = Path.cwd()  / dirNum / volCsStr
    #
        cc= str(cc).zfill(3)
        tt= str(tt).zfill(4)
        #myPath = '  \'"'  + str(myPath)   +   ' " \'    '
        myPath ='snap_cs_', cc, '_ts_', tt, '.dat'
        myPath = ''.join(map(str, myPath))
        myPath =   Path.cwd()  / myPath
        myPath = '  \'"'  + str(myPath)   +   ' " \'    '
