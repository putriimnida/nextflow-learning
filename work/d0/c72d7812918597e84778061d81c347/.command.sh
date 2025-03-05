#!/bin/bash -ue
mkdir -p results
awk -F',' 'NR==1 || $2 > 100 { print }' sample1.csv > results/processed_sample1.csv
