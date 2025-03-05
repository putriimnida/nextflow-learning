#!/bin/bash -ue
mkdir -p results
awk -F',' 'NR==1 || $2 > 100 { print }' sample3.csv > results/processed_sample3.csv
