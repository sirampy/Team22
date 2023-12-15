#!/bin/bash

MIN_PARAMS=2
if [ $# -lt $MIN_PARAMS ]
then
    printf "Invalid usage! Please do:\n"
    printf "./run.sh [lab_directory] [top_sv_file] [include_directories... ]\n"
    printf "e.g. ./run.sh Lab4 top Dir1 Dir2 Dir3...\n"
    printf "Please note: Given a top sv file of top.sv, you want your testbench to be top_tb.cpp and the include to be Vtop.h\n"
    exit 1
fi

# Enter into lab directory
cd $1

if [ $? -ne 0 ] 
then
    printf "Fatal error! Cannot enter directory ($1).\n"
    exit 1
fi

TOP_FILE_BASE=$2

# Verify top verilog file
VERILOG_TOP_FILE="${TOP_FILE_BASE}.sv"
if [ ! -f $VERILOG_TOP_FILE ]
then 
    printf "Fatal error! Cannot open top verilog file ($VERILOG_TOP_FILE).\n"
    exit 1
fi

# Verify testbench file
TB_FILE="${TOP_FILE_BASE}_tb.cpp"
if [ ! -f $TB_FILE ]
then 
    printf "Fatal error! Cannot open testbench file ($TB_FILE).\n"
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

make -j -C out/ -f "V$TOP_FILE_BASE.mk" "V$TOP_FILE_BASE"

printf "\n\nCompilation successful! Press enter to run.\n"
read -p ""

eval "./out/V$TOP_FILE_BASE"

printf "\n\nRunning complete! Press enter to see waves.\n"
read -p ""

gtkwave "$TOP_FILE_BASE.vcd"