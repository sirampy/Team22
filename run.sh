#!/bin/bash

MIN_PARAMS=3
if [ $# -lt $MIN_PARAMS ]
then
printf "Invalid usage! Please do:\n"
printf "./run.sh [lab_directory] [top_sv_file].sv [test_bench].cpp [include_directories... ]\n"
printf "e.g. ./run.sh Lab4 top.sv top_tb.cpp Dir1 Dir2 Dir3...\n"
exit 1
fi

# Enter into lab directory
cd $1

if [ $? -ne 0 ] 
then
printf "Fatal error! Cannot enter directory.\n"
exit 1
fi

# Verify top verilog file
VERILOG_TOP_FILE=$2
if [ ! -f $VERILOG_TOP_FILE ]
then 
printf "Fatal error! Cannot open top verilog file.\n"
exit 1
fi

# Verify testbench file
TB_FILE=$3
if [ ! -f $TB_FILE ]
then 
printf "Fatal error! Cannot open testbench file.\n"
exit 1
fi

# Get include dirs into one string

INCLUDE_DIRS=""
INCLUDE_DIRS_SEPERATOR=";"

i=4
while [ $i -le $# ]
do
    eval "cur=\$$i"
    INCLUDE_DIRS+="$cur$INCLUDE_DIRS_SEPERATOR"
    ((i+=1))
done

# printf "$INCLUDE_DIRS\n"

# -CFlags [str] <- use for vbuddy?
verilator -Wall --cc --trace --exe -Mdir "out/" $VERILOG_TOP_FILE $TB_FILE


