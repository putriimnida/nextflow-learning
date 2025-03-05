#!/bin/bash -ue
mkdir -p results
awk -F',' 'NR==1 || $2 > 100 { print }' sample2.csv > results/processed_sample2.csv
