#!/bin/bash

if [ $# -eq 0 ]; then
    echo usage $0 files .. 
    exit 1
fi

# Add BOM to the newfile.
printf '\xEF\xBB\xBF' > $2

#append old file content to second file
cat $1 >> $2
