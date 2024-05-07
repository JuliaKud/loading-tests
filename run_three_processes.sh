#!/bin/bash

set -x
iostat -d 1 > iostat_output.txt &
/home/xovotat/julius/git_repos/biopattern/src/biopattern -T 1 2000 > biopattern_output.txt 2>&1 &
./run_cp.sh 100 20 &

wait $!

pkill -P $$ iostat
pkill -P $$ biopattern
