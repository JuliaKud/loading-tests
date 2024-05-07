#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <binary_file> <filesize_mb> <max_threads> [-i]"
    exit 1
fi

programme="$1"
filesize_mb="$2"
max_threads="$3"

if [ -e "file.txt" ]; then
    rm file.txt
fi

size_bytes=$((filesize_mb * 1024 * 1024))
fallocate -l "$size_bytes" file.txt

> time_res.txt

mkdir copies

if [[ "$4" == "-i" ]]; then
    if [ -e "iostat_output.txt" ]; then
        > iostat_output.txt
    fi
    iostat -m -d 1 > iostat_output.txt & iostat_pid=$!
fi

for ((threads = 1; threads <= max_threads; threads++)); do
    args1=""
    args2=""
    for ((i = 1; i <= threads; i++)); do
        args1+=" file.txt"
        args2+=" copies/$i.txt"
    done
    echo "Threads: $threads" >> time_res.txt
    (time parallel "$programme" ::: $args1 ::: $args2) 2>> time_res.txt
done

if [[ "$4" == "-i" ]]; then
    kill $iostat_pid
fi

python3 visualize_time_res.py filesize_mb

rm file.txt
# rm time_res.txt
rm -r "copies"
