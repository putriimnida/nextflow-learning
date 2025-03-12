#!/bin/bash -ue
mkdir -p results
awk '{print toupper($0)}' textfile.txt > results/modified_textfile.txt
