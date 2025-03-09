#!/bin/bash -ue
if [[ "error" == "error" ]]; then
	echo "Simulating failure..." >&2
	exit 1  # simulate a failure

fi 
echo "Processing value: error"
