#!/bin/bash -ue
if [[ "2" == "error" ]]; then
	echo "Simulating failure..." >&2
	exit 1  # simulate a failure

fi 
echo "Processing value: 2"
